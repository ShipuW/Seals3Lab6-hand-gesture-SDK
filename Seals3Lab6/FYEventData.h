//
//  FYData.h
//  TBCreateGusture
//
//  Created by feiyangzhang on 15/8/8.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TBGEvent;
@interface FYEventData : NSObject

@property(nonatomic,strong) TBGEvent *event;

@property(nonatomic,copy) NSString* icon;
/**
 *  判断是否是自定义手势，改变加载路径
 */
@property(nonatomic,assign) BOOL isCustom;

@end
