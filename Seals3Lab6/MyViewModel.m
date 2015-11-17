//
//  MyViewModel.m
//  LongPressDrag
//
//  Created by 王士/Users/wangshipu/Desktop/LongPressDrag/LongPressDrag/AppDelegate.h溥 on 15/8/5.
//  Copyright (c) 2015年 王士溥. All rights reserved.
//

#import "MyViewModel.h"

@implementation MyViewModel

+ (id)viewModelWithColor:(UIColor *)color Path:(UIBezierPath *)path Width:(CGFloat)width
{
    MyViewModel *myViewModel = [[MyViewModel alloc] init];
   
    myViewModel.color = color;
    myViewModel.path = path;
    myViewModel.width = width;
    
    return myViewModel;
}
@end

