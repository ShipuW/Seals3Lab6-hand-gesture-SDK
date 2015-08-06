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
    TBGestureTypeCustom = 1,
};


@protocol TBGestureDelegate


- (void)tableView:(UITableView *)tableView gesture:(TBGesture *)gesture forEvent:(TBEvent *)event atIndexPath:(NSIndexPath *)indexPath;
- (void)collectionView:(UICollectionView *)collectionView gesture:(TBGesture *)gesture forEvent:(TBEvent *)event atIndexPath:(NSIndexPath *)indexPath;

@end

@interface TBGesture : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) TBGestureType type;

// 存储自带的手势
@property (nonatomic, strong) UIGestureRecognizer *gestureRecognizer;
// 存储定长的源于 CGPoint 的 NSValue 数组
@property (nonatomic, strong) NSArray *path;

- (NSArray *)gesturesForEvent:(TBEvent *)event;

- (NSArray *)gesturesForEventId:(NSString *)eventId;



@end
