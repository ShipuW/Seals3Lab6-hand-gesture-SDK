//
//  FYTestView.h
//  TouchTracker
//
//  Created by feiyangzhang on 15/8/7.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBCreateGesture : UIView

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGMutablePathRef path;
@property (assign, nonatomic) BOOL isHavePath;

@end
