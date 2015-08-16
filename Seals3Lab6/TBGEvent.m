//
//  TBGEvent.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBGEvent.h"
#import "TBGesture.h"
#import "FMDB.h"
#import "TBDataManager.h"
#import "RLMEvent.h"

static NSString *const kEventDatabasePath = @"/tmp/tbg.db";

@interface TBGEvent ()

@property (nonatomic, strong) FMDatabase *eventDatabase;
@property (nonatomic, copy, readonly) NSString *dbPath;


@end

@implementation TBGEvent

#pragma mark - Basic Methods

- (void)addToView:(UIView *)view completion:(void (^)(NSError *error))completion {
//    NSArray *gestures = [TBGesture gesturesForEvent:self];

}

- (void)removeEvent:(TBGEvent *)event completion:(void (^)(NSError *error))completion {

}

- (void)removeEventWithId:(NSString *)eventId completion:(void (^)(NSError *error))completion {

}

- (instancetype)initWithEventType:(TBEventType)eventType {
    self = [super init];
    if (self) {
        RLMEvent *event = [RLMEvent objectForPrimaryKey:@(eventType)];
        self.name = event.name;
        self.objectId = [@(event.objectId) stringValue];

//        switch (eventType) {
//            case TBEventTypeCollect: {
//                
//                break;
//            }
//            case TBEventTypeShare: {
////                <#statement#>
//                break;
//            }
//            default: {
//                break;
//            }
//        }
    }
    return self;
}

+ (NSArray *)allEvents {
//    [SharedDataManager loadAllEventsFromDatabase:^(NSArray *results, NSError *error) {
//        
//    }];
    
    TBGEvent *evt1 = [self fake_collect];
    TBGEvent *evt2 = [self fake_share];
    return @[evt1, evt2];
//    return nil;
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

- (void)addToTableView:(UITableView *)tableView completion:(void (^)(NSError *error))completion {

}

- (void)addToTableView:(UITableView *)tableView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion {

}


- (void)addToCollectionView:(UICollectionView *)collectionView completion:(void (^)(NSError *error))completion {

}

- (void)addToCollectionView:(UICollectionView *)collectionView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion {

}


+ (instancetype)fake_collect {
    TBGEvent *event = [[TBGEvent alloc] init];
    event.objectId = @"1";
    event.name = @"收藏";
    return event;
}

+ (instancetype)fake_share {
    TBGEvent *event = [[TBGEvent alloc] init];
    event.objectId = @"2";
    event.name = @"分享";
    return event;
}


//#pragma mark - 本地存储
//
//- (NSString *)dbPath {
//    NSString * doc = PATH_OF_DOCUMENT;
//    NSString * path = [doc stringByAppendingPathComponent:@"user.sqlite"];
//    self.dbPath = path;
//    return _dbPath;
//}
//
//
//- (FMDatabase *)eventDatabase {
//    if (!_eventDatabase) {
//        _eventDatabase = [FMDatabase databaseWithPath:kEventDatabasePath];
//    }
//    return _eventDatabase;
//}



@end
