//
//  FYTestView.h
//  TouchTracker
//
//  Created by feiyangzhang on 15/8/7.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBGestureDrawDelegate <NSObject>

- (void)gestureDidDrawAtPosition:(NSArray *)trackPoints;

@end

@interface TBCreateGesture : UIView

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGMutablePathRef path;
@property (assign, nonatomic) BOOL isHavePath;

@property (nonatomic, strong) UIImage *capture;

@property (nonatomic, weak) id<TBGestureDrawDelegate> delegate;

- (UIImage *)clipImageOn:(CGRect)frame;

@end
