
//
//  UIPinchGestureRecognizer+UIPinchCustomGestureRecognizer.h
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBGesture.h"

@protocol TBCustomPinchGestureRecognizerDelegate <NSObject>


- (void)gestureRecognizer:(UICustomPinchGestureRecognizer *)customPinchGestureRecognizer gestureType:(TBGestureType)type recognized:(BOOL)succeed;
- (void)gestureRecognizer:(UICustomPinchGestureRecognizer *)customPinchGestureRecognizer gestureType:(TBGestureType)type gestureId:(int)gestureId recognized:(BOOL)succeed;

@end

@interface UICustomPinchGestureRecognizer:UIPinchGestureRecognizer
{
    @package
    CGFloat             _lastScale;
    CGFloat             _tureScale;
    BOOL                _isMatch;
    TBGestureType       _targetType;
}


//@property (nonatomic, weak) TBGesture *tbGesture;

- (instancetype)initWithTarget:(id)target action:(SEL)action type:(TBGestureType)type;
- (void)pinchAction:(UILongPressGestureRecognizer *)sender;


@property (nonatomic) id<TBCustomPinchGestureRecognizerDelegate> recognizePinchDelegate;


@end
