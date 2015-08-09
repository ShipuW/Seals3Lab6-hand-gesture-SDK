//
// Created by Veight Zhou on 8/9/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBGesture;

#define SharedDataManager [TBDataManager sharedManager]


@interface TBDataManager : NSObject

+ (instancetype)sharedManager;

- (void)loadLocalGestureTemplets:(void (^)(NSArray *results, NSError *error))completion;
- (void)createDatabase;

- (void)addCustomGesture:(TBGesture *)gesture completion:(void (^)(NSError *error))completion;

@end