//
//  TBGesture.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBGesture.h"
#import "TBEvent.h"

@implementation TBGesture

- (NSArray *)gesturesForEvent:(TBEvent *)event {
    return [self gesturesForEventId:event.objectId];
}

- (NSArray *)gesturesForEventId:(NSString *)eventId {
    if (!eventId) {
        return nil;
    }

    UIGestureRecognizer *gr = [[UIGestureRecognizer alloc] init];
//    [gr addTarget:<#(id)target#> action:<#(SEL)action#>];
    return @[gr];
}


+ (instancetype)gestureForEvent:(TBEvent *)event {
    return [self gestureForEventId:event.objectId];
}

+ (instancetype)gestureForEventId:(NSString *)eventId {
    TBGesture *gesture = [[TBGesture alloc] init];
    return gesture;
}

- (void)addToView:(UIView *)view completion:(void (^)(NSError *))completion {
    self.gestureRecognizer = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(xxx:)];
    [view addGestureRecognizer:self.gestureRecognizer];
}

- (void)xxx:(id)sender {
    
}


- (void)addToTableView:(UITableView *)tableView completion:(void (^)(NSError *))completion {
    [self addToTableView:tableView forKeyPath:@"" completion:completion];
}

- (void)addToTableView:(UITableView *)tableView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *))completion {
    
}

- (void)addToCollectionView:(UICollectionView *)collectionView completion:(void (^)(NSError *))completion {
    [self addToCollectionView:collectionView forKeyPath:@"" completion:completion];
}

- (void)addToCollectionView:(UICollectionView *)collectionView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *))completion {
    
}

@end
