//
//  FYTestView.m
//  TouchTracker
//
//  Created by feiyangzhang on 15/8/7.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import "TBCreateGesture1.h"
#import "TBGestureRecognizer.h"
#import "FYEventData.h"
#import "TBGesture.h"
#import "TBDataManager.h"
#import "Point.h"
@interface TBCreateGesture1()<UIAlertViewDelegate>
@property(nonatomic,weak) UILabel* createOperation;
@property(nonatomic,weak) UILabel* operation;
@property(nonatomic,strong) NSMutableArray* pointArray;
@property(nonatomic,weak) UILabel* label;

@property (nonatomic, strong) NSMutableArray *points;
@end

@implementation TBCreateGesture1

-(NSMutableArray *)pointArray
{
    if (_pointArray == nil) {
        _pointArray = [NSMutableArray array];
    }
    return _pointArray;
}

- (NSMutableArray *)points {
    if (_points == nil) {
        _points = [NSMutableArray array];
    }
    return _points;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
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
        
        
        //设置绘图颜色、透明度、线宽
        self.backgroundColor = [UIColor lightGrayColor];
//        self.alpha = 0.5;
        _lineColor = [UIColor blueColor];
        _lineWidth = 20.0f;
        
        //添加点击事件，如果是点击事件，直接消失画板
        UITapGestureRecognizer* tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tapGr];
        
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.pointArray.count) {
        [self.pointArray removeAllObjects];
    }
    if (self.points.count) {
        [self.points removeAllObjects];
    }
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    
    
    _path = CGPathCreateMutable();
    _isHavePath = YES;
    CGPathMoveToPoint(_path, NULL, location.x, location.y);
    [self setNeedsDisplay];
    
    
    
    [self.pointArray addObject:[NSValue valueWithCGPoint:location]];
    [self.points addObject:[[RLMPoint alloc] initWithCGPoint:location]];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    //    NSLog(@"%@",NSStringFromCGPoint(location));
    
    [self.pointArray addObject:[NSValue valueWithCGPoint:location]];
    [self.points addObject:[[RLMPoint alloc] initWithCGPoint:location]];
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    
    self.capture = [self clipImageOn:self.frame];

    if ([self.delegate respondsToSelector:@selector(gestureDidDrawAtPosition:)]) {
        [self.delegate gestureDidDrawAtPosition:[self.points copy]];
    }
    
    [self.pointArray removeAllObjects];
    
    [self removeFromSuperview];
    CGPathRelease(_path);
    _isHavePath = NO;
}

//截图
-(void)clipImage:(NSString*)guestureId
{
    UIGraphicsBeginImageContext(self.frame.size);
    CGRect r = CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height-30);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //保存
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",guestureId]];   // 保存文件的名称
    [UIImagePNGRepresentation(theImage) writeToFile:filePath atomically:YES]; // 保存成功会返回YES
    
}

- (UIImage *)clipImageOn:(CGRect)frame {
    UIGraphicsBeginImageContext(self.frame.size);
    CGRect r = CGRectMake(0, 50, self.bounds.size.width, self.bounds.size.height-30);
    r =  frame;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [self.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)alertFail
{
    UILabel* label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"您输入的手势已被占用，请重新输入";
    label.textAlignment = NSTextAlignmentCenter;
    
    label.frame = self.bounds;
    self.label = label;
    [self addSubview:label];
    label.alpha = 0.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        label.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            label.alpha = 0.0;
        }];
    }];
    self.label = nil;
}

/**
 *  画图
 *
 *  @param rect 绘图区域
 */
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //起点画圆
    if (self.pointArray.count) {
        CGContextSaveGState(context);
        NSValue* p = [self.pointArray firstObject];
        CGPoint location = [p CGPointValue];
        [[UIColor redColor] set];
        CGContextAddArc(context, location.x, location.y, 30, 0, 2*M_PI, 0); //添加一个圆
        CGContextDrawPath(context, kCGPathFill);//绘制填充
        CGContextRestoreGState(context);
    }
    [self drawView:context];
}
-(void)drawView:(CGContextRef)context
{
    if (_isHavePath) {
        CGContextAddPath(context, _path);
        [_lineColor set];
        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}
@end
