//
//  TBEvent.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBGesture.h"

@class TBGesture;

typedef NS_OPTIONS(NSUInteger, TBEventType) {
    TBEventTypeCollect = 1 << 0,
    TBEventTypeShare = 1 << 1,
};


@interface TBEvent : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL canEditGesture;


- (instancetype)initWithEventType:(TBEventType)eventType;

- (void)addToView:(UIView *)view completion:(void (^)(NSError *error))completion;

- (void)removeEvent:(TBEvent *)event completion:(void (^)(NSError *error))completion;;
- (void)removeEventWithId:(NSString *)eventId completion:(void (^)(NSError *error))completion;;

+ (NSArray *)allEvents;

- (NSArray *)triggeredGestures;
- (NSArray *)canSelectedGestures;

- (void)addToTableView:(UITableView *)tableView completion:(void (^)(NSError *error))completion;
- (void)addToTableView:(UITableView *)tableView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion;


- (void)addToCollectionView:(UICollectionView *)collectionView completion:(void (^)(NSError *error))completion;
- (void)addToCollectionView:(UICollectionView *)collectionView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion;

@end
