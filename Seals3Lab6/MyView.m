//
//  MyView.m
//  LongPressDrag
//
//  Created by 王士/Users/wangshipu/Desktop/LongPressDrag/LongPressDrag/AppDelegate.h溥 on 15/8/5.
//  Copyright (c) 2015年 王士溥. All rights reserved.
//

#import "MyView.h"
#import "MyViewModel.h"

@interface MyView ()

@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        self.alpha = 0.5;
        _lineWidth = 10.0f;
        _lineColor = [UIColor redColor];
       
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}
- (void)drawView:(CGContextRef)context
{
    for (MyViewModel *myViewModel in _pathArray) {
        CGContextAddPath(context, myViewModel.path.CGPath);
        [myViewModel.color set];
        CGContextSetLineWidth(context, myViewModel.width);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
    if (_isHavePath) {
        CGContextAddPath(context, _path);
        [_lineColor set];
        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint location =[touch locationInView:self];
//    _path = CGPathCreateMutable();
//    _isHavePath = YES;
//    CGPathMoveToPoint(_path, NULL, location.x, location.y);
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint location = [touch locationInView:self];
//    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
//    [self setNeedsDisplay];
//}
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if (_pathArray == nil) {
//        _pathArray = [NSMutableArray array];
//    }
// 
//    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_path];
//    MyViewModel *myViewModel = [MyViewModel viewModelWithColor:_lineColor Path:path Width:_lineWidth];
//    [_pathArray addObject:myViewModel];
//    
//    CGPathRelease(_path);
//    _isHavePath = NO;
//}
@end



