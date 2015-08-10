//
//  FYData.h
//  TBCreateGusture
//
//  Created by feiyangzhang on 15/8/8.
//  Copyright (c) 2015年 feiyangzhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBEvent.h"

@interface FYEventData : TBEvent

@property(nonatomic,strong) TBEvent* event;

@property(nonatomic,copy) NSString* icon;

@end
