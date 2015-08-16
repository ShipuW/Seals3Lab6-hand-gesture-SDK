//
//  SmoothLineView.m
//  Smooth Line View
//
//  Created by Levi Nunnink on 8/15/11.
//  Copyright 2011 culturezoo. All rights reserved.
//

#import "TBCreateGesture.h"
#import <QuartzCore/QuartzCore.h>
#import "Point.h"

#define DEFAULT_COLOR [UIColor blueColor]
#define DEFAULT_WIDTH 10.0f
#define BEGIN_POINT_RADIUS 10
#define MIN_POINTS 20

@interface TBCreateGesture ()

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2);
@property(nonatomic,weak) UILabel* createOperation;
@property(nonatomic,weak) UILabel* operation;
@property(nonatomic,weak) UILabel* label;
@property(nonatomic,strong) NSMutableArray* points;

@end

@implementation TBCreateGesture

#pragma mark -

-(void)setup
{
    self.lineWidth = DEFAULT_WIDTH;
    self.lineColor = DEFAULT_COLOR;
}

- (NSMutableArray *)points {
    if (_points == nil) {
        _points = [NSMutableArray array];
    }
    return _points;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        
        //给视图添加两个label，用于说明
        UILabel* label1 = [[UILabel alloc] init];
        label1.text = @"创建新手势";
        label1.textAlignment = NSTextAlignmentCenter;
        self.createOperation = label1;
        [self addSubview:label1];
        
        UILabel* label2 = [[UILabel alloc] init];
        label2.backgroundColor = [UIColor grayColor];
        self.operation = label2;
        [self addSubview:label2];

        //添加点击事件，如果是点击事件，直接消失画板
        UITapGestureRecognizer* tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGr];
        
        [self setup];
    }
    return self;
}
/**
 *  设置子控件大小
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = self.frame.size.width;
    CGFloat h = 20;
    self.createOperation.frame = CGRectMake(x, y, w, h);
    
    self.operation.frame = CGRectMake(x, CGRectGetMaxY(self.createOperation.frame), w, 25);
}

-(void)tap:(UITapGestureRecognizer*)gr
{
    [self removeFromSuperview];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    UITouch *touch = [touches anyObject];
    
    if (self.points.count) {
        [self.points removeAllObjects];
    }
    
    CGPoint location = [touch locationInView:self];
    [self.points addObject:[[RLMPoint alloc] initWithCGPoint:location]];
    [self setNeedsDisplay];

    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    [self touchesMoved:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch  = [touches anyObject];
    /**
     *  采集点数
     */
    CGPoint location = [touch locationInView:self];
    [self.points addObject:[[RLMPoint alloc] initWithCGPoint:location]];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = [touch previousLocationInView:self];
    currentPoint    = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1    = midPoint(previousPoint1, previousPoint2); 
    CGPoint mid2    = midPoint(currentPoint, previousPoint1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 1;
    drawBox.origin.y        -= self.lineWidth * 1;
    drawBox.size.width      += self.lineWidth * 2;
    drawBox.size.height     += self.lineWidth * 2;
    
    UIGraphicsBeginImageContext(drawBox.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	curImage = UIGraphicsGetImageFromCurrentImageContext();
    [[UIColor blueColor] set];
	UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.points.count<MIN_POINTS) {
        [self.points removeAllObjects];
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您画的点数太少，请多画一些" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
    self.capture = [self clipImageOn:self.frame];
    
    if ([self.delegate respondsToSelector:@selector(gestureDidDrawAtPosition:)]) {
        [self.delegate gestureDidDrawAtPosition:[self.points copy]];
    }

    [self removeFromSuperview];
    }
}

- (UIImage *)clipImageOn:(CGRect)frame {
    UIGraphicsBeginImageContext(self.frame.size);
    CGRect r = CGRectMake(0, 45, self.bounds.size.width, self.bounds.size.height-30);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //起点画圆
    if (self.points.count) {
        CGContextSaveGState(context);
        RLMPoint* p = [self.points firstObject];
        [[UIColor redColor] set];
        CGContextAddArc(context, p.x, p.y, BEGIN_POINT_RADIUS, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFill);//绘制填充
        CGContextRestoreGState(context);
    }
    
    [curImage drawAtPoint:CGPointMake(0, 0)];
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);

    
    [self.layer renderInContext:context];

    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y); 
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);

    CGContextStrokePath(context);

    [super drawRect:rect];
    
    curImage = nil;
    
}

- (void)dealloc
{
    self.lineColor = nil;
}

@synthesize lineColor,lineWidth;
@end


