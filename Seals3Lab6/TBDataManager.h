//
// Created by Veight Zhou on 8/9/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBGesture;
@class TBGEvent;

#define SharedDataManager [TBDataManager sharedManager]

@interface TBDataManager : NSObject

+ (instancetype)sharedManager;

- (void)loadAllEventsFromDatabase:(void (^)(NSArray *results, NSError *error))completion;

- (void)loadAllGesturesFromDatabase:(void (^)(NSArray *, NSError *))completion;

- (void)deleteGesture:(TBGesture *)gesture completion:(void (^)(NSError *error))completion;

- (void)loadLocalGestureTemplets:(void (^)(NSArray *results, NSError *error))completion;

- (void)createDatabase;

- (void)addCustomGesture:(TBGesture *)gesture completion:(void (^)(TBGesture *gesture, NSError *error))completion;

- (void)mapEvent:(TBGEvent *)event withGesture:(TBGesture *)gesture completion:(void (^)(NSError *error))completion;

- (void)deleteGestureWithEvent:(TBGEvent *)event completion:(void (^)(NSError *))completion;

- (void)fetchGestureWithEvent:(TBGEvent *)event completion:(void (^)(TBGesture *gesture))completion;

@end