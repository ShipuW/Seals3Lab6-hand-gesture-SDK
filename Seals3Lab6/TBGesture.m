//
//  TBGesture.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBGesture.h"
#import "TBEvent.h"
#import "UIGestureRecognizer+UICustomGestureRecognizer.h"
#import "MacroUtils.h"
#import "TBHookOperation.h"

@interface TBGesture () <TBCustomGestureRecognizerDelegate>

@property(nonatomic, strong) UITableView *tableView;

@end


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
//    self.gestureRecognizer = [[UICustomGestureRecognizer alloc] initWithTarget:self action:@selector(xxx:)];
    self.gestureRecognizer = [[UICustomGestureRecognizer alloc] init];
    self.gestureRecognizer.recognizeDelegate = self;
    self.gestureRecognizer.target = self.gestureRecognizer;
    self.gestureRecognizer.action = @selector(buttonLongPressed:);
    [view addGestureRecognizer:self.gestureRecognizer];
}

- (void)xxx:(id)sender {
    
}


//- (void)addToTableView:(UITableView *)tableView completion:(void (^)(NSError *))completion {
//    [self addToTableView:tableView forKeyPath:@"" completion:completion];
//}
//
//- (void)addToTableView:(UITableView *)tableView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *))completion {
//
//}
//
//- (void)addToCollectionView:(UICollectionView *)collectionView completion:(void (^)(NSError *))completion {
//    [self addToCollectionView:collectionView forKeyPath:@"" completion:completion];
//}
//
//- (void)addToCollectionView:(UICollectionView *)collectionView forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *))completion {
//
//}

- (void)addToCollectionView:(UICollectionView *)collectionView dataSource:(id)dataSource completion:(void (^)(NSError *error))completion {

}

- (void)addToTableView:(UITableView *)tableView dataSource:(id)dataSource completion:(void (^)(NSError *error))completion {

    [self addToTableView:tableView dataSource:dataSource forKeyPath:@"" completion:completion];
}

- (void)addToTableView:(UITableView *)tableView dataSource:(id)dataSource forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion {
    
    self.tableView = tableView;
    [TBHookOperation hookDataSource:dataSource withTableView:tableView withGesture:self forKeyPath:keyPath];
    
//    completion;
}

- (void)addToCollectionView:(UICollectionView *)collectionView dataSource:(id)dataSource forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion {

}

#pragma mark - Recognizer Delegate

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateBeginAtPosition:(CGPoint)position {
//    debugMethod();
    
    NSLog(@"[self.tableView indexPathForCell:customGestureRecognizer.view]=%@",[self.tableView indexPathForCell:(UITableViewCell *)customGestureRecognizer.view]);
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateChangedAtPosition:(CGPoint)position {
    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateEndAtPosition:(CGPoint)position {
    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer recognized:(BOOL)succeed {
    debugMethod();
}

@end
