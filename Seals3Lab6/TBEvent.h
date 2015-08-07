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

@interface TBEvent : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL canEditGesture;

- (void)addToView:(UIView *)view completion:(void (^)(NSError *error))completion;

- (void)removeEvent:(TBEvent *)event completion:(void (^)(NSError *error))completion;;
- (void)removeEventWithId:(NSString *)eventId completion:(void (^)(NSError *error))completion;;

+ (NSArray *)allEvents;
- (NSArray *)triggeredGestures;
- (NSArray *)canSelectedGestures;

- (void)addToCollectionView:(UICollectionView *)collectionView completion:(void (^)(NSError *error))completion;
- (void)addToCollectionView:(UICollectionView *)collectionView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion;

@end
