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
#import "LineView.h"
#import "UIGestureRecognizer+UICustomGestureRecognizer.h"
#import "PostConnection.h"
#import "MacroUtils.h"
#import "Point.h"
#import "RLMGesture.h"
#import "RLMEvent.h"
#import "MyViewModel.h"

#define Duration 0.3 //长按响应时间

@interface UICustomGestureRecognizer ()

@property NSMutableArray<RLMPoint> *rlmPoints;

@end


@implementation UICustomGestureRecognizer:UILongPressGestureRecognizer


- (instancetype)initWithTarget:(id)target action:(SEL)action type:(TBGestureType)type{
    _direction = UICustomGestureRecognizerDirectionNot;
    _displayPoint = NO;
    _shouldEnd = NO;
    _isSimpleGesture = NO;
    _target = target;
    _action = action;
    _targetType = type;
    _DynamicWidth = 1.0f;
    _index = 10;
    if ((_targetType & TBGestureTypeCustom) == TBGestureTypeCustom) {
        _isSimpleGesture = NO;
        _needSimpleMatch = YES;
    }else{
        _needSimpleMatch = YES;
        _isSimpleGesture = YES;
    }
    
    
    self = [super initWithTarget:self action:@selector(buttonLongPressed:)];
    if (self) {
        self.minimumPressDuration = Duration;
        _rlmPoints = (NSMutableArray<RLMPoint> *)[NSMutableArray array];
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


-(BOOL) simpleEndLocationRecognizer{

    
    if ((_lastPoint.x > _emptySideLenth) && (_lastPoint.x < (_baseView.frame.size.width - _emptySideLenth))){
        
        if (_lastPoint.y < _emptySideLenth) {//UP
            _direction = UICustomGestureRecognizerDirectionUp;
            _gestureId = @"simple up";
            return YES;
            //_isSimpleGesture = YES;
        }else if (_lastPoint.y > (_baseView.frame.size.height - _emptySideLenth)){//DOWN
            _direction = UICustomGestureRecognizerDirectionDown;
            _gestureId = @"simple down";
            return YES;
            //_isSimpleGesture = YES;
        }else{//no
            _direction = UICustomGestureRecognizerDirectionNot;
            _gestureId = @"gesture failed";
            return NO;
            //_isSimpleGesture = NO;
        }
        
    }else if((_lastPoint.y > _emptySideLenth) && (_lastPoint.y < (_baseView.frame.size.height - _emptySideLenth))){
    
        if (_lastPoint.x < _emptySideLenth) {//LEFT
            _direction = UICustomGestureRecognizerDirectionLeft;
            _gestureId = @"simple left";
            return YES;
            //_isSimpleGesture = YES;
        }else if(_lastPoint.x > (_baseView.frame.size.width - _emptySideLenth)){//RIGHT
            _direction = UICustomGestureRecognizerDirectionRight;
            _gestureId = @"simple right";
            return YES;
            //_isSimpleGesture = YES;
        }else{//no
            _direction = UICustomGestureRecognizerDirectionNot;
            _gestureId = @"gesture failed";
            return NO;
            //_isSimpleGesture = NO;
        }
    
    }else{//no
        _direction = UICustomGestureRecognizerDirectionNot;
        _gestureId = @"gesture failed";
        return NO;
        //_isSimpleGesture = NO;
    }
    
    
//    if ((_targetType & _direction) == _direction) {
//        //        [self.recognizeDelegate gestureRecognizer:self gestureType:(TBGestureType)_direction recognized:YES];
//        [self.recognizeDelegate gestureRecognizer:self gestureType:(TBGestureType)_direction  gestureId:(int)_direction  recognized:YES];
//        // _isSimpleGesture = YES;
//    }
//    else {
//        
//        if ((_targetType & TBGestureTypeCustom) != TBGestureTypeCustom) {
//            debugLog(@"内部失败");
//            if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:gestureType:recognized:)]) {
//                [self.recognizeDelegate gestureRecognizer:self gestureType:0 recognized:NO];
//            }
//        }
//        
//        
//        // _isSimpleGesture = NO;
//    }
//    return;

}


-(void) simpleDirectionRecognizer{
    CGFloat deltaX = _lastPoint.x - _startPoint.x;
    CGFloat deltaY = _lastPoint.y - _startPoint.y;
    if (deltaY == 0) {
        deltaY = 1;
    }
    if (deltaX == 0) {
        deltaX = 1;
    }
    CGFloat ratioXY = deltaX/deltaY;
    if (fabs(deltaX) < 50 && fabs(deltaY) < 50) {
        _direction = UICustomGestureRecognizerDirectionNot;
        _gestureId = @"gesture failed";
        //_isSimpleGesture = NO;
        return;
    }else{
        if (ratioXY > 2 || ratioXY < -2) {
            if (deltaX > 0) {
                _direction = UICustomGestureRecognizerDirectionRight;
                //_isSimpleGesture =
                _gestureId = @"simple right";
                //_isSimpleGesture = YES;
            }else if (deltaX < 0){
                _direction = UICustomGestureRecognizerDirectionLeft;
                _gestureId = @"simple left";
                //_isSimpleGesture = YES;
            }
        }else if (ratioXY < 0.5 && ratioXY > -0.5){
            if (deltaY > 0) {
                _direction = UICustomGestureRecognizerDirectionDown;
                _gestureId = @"simple down";
                //_isSimpleGesture = YES;
            }else if (deltaY < 0){
                _direction = UICustomGestureRecognizerDirectionUp;
                _gestureId = @"simple up";
                //_isSimpleGesture = YES;
            }
        }else {
            _gestureId = @"gesture failed";
            //_isSimpleGesture = NO;
        }
    }
    


}

-(BOOL) confirmDirectionRecognizer:(RLMPoint *)midPoint{
    CGFloat deltaX = midPoint.x - _startPoint.x;
    CGFloat deltaY = midPoint.y - _startPoint.y;
    if (deltaY == 0) {
        deltaY = 1;
    }
    if (deltaX == 0) {
        deltaX = 1;
    }
    CGFloat ratioXY = deltaX/deltaY;
    if (ratioXY > 2 || ratioXY < -2) {
        if (deltaX > 0) {
            if(_direction == UICustomGestureRecognizerDirectionRight){
                return YES;
            }else{
                return NO;
            }
        }else if (deltaX < 0){
            if(_direction == UICustomGestureRecognizerDirectionLeft){
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }else if (ratioXY < 0.5 && ratioXY > -0.5){
        if (deltaY > 0) {
            if(_direction == UICustomGestureRecognizerDirectionDown){
                return YES;
            }else{
                return NO;
            }
        }else if (deltaY < 0){
            if(_direction == UICustomGestureRecognizerDirectionUp){
                return YES;
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }else {
        return NO;
    }
}


//- (NSMutableArray<RLMPoint> *)rlmPoints {
//    if (!_rlmPoints) {
//        _rlmPoints = (NSMutableArray<RLMPoint> *)[NSMutableArray array];
//    }
//    return _rlmPoints;
//}

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
    _baseViewCenter = _baseView.center;
    _emptySideLenth = (_baseViewCenter.x - 0)/2;
    
    UIView *view = (UIView *)sender.view;
    if (_shouldEnd) {
        
    }else{
        
        if (sender.state == UIGestureRecognizerStateBegan)
        {
            //[_myView removeAllLineView];
            [_rlmPoints removeAllObjects];
            _isMoved = NO;
            _direction = UICustomGestureRecognizerDirectionNot;
            if (self.trackPoints.count > 0) {
                self.trackPoints = [NSMutableArray array];
            }
            _startPoint = [sender locationInView:_baseView];
            [self.rlmPoints addObject:[[RLMPoint alloc] initWithValue:@[@(_startPoint.x), @(_startPoint.y)]]];
            _originPoint = view.center;
            //_myView = [[MyView alloc] initWithTint:CGRectMake(0, 0, _baseView.bounds.size.width, _baseView.bounds.size.height) tint:[self eventsForTypes:_targetType] baseViewFrame:_baseView.frame emptySideLength:_emptySideLenth];
            _myView = [MyView sharedView];
            if ([self needShowTint]) {
                [_myView updateWithFrame:CGRectMake(0, 0, _baseView.bounds.size.width, _baseView.bounds.size.height) tint:[self eventsForTypes:_targetType] baseViewFrame:_baseView.frame emptySideLength:_emptySideLenth];
            }
            //[_myView updateWithFrame:CGRectMake(0, 0, _baseView.bounds.size.width, _baseView.bounds.size.height) tint:[self eventsForTypes:_targetType] baseViewFrame:_baseView.frame emptySideLength:_emptySideLenth];
             
            _lineView = [_myView addLineViewWithFrame:_baseView.frame];
            
            [UIView animateWithDuration:Duration animations:^{
                
                view.transform = CGAffineTransformMakeScale(1.1, 1.1);
                view.alpha = 0.7;
                
            }];
            //[maskEffect addSpotlightInView:self.view.superview atPoint:CGPointMake(1000, 1000) ];
            
            [_baseView addSubview:_myView];
            _lineView.path = CGPathCreateMutable();
            
            _lineView.isHavePath = YES;
            CGPathMoveToPoint(_lineView.path, NULL, _startPoint.x, _startPoint.y);
            
            _displayPoint=YES;
            if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:stateBeginAtPosition:)]) {
                [self.recognizeDelegate gestureRecognizer:self stateBeginAtPosition:_startPoint];
            }
            
        }
        else if (sender.state == UIGestureRecognizerStateChanged)
        {
            
            _isMoved = YES;
            _touchPoint = [sender locationInView:_baseView];
            view.center = CGPointMake(_originPoint.x + _touchPoint.x - _startPoint.x,_originPoint.y + _touchPoint.y - _startPoint.y);
            
 //           RLMPoint *prePoint = self.rlmPoints.lastObject;
            if (_displayPoint) {
                
                [self.trackPoints addObject:[NSValue valueWithCGPoint:_touchPoint]];
                
                [self.rlmPoints addObject:[[RLMPoint alloc] initWithValue:@[@(_touchPoint.x), @(_touchPoint.y)]]];
                //NSLog(@"CGPointZero=%@",NSStringFromCGPoint(_touchPoint));
            }else{
                _shouldEnd = YES;
            }

            _lineView.isHavePath = YES;
//            if ([_rlmPoints count]>10) {
            if (_lineView.path) {
                CGPathRelease(_lineView.path);
            }
            
                _lineView.path = CGPathCreateMutable();
               // CGPathMoveToPoint(_lineView.path, NULL, [(RLMPoint *)_rlmPoints[[_rlmPoints count]  - 10] x], [(RLMPoint *)_rlmPoints[[_rlmPoints count]  - 10] y]);
                
                _index = 10;
                int addindex;
                if ((int)[_rlmPoints count] - 1 - _index > 0) {
                    addindex = (int)[_rlmPoints count] - 1 - _index;
                }else{
                    addindex = 0;
                }
            
                
                CGPathMoveToPoint(_lineView.path, NULL, [(RLMPoint *)_rlmPoints[addindex] x], [(RLMPoint *)_rlmPoints[addindex] y]);
                //int addindex = ([_rlmPoints count] - 1 - _index) > 0 ? ([_rlmPoints count] - 1 - _index):0;
                while (YES) {
//                    if (_index <= 0) {
//                        break;
//                    }
                    //CGFloat addindex = ([_rlmPoints count] - 1 - _index) > 0 ? ([_rlmPoints count] - 1 - _index):0;
//                    CGPathAddLineToPoint(_lineView.path, NULL, [(RLMPoint *)_rlmPoints[([_rlmPoints count] - 1 - _index) > 0 ? ([_rlmPoints count] - 1 - _index):0] x], [(RLMPoint *)_rlmPoints[([_rlmPoints count] - 1 - _index) > 0 ? ([_rlmPoints count] - 1 - _index):0] y]);
                    CGPathAddLineToPoint(_lineView.path, NULL, [(RLMPoint *)_rlmPoints[addindex] x], [(RLMPoint *)_rlmPoints[addindex] y]);
                    if ((RLMPoint *)_rlmPoints[addindex] == (RLMPoint *)_rlmPoints.lastObject) {
                        break;
                    }
                    addindex++;
                }

//            }else{
//                CGPathAddLineToPoint(_lineView.path, NULL, _touchPoint.x, _touchPoint.y);
//            }
               // CGPathAddLineToPoint(_lineView.path, NULL, _touchPoint.x, _touchPoint.y);
//            for ((RLMPoint*)point in _rlmPoints)
//            {
//                CGPathAddLineToPoint(_lineView.path, NULL, point.x, point.y);
//            }
            //[_lineView setWidth:(width++)];
            //            _lineView.lineWidth = width++;
            _DynamicWidth = _DynamicWidth + 0.1;
//            if (_DynamicWidth > 3) {
//                CGPathMoveToPoint(_lineView.path, NULL, _touchPoint.x,_touchPoint.y);
//            }
            //_lineView.lineWidth = 10;
            [_lineView setNeedsDisplay];
            //_lineView.path = CGPathCreateMutable();
            //[_lineView.path CGPathRelease];
            //[_lineView setNeedsDisplayInRect:CGRectMake((_touchPoint.x < prePoint.x)?_touchPoint.x:prePoint.x - 20, (_touchPoint.y < prePoint.y)?_touchPoint.y:prePoint.y - 20, fabs(_touchPoint.x - prePoint.x) + 40, fabs(_touchPoint.y - prePoint.y) + 40)];
            //====================画图动态区域调整
            if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:stateChangedAtPosition:)]) {
                [self.recognizeDelegate gestureRecognizer:self stateChangedAtPosition:_touchPoint];
            }
        }
        else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
        {//Failed、Cancelled区别？
            //debugLog(@"%@",_rlmPoints);
            //_lineView.isHavePath=nil;//---------------------------------------
            CGPathRelease(_lineView.path);
            [_myView removeAllLineView];
            _lineView.path = nil;
            _DynamicWidth = 1.0f;
            _touchPoint = [sender locationInView:_baseView];
            _lastPoint = [sender locationInView:_baseView];
            if (_isMoved) {
                
                
                if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:stateEndAtPosition:)]) {
                    [self.recognizeDelegate gestureRecognizer:self stateEndAtPosition:_lastPoint];
                }
                if (!_isSimpleGesture) {
                    RLMResults *gestures;
                    if (self.customGestureIds.count) {
                        NSMutableArray *intIds = [NSMutableArray array];
                        for (NSString *stringId in self.customGestureIds) {
                            [intIds addObject:@(stringId.intValue)];
                        }
                        gestures = [RLMGesture objectsWhere:@"objectId IN %@", intIds];
                    }
                    RLMArray *rlmArr = [[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
                    [rlmArr addObjects:self.rlmPoints];
                    [[TBGestureRecognizer shareGestureRecognizer] matchGestureFrom:rlmArr GesturesToMatch:gestures completion:^(NSString *matchResultId, RLMArray *resampledPoints) {
                        
                        if (matchResultId) {
                            debugLog(@"找到");
                            _needSimpleMatch = NO;
                            //[self.rlmPoints removeAllObjects];
                        } else {
                            _needSimpleMatch = YES;
                            debugLog(@"找不到");
                            //[self.rlmPoints removeAllObjects];
                        }
                        
                        if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:gestureType:gestureId:recognized:)]) {
                            [self.recognizeDelegate gestureRecognizer:self gestureType:TBGestureTypeCustom gestureId:[matchResultId intValue] recognized:(matchResultId != nil)];
                        }

                        
                    }];
                }
                
                if (_needSimpleMatch) {
                    _needSimpleMatch = YES;
                    //[self simpleEndLocationRecognizer];
                    [self simpleDirectionRecognizer];
                    if ([self confirmDirectionRecognizer:(RLMPoint *)_rlmPoints[(int)[_rlmPoints count]/2]] || [self simpleEndLocationRecognizer]) {
                        if ((_targetType & _direction) == _direction) {
                            //        [self.recognizeDelegate gestureRecognizer:self gestureType:(TBGestureType)_direction recognized:YES];
                            [self.recognizeDelegate gestureRecognizer:self gestureType:(TBGestureType)_direction  gestureId:(int)_direction  recognized:YES];
                            // _isSimpleGesture = YES;
                        }
                        else {
                            
                            if ((_targetType & TBGestureTypeCustom) != TBGestureTypeCustom) {
                                debugLog(@"内部失败");
                                if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:gestureType:recognized:)]) {
                                    [self.recognizeDelegate gestureRecognizer:self gestureType:0 recognized:NO];
                                }
                            }
                            
                            
                            // _isSimpleGesture = NO;
                        }
                    }
                    
                }
                
                if ([self.recognizeDelegate respondsToSelector:@selector(gestureRecognizer:trackGenerate:)]) {
                    [self.recognizeDelegate gestureRecognizer:self trackGenerate:_trackPoints];
                }
            }
        
            
            //===================================================单例释放问题
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
            
            
            if (self.action && self.target) {
                [self.target performSelector:self.action withObject:self afterDelay:0.0];
            }
    
            
        }
    }
    _shouldEnd = NO;
    
}

- (NSArray *)eventsForTypes:(TBGestureType)types {
    NSMutableArray *eventsArray = [NSMutableArray array];
    if (types & TBGestureTypeSimpleUP) {
        RLMResults *result = [RLMEvent objectsWhere:@"gestureId = %d", TBGestureTypeSimpleUP];
        if (result.count) {
            [eventsArray addObject:result[0]];
        }
    }
    if (types & TBGestureTypeSimpleDOWN) {
        RLMResults *result = [RLMEvent objectsWhere:@"gestureId = %d", TBGestureTypeSimpleDOWN];
        if (result.count) {
            [eventsArray addObject:result[0]];
        }
    }
    if (types & TBGestureTypeSimpleLEFT) {
        RLMResults *result = [RLMEvent objectsWhere:@"gestureId = %d", TBGestureTypeSimpleLEFT];
        if (result.count) {
            [eventsArray addObject:result[0]];
        }
    }
    if (types & TBGestureTypeSimpleRIGHT) {
        RLMResults *result = [RLMEvent objectsWhere:@"gestureId = %d", TBGestureTypeSimpleRIGHT];
        if (result.count) {
            [eventsArray addObject:result[0]];
        }
    }
    return [eventsArray copy];
}


- (BOOL)needShowTint {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger value = [def integerForKey:@"needShowTint"];
    if (value == 0) {
        return YES;
    }
    return NO;
}


@end
