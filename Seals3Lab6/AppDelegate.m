//
//  AppDelegate.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "AppDelegate.h"
#import "TBDataManager.h"
#import "RLMTestObject.h"
#import "RLMEvent.h"
#import "Point.h"
#import "RLMGesture.h"
#import "MacroUtils.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [SharedDataManager createDatabase];

    NSUInteger eventCount = [RLMEvent allObjects].count;
    if (eventCount == 0) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            NSArray *events = @[
                                [[RLMEvent alloc] initWithName:@"收藏"],
                                [[RLMEvent alloc] initWithName:@"分享"],
                                [[RLMEvent alloc] initWithName:@"事件0"],
                                [[RLMEvent alloc] initWithName:@"事件1"],
                                [[RLMEvent alloc] initWithName:@"事件2"],
                                [[RLMEvent alloc] initWithName:@"事件3"],
                                [[RLMEvent alloc] initWithName:@"事件4"],
                                [[RLMEvent alloc] initWithName:@"事件5"],
                                [[RLMEvent alloc] initWithName:@"事件6"],
                                ];
//            RLMPoint *point = [[RLMPoint alloc] init];
//            point.x = 0;
//            point.y = 0;

            RLMGesture *g0 = [[RLMGesture alloc] initWithValue:@[@(1 << 0), @"上", @(1 << 0), @[], @[] ]];
//            g0.path = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
//            [g0.path addObject:point];
//            g0.rawPath = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
//            [g0.rawPath addObject:point];

            RLMGesture *g1 = [[RLMGesture alloc] initWithValue:@[@(1 << 1), @"下", @(1 << 1), @[], @[]]];
//            g1.path = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g1.path addObject:point];
//            g1.rawPath = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g1.rawPath addObject:point];
//
            RLMGesture *g2 = [[RLMGesture alloc] initWithValue:@[@(1 << 2), @"左", @(1 << 2), @[], @[]]];
//            g2.path = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g2.path addObject:point];
//            g2.rawPath = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g2.rawPath addObject:point];
//
            RLMGesture *g3 = [[RLMGesture alloc] initWithValue:@[@(1 << 3), @"右", @(1 << 3), @[], @[]]];
//            g3.path = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g3.path addObject:point];
//            g3.rawPath = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g3.rawPath addObject:point];
//
            RLMGesture *g4 = [[RLMGesture alloc] initWithValue:@[@(1 << 4), @"合", @(1 << 4), @[], @[]]];
//            g4.path = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g4.path addObject:point];
//            g4.rawPath = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g4.rawPath addObject:point];
//
            RLMGesture *g5 = [[RLMGesture alloc] initWithValue:@[@(1 << 5), @"张", @(1 << 5), @[], @[]]];
//            g5.path = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g5.path addObject:point];
//            g5.rawPath = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMGesture"];
//            [g5.rawPath addObject:point];

            
            NSArray *gestures = @[
//                                  [[RLMGesture alloc] initWithValue:@[@(1 << 0), @"上", @(1 << 0)]],
//                                  [[RLMGesture alloc] initWithValue:@[@(1 << 1), @"下", @(1 << 1)]],
//                                  [[RLMGesture alloc] initWithValue:@[@(1 << 2), @"左", @(1 << 2)]],
//                                  [[RLMGesture alloc] initWithValue:@[@(1 << 3), @"右", @(1 << 3)]],
//                                  [[RLMGesture alloc] initWithValue:@[@(1 << 4), @"合", @(1 << 4)]],
//                                  [[RLMGesture alloc] initWithValue:@[@(1 << 5), @"张", @(1 << 5)]],
                    g0,
                    g1,
                    g2,
                    g3,
                    g4,
                    g5
                                  ];

            [realm addObjects:gestures];
            [realm addObjects:events];
            
        }];
    }

//    if ([RLMGesture allObjects].count <= eventCount) {
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm transactionWithBlock:^{
//
//            debugLog(@"导入自带事件成功");
//        }];
//    }
//    double start=[[NSDate date] timeIntervalSince1970];
//    NSLog(@"start=%lf",start);
//    [RLMPoint allObjects];
//    
//    double end=[[NSDate date] timeIntervalSince1970];
//    NSLog(@"end=%lf   end-start=%lf",end,end-start);
//    
//    [RLMGesture allObjects];
//    
//    double end2=[[NSDate date] timeIntervalSince1970];
//    NSLog(@"end2=%lf   end2-start=%lf end2-end=%lf",end2,end2-start,end2-end);
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
