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
#import "UICustomPinchGestureRecognizer.h"
#import "MacroUtils.h"
#import "TBHookOperation.h"
#import "RLMGesture.h"
#import "RLMEvent.h"

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
    return [[self alloc] initForEventId:eventId];
}

- (instancetype)initForEventId:(NSString *)eventId {
    self = [super init];
    RLMEvent *event = [RLMEvent objectForPrimaryKey:@([eventId intValue])];
    self.type = event.gestureId;
    self.name = event.name;
    self.objectId = [@(event.objectId) stringValue];
    return self;
}

- (void)addToView:(UIView *)view completion:(void (^)(NSError *))completion {
//    self.gestureRecognizer = [[UICustomGestureRecognizer alloc] initWithTarget:self action:@selector(xxx:)];
//    self.gestureRecognizer = [[UICustomGestureRecognizer alloc] init];
//    self.gestureRecognizer.recognizeDelegate = self;
//    self.gestureRecognizer.target = self.gestureRecognizer;
//    self.gestureRecognizer.action = @selector(buttonLongPressed:);
//self.gestureRecognizer = [[UICustomGestureRecognizer alloc] initWithTarget:self action:@selector(xxx:)];
    
  
    if (!view) {
        return;
    }
//    NSArray *gesturesArray = [view gestureRecognizers];
//    if (gesturesArray.count) {
//        for (UIGestureRecognizer *gr in gesturesArray) {
//            if ([gr isKindOfClass:[UICustomGestureRecognizer class]]) {
//                UICustomGestureRecognizer *cgr = (UICustomGestureRecognizer *)gr;
//                TBGesture *gesture = (TBGesture *)cgr.recognizeDelegate;
//                if ([gesture.objectId isEqualToString:self.objectId]) {
//                    debugLog(@"该视图已经添加过这个手势");
//                    !completion ?: completion(nil);
//                    return;
//                }
//            }
//        }
//    }
    
        if (self.type == TBGestureTypeSimplePinchOUT || self.type == TBGestureTypeSimplePinchIN) { //pinchGesture
            
            self.pinchRecognizer = [[UICustomPinchGestureRecognizer alloc] initWithTarget:self action:nil type:self.type];
            //self.pinchRecognizer.tbGesture = self;
            self.gestureRecognizer.recognizeDelegate = self;
            [view addGestureRecognizer:self.pinchRecognizer];
        }else{
            
            self.gestureRecognizer = [[UICustomGestureRecognizer alloc] initWithTarget:self action:nil type:self.type];
            self.gestureRecognizer.recognizeDelegate = self;
            [view addGestureRecognizer:self.gestureRecognizer];
        }
    

    !completion ?: completion(nil);
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
    !completion ?: completion(nil);
}

- (void)addToCollectionView:(UICollectionView *)collectionView dataSource:(id)dataSource forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion {

}

#pragma mark - Recognizer Delegate

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateBeginAtPosition:(CGPoint)position {
//    debugMethod();
    
    NSLog(@"[self.tableView indexPathForCell:customGestureRecognizer.view]=%@",[self.tableView indexPathForCell:(UITableViewCell *)customGestureRecognizer.view]);
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateChangedAtPosition:(CGPoint)position {
//    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateEndAtPosition:(CGPoint)position {
//    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer trackGenerate:(NSArray*)trackPoints {
//    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer recognized:(BOOL)succeed {
    if (succeed) {
        NSLog(@"配对成功");
        if ([self.delegate respondsToSelector:@selector(recogizedEvent:)]) {
            [self.delegate recogizedEvent:self];
        }
    }else{
        NSLog(@"配对失败");
    }
    debugMethod();
}

@end
