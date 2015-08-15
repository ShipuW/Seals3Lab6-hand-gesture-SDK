//
//  LineView.h
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/14.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LineView : UIView

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (assign, nonatomic) BOOL isHavePath;


@end
