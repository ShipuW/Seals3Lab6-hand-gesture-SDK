//
//  FYTestView.h
//  TouchTracker
//
//  Created by feiyangzhang on 15/8/7.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FYEventData;

@protocol FYCreateGestureDelegate<NSObject>

@optional
-(void)createGestureDidFinishedDrawPath;
@end

@interface FYCreateGesture : UIView

//设置代理，通知已经完成绘图
@property(nonatomic,weak) id<FYCreateGestureDelegate> delegate;

@property(nonatomic,strong)FYEventData* eventData;

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGMutablePathRef path;
@property (assign, nonatomic) BOOL isHavePath;

@end
