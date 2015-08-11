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
#import "RLMGesture.h"
#import "MacroUtils.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [SharedDataManager createDatabase];

//    NSUInteger eventCount = [RLMEvent allObjects].count;
//    if (eventCount == 0) {
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
            NSArray *gestures = @[
                                  [[RLMGesture alloc] initWithValue:@[@(1), @"上", @(1)]],
                                  [[RLMGesture alloc] initWithValue:@[@(2), @"下", @(2)]],
                                  [[RLMGesture alloc] initWithValue:@[@(3), @"左", @(3)]],
                                  [[RLMGesture alloc] initWithValue:@[@(4), @"右", @(4)]],
                                  [[RLMGesture alloc] initWithValue:@[@(98), @"合", @(98)]],
                                  [[RLMGesture alloc] initWithValue:@[@(99), @"张", @(99)]],
                                  ];
//            [realm addObjects:gestures];
//            [realm addObjects:events];
//            debugLog(@"导入新版事件");
//            RLMGesture *gesture = [[RLMGesture alloc] initWithType:2];
//            RLMGesture *gesture = [[RLMGesture alloc] init];
//            gesture.objectId = 1;
//            gesture.name = @"123";
            [realm addObjects:gestures];
            [realm addObjects:events];
            
        }];
//    }

//    if ([RLMGesture allObjects].count <= eventCount) {
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm transactionWithBlock:^{
//
//            debugLog(@"导入自带事件成功");
//        }];
//    }
    
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
