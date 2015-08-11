
//
//  UIPinchGestureRecognizer+UIPinchCustomGestureRecognizer.h
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBGesture.h"
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



@end
