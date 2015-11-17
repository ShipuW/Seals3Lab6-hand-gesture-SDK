//
//  MyView.h
//  LongPressDrag
//
//  Created by 王士/Users/wangshipu/Desktop/LongPressDrag/LongPressDrag/AppDelegate.h溥 on 15/8/5.
//  Copyright (c) 2015年 王士溥. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineView;

@interface MyView : UIView

//@property (assign, nonatomic) CGFloat lineWidth;
//@property (strong, nonatomic) UIColor *lineColor;
//@property (assign, nonatomic) CGMutablePathRef path;
//@property (strong, nonatomic) NSMutableArray *pathArray;
//@property (assign, nonatomic) BOOL isHavePath;
//@property (strong, nonatomic) LineView *lineView;
@property (strong, nonatomic) NSMutableArray *lineViews;
@property (nonatomic) NSUInteger emptyView;
+ (instancetype)sharedView;
- (void)updateWithFrame:(CGRect)frame tint:(NSArray*)array baseViewFrame:(CGRect)baseViewFrame emptySideLength:(CGFloat)emptySideLength;
- (LineView*) addLineViewWithFrame:(CGRect)baseViewFrame;
- (void) removeAllLineView;


@end

