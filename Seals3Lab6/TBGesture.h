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
@class UICustomGestureRecognizer;
@class UICustomPinchGestureRecognizer;

typedef NS_ENUM(NSInteger , TBGestureType) {
    TBGestureTypeSystem         = 0,
    TBGestureTypeSimpleUP       = 1,
    TBGestureTypeSimpleDOWN     = 1 << 2,
    TBGestureTypeSimpleLEFT     = 1 << 3,
    TBGestureTypeSimpleRIGHT    = 1 << 4,
    TBGestureTypeSimplePinchIN  = 1 << 5,
    TBGestureTypeSimplePinchOUT = 1 << 6,
    TBGestureTypeCustom         = 1 << 20,
};


@protocol TBGestureDelegate <NSObject>

// 测试打通
- (void)recogizedEvent:(TBEvent *)event;

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
@property (nonatomic, strong) UICustomGestureRecognizer *gestureRecognizer;
@property (nonatomic, strong) UICustomPinchGestureRecognizer *pinchRecognizer;

// 存储定长的源于 CGPoint 的 NSValue 数组
@property (nonatomic, strong) NSArray *path;
@property (nonatomic, strong) NSArray *rawPath;


- (void)addToView:(UIView *)view completion:(void (^)(NSError *error))completion;

+ (instancetype)gestureForEvent:(TBEvent *)event;
+ (instancetype)gestureForEventId:(NSString *)eventId;
//+ (NSArray *)gesturesForEvent:(TBEvent *)event;
//+ (NSArray *)gesturesForEventId:(NSString *)eventId;
- (void)addToTableView:(UITableView *)tableView dataSource:(id)dataSource completion:(void (^)(NSError *error))completion;
- (void)addToTableView:(UITableView *)tableView dataSource:(id)dataSource forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion;


- (void)addToCollectionView:(UICollectionView *)collectionView dataSource:(id)dataSource completion:(void (^)(NSError *error))completion;
- (void)addToCollectionView:(UICollectionView *)collectionView dataSource:(id)dataSource forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion;


@end
