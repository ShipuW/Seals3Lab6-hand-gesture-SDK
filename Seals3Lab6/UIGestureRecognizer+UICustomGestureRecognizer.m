//
//  UIGestureRecognizer+UICustomGestureRecognizer.m
//  LongPressDrag
//
//  Created by 王士溥 on 15/8/5.
//  Copyright (c) 2015年 王士溥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGPath.h>
#import "TBGestureRecognizer.h"
#import "MyView.h"
#import "UIGestureRecognizer+UICustomGestureRecognizer.h"
#import "PostConnection.h"
#define Duration 0.5 //长按响应时间




@implementation UICustomGestureRecognizer:UILongPressGestureRecognizer


- (instancetype)initWithTarget:(id)target action:(SEL)action{
    _displayPoint = NO;
    _shouldEnd = NO;
    _isSimpleGesture = YES;
    _target = target;
    _action = action;
    
    self = [super initWithTarget:self action:@selector(buttonLongPressed:)];
    if (self) {
        self.minimumPressDuration = Duration;
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minimumPressDuration = Duration;
    }
    return self;
}

-(void) simpleDirectionRecognizer{
    CGFloat deltaX = _touchPoint.x - _startPoint.x;
    CGFloat deltaY = _touchPoint.y - _startPoint.y;
    if (deltaY == 0) {
        deltaY = 1;
    }
    CGFloat ratioXY = deltaX/deltaY;
    if (fabs(deltaX) < 50 && fabs(deltaY) < 50) {
        _gestureId = @"gesture failed";
        return;
    }else{
        if (ratioXY > 2 || ratioXY < -2) {
            if (deltaX > 0) {
                _direction = UICustomGestureRecognizerDirectionRight;
                _gestureId = @"simple right";
            }else if (deltaX < 0){
                _direction = UICustomGestureRecognizerDirectionLeft;
                _gestureId = @"simple left";
            }
        }else if (ratioXY < 0.5 && ratioXY > -0.5){
            if (deltaY > 0) {
                _direction = UICustomGestureRecognizerDirectionDown;
                _gestureId = @"simple down";
            }else if (deltaY < 0){
                _direction = UICustomGestureRecognizerDirectionUp;
                _gestureId = @"simple up";
            }
        }else {
            _gestureId = @"gesture failed";
        }
    }
}




- (NSMutableArray *)trackPoints {
    if (!_trackPoints) {
        _trackPoints = [NSMutableArray array];
    }
    return _trackPoints;
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    _baseView=sender.view;
    while (YES) {
        if (_baseView.superview == nil) {
            break;
        }
        _baseView = _baseView.superview;
    }
    
    
    UIView *view = (UIView *)sender.view;
    if (_shouldEnd) {
        
    }else{
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            _direction = UICustomGestureRecognizerDirectionNot;
            if (self.trackPoints.count > 0) {
                self.trackPoints = [NSMutableArray array];
            }
            _startPoint = [sender locationInView:_baseView];
            _originPoint = view.center;
            _myView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, _baseView.bounds.size.width, _baseView.bounds.size.height) ];
            [UIView animateWithDuration:Duration animations:^{
                
                view.transform = CGAffineTransformMakeScale(1.1, 1.1);
                view.alpha = 0.7;
                
            }];
            //[maskEffect addSpotlightInView:self.view.superview atPoint:CGPointMake(1000, 1000) ];
            
            [_baseView addSubview:_myView];
            _myView.path = CGPathCreateMutable();
            _myView.isHavePath = YES;
            CGPathMoveToPoint(_myView.path, NULL, _startPoint.x, _startPoint.y);
            _displayPoint=YES;
            if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:stateBeginAtPosition:)]) {
                [self.recognizeDelegate gestureRecognizer:self stateBeginAtPosition:_startPoint];
            }
            
        }
        else if (sender.state == UIGestureRecognizerStateChanged)
        {
            
            
            _touchPoint = [sender locationInView:_baseView];
            view.center = CGPointMake(_originPoint.x + _touchPoint.x - _startPoint.x,_originPoint.y + _touchPoint.y - _startPoint.y);
            if (_displayPoint) {
                [self.trackPoints addObject:[NSValue valueWithCGPoint:_touchPoint]];
                //NSLog(@"CGPointZero=%@",NSStringFromCGPoint(_touchPoint));
            }else{
                _shouldEnd = YES;
            }
            CGPathAddLineToPoint(_myView.path, NULL, _touchPoint.x,_touchPoint.y);
            [_myView setNeedsDisplay];
            if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:stateChangedAtPosition:)]) {
                [self.recognizeDelegate gestureRecognizer:sender stateChangedAtPosition:_touchPoint];
            }
        }
        else if (sender.state == UIGestureRecognizerStateEnded)
        {
            //NSLog(@"%f",[[NSDate date]timeIntervalSince1970]);
            
            if (_isSimpleGesture) {
                [self simpleDirectionRecognizer];
            } else if (!_isSimpleGesture){
                [[TBGestureRecognizer shareGestureRecognizer] matchGestureFrom:_trackPoints completion:^(NSString *gestureId, NSArray *resampledGesture) {
                    _gestureId = gestureId;
                    //NSLog(@"%@",_gestureId);
                }];
            }
            
            [PostConnection PostGestureWithAction:@"1" UsrId:@"123" EventId:@"collection" Points:_trackPoints];
            
            //NSLog(@"%f",[[NSDate date]timeIntervalSince1970]);
            
            [UIView animateWithDuration:Duration animations:^{
                [_myView removeFromSuperview];
                view.transform = CGAffineTransformIdentity;
                view.alpha = 1.0;
                if (!_contain)
                {
                    view.center = _originPoint;
                }
            }];
            _displayPoint=NO;
            ///////实现原回调
            if (self.action != nil) {
                [self.target performSelector:self.action withObject:self afterDelay:0.0];
            }
            CGPoint lastPoint = [sender locationInView:_baseView];
            if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:stateEndAtPosition:)]) {
                [self.recognizeDelegate gestureRecognizer:sender stateEndAtPosition:lastPoint];
            }
            
        }
    }
    _shouldEnd = NO;
}





@end
