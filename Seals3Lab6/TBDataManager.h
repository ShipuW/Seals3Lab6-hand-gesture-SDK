//
// Created by Veight Zhou on 8/9/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SharedDataManager [TBDataManager sharedManager]


@interface TBDataManager : NSObject

+ (instancetype)sharedManager;

- (void)loadLocalGestureTemplets:(void (^)(NSArray *results, NSError *error))completion;
- (void)createDatabase;
@end