//
//  LineView.m
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/14.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import "LineView.h"
#import <Foundation/Foundation.h>
#import "MyViewModel.h"
#import "RLMEvent.h"


@implementation LineView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        //self.alpha = 0.5;
        _lineWidth = 10.0f;
        _lineColor = [UIColor redColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    _context = UIGraphicsGetCurrentContext();
    [self drawView:_context];
}
- (void)drawView:(CGContextRef)context
{
//    for (MyViewModel *myViewModel in _pathArray) {
//        CGContextAddPath(context, myViewModel.path.CGPath);
//        [myViewModel.color set];
//        CGContextSetLineWidth(context, myViewModel.width);
//        CGContextSetLineCap(context, kCGLineCapRound);
//        CGContextDrawPath(context, kCGPathStroke);
//    }
    if (_isHavePath) {
        CGContextAddPath(context, _path);
        [_lineColor set];
        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}
- (void)setWidth:(CGFloat)w
{
    CGContextSetLineWidth(_context, w);
}


@end
