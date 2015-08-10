//
//  TBGesture.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TBEvent;
@class TBGesture;

typedef NS_ENUM(NSInteger , TBGestureType) {
    TBGestureTypeSystem = 0,
    TBGestureTypeCustom = 100,
};


@protocol TBGestureDelegate

@optional
- (void)tableView:(UITableView *)tableView gesture:(TBGesture *)gesture forEvent:(TBEvent *)event atIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView gesture:(TBGesture *)gesture forEvent:(TBEvent *)event atIndexPath:(NSIndexPath *)indexPath;

@end

@interface TBGesture : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) TBGestureType type;

@property (nonatomic, weak) id<TBGestureDelegate> delegate;

// 存储自带的手势
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
// 存储定长的源于 CGPoint 的 NSValue 数组
@property (nonatomic, strong) NSArray *path;
@property (nonatomic, strong) NSArray *rawPath;


- (void)addToView:(UIView *)view completion:(void (^)(NSError *error))completion;

+ (instancetype)gestureForEvent:(TBEvent *)event;
+ (instancetype)gestureForEventId:(NSString *)eventId;
//+ (NSArray *)gesturesForEvent:(TBEvent *)event;
//+ (NSArray *)gesturesForEventId:(NSString *)eventId;
- (void)addToTableView:(UITableView *)tableView completion:(void (^)(NSError *error))completion;
- (void)addToTableView:(UITableView *)tableView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion;


- (void)addToCollectionView:(UICollectionView *)collectionView completion:(void (^)(NSError *error))completion;
- (void)addToCollectionView:(UICollectionView *)collectionView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion;


@end
