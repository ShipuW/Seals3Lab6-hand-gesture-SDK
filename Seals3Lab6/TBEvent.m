//
//  TBEvent.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBEvent.h"
#import "TBGesture.h"

@implementation TBEvent

#pragma mark - Basic Methods

+ (NSArray *)allEvents {
    TBEvent *evt1 = [self fake_collect];
    TBEvent *evt2 = [self fake_share];
    return @[evt1, evt2];
}

- (NSArray *)triggeredGestures {
    TBGesture *gesture1 = [[TBGesture alloc] init];
    gesture1.objectId = @"1";
    gesture1.name = @"手势1";
    gesture1.type = TBGestureTypeSystem;
//    TBGesture *gesture2 = [[TBGesture alloc] init];
//    gesture2.objectId = @"2";
//    gesture2.name = @"手势2";
//    gesture2.type = TBGestureTypeCustom;
    return @[gesture1];
}

- (NSArray *)canSelectedGestures {
    TBGesture *gesture1 = [[TBGesture alloc] init];
    gesture1.objectId = @"1";
    gesture1.name = @"手势1";
    gesture1.type = TBGestureTypeSystem;
    TBGesture *gesture2 = [[TBGesture alloc] init];
    gesture2.objectId = @"2";
    gesture2.name = @"手势2";
    gesture2.type = TBGestureTypeCustom;
    return @[gesture1, gesture2];
}


+ (instancetype)fake_collect {
    TBEvent *event = [[TBEvent alloc] init];
    event.objectId = @"1";
    event.name = @"收藏";
    return event;
}

+ (instancetype)fake_share {
    TBEvent *event = [[TBEvent alloc] init];
    event.objectId = @"2";
    event.name = @"分享";
    return event;
}

@end
