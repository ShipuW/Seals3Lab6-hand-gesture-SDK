//
// Created by Veight Zhou on 8/5/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TBEventDisplayModel : NSObject

@property (nonatomic, strong) NSString *eventName;
@property (nonatomic, strong) NSString *gestureName;

@property (nonatomic, strong) NSString *eventId;
@property (nonatomic, strong) NSString *gestureId;

+ (NSArray *)modelsForEvents:(NSArray *)events;
+ (NSArray *)modelsForEventIds:(NSArray *)eventIds;
+ (NSArray *)modelsForAllEvents;

@end