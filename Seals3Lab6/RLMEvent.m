//
//  RLMEvent.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/11/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "RLMEvent.h"
#import "RLMGesture.h"

static NSInteger cid = 1;

@implementation RLMEvent

// Specify default values for properties

//+ (NSDictionary *)defaultPropertyValues
//{
//    return @{@"gesture": gesture};
//}

// Specify properties to ignore (Realm won't persist these)

//+ (NSArray *)ignoredProperties
//{
//    return @[];
//}

+ (nullable NSString *)primaryKey {
    return @"objectId";
}

//+ (instancetype)eventForName:(NSString *)name {
//    RLMEvent *event = [[RLMEvent alloc] init];
//    event.gesture = [[RLMGesture alloc] init];
//    
//}

- (instancetype)initWithName:(NSString *)name {
    RLMEvent *event = [[RLMEvent alloc] init];
    event.objectId = cid++;
    event.gesture = [[RLMGesture alloc] init];
//    event.gesture.objectId = 0;
    event.gesture.name = @"";
//    event.gesture.type = 0;
    event.name = name;
    
    return event;
}

- (NSInteger)randomId {
    double ts = [[NSDate date] timeIntervalSince1970];
    ts = fmod(ts, @(1000000).doubleValue);
    ts = ts * 1000;
    NSInteger objectId = @(ts).integerValue;
    return objectId;
}

@end
