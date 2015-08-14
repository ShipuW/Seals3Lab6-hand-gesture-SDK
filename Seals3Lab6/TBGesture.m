//
//  TBGesture.m
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Realm/Realm.h>
#import "TBGesture.h"
#import "TBEvent.h"
#import "UIGestureRecognizer+UICustomGestureRecognizer.h"
#import "UICustomPinchGestureRecognizer.h"
#import "MacroUtils.h"
#import "TBHookOperation.h"
#import "RLMGesture.h"
#import "RLMEvent.h"

@interface TBGesture () <TBCustomGestureRecognizerDelegate, TBCustomPinchGestureRecognizerDelegate>

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

    
    
    if ((self.type & TBGestureTypeSimplePinchOUT) == TBGestureTypeSimplePinchOUT || (self.type & TBGestureTypeSimplePinchIN) == TBGestureTypeSimplePinchIN) { //pinchGesture，传入双指手势
        
        self.pinchRecognizer = [[UICustomPinchGestureRecognizer alloc] initWithTarget:self action:nil type:self.type];
        //self.pinchRecognizer.tbGesture = self;
        //            self.gestureRecognizer.recognizePinch/Delegate = self;
        self.pinchRecognizer.recognizePinchDelegate = self;
        [view addGestureRecognizer:self.pinchRecognizer];
    }
    
    if ((self.type & 0xf) > 0 || (self.type & TBGestureTypeCustom) == TBGestureTypeCustom) {//传入长按手势
        
        self.gestureRecognizer = [[UICustomGestureRecognizer alloc] initWithTarget:self action:nil type:self.type];
        self.gestureRecognizer.customGestureIds = [self.customGestureIds copy];
        self.gestureRecognizer.recognizeDelegate = self;
        [view addGestureRecognizer:self.gestureRecognizer];
    }





    !completion ?: completion(nil);
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

//- (instancetype)initWithEventsType:(TBEventType)types {
//    self = [super init];
//    if (self) {
//
//    }
//    return nil;
//}

- (instancetype)initWithEventNames:(NSArray *)eventNames {
    self = [super init];
    if (self) {
        RLMResults *results = [RLMEvent objectsWhere:@"name IN %@", eventNames];
        NSInteger types = 0;
        if (results.count) {
            for (RLMEvent *event in results) {
                RLMGesture *gesture = [RLMGesture objectForPrimaryKey:@(event.gestureId)];
                types |= gesture.type;
                if (gesture.type == TBGestureTypeCustom) {
                    if (!_customGestureIds) {
                        _customGestureIds = [NSMutableArray array];
                    }
                    [_customGestureIds addObject:@(event.gestureId).stringValue];
                }
            }
        }
        self.type = (TBGestureType)types;
    }
    return self;
}

- (void)addToTableView:(UITableView *)tableView dataSource:(id)dataSource completion:(void (^)(NSError *error))completion {

    [self addToTableView:tableView dataSource:dataSource forKeyPath:@"" completion:completion];
}

- (void)addToTableView:(UITableView *)tableView dataSource:(id)dataSource forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion {

//    self.tableView = tableView;
//    [TBHookOperation hookDataSource:dataSource withTableView:tableView withGesture:self forKeyPath:keyPath];
//    !completion ?: completion(nil);
}

- (void)addToCollectionView:(UICollectionView *)collectionView dataSource:(id)dataSource forKeyPath:(NSString *)keyPath completion:(void (^)(NSError *error))completion {

}

#pragma mark - Recognizer Delegate

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateBeginAtPosition:(CGPoint)position {
//    debugMethod();

//    self.indexpath = [self.tableView indexPathForCell:(UITableViewCell *)customGestureRecognizer.view];
//    NSLog(@"self.tableView indexPathForCell:customGestureRecognizer.view]=%@",[self.tableView indexPathForCell:(UITableViewCell *)customGestureRecognizer.view]);
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateChangedAtPosition:(CGPoint)position {
//    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateEndAtPosition:(CGPoint)position {
    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer trackGenerate:(NSArray*)trackPoints {
//    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer gestureType:(TBGestureType)type recognized:(BOOL)succeed {
//    if (succeed) {
//        NSLog(@"配对成功");
//        if ([self.delegate respondsToSelector:@selector(recogizedEvent:)]) {
//            RLMGesture *gesture = [RLMGesture objectForPrimaryKey:@()]
//            [self.delegate recogizedEvent:self];
//        }
//    }else{
//        NSLog(@"配对失败");
//    }
//    debugMethod();
}

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer gestureType:(TBGestureType)type gestureId:(int)gestureId recognized:(BOOL)succeed {
    if (succeed) {
        RLMResults *results = [RLMEvent objectsWhere:@"gestureId = %d", gestureId];
        if ([customGestureRecognizer.view isKindOfClass:[UITableViewCell class]]) {
            if ([self.delegate respondsToSelector:@selector(tableView:gesture:forEvent:atIndexPath:)] && results.count) {
                RLMGesture *g = [RLMGesture objectForPrimaryKey:@(gestureId)];
                TBGesture *tg = [[TBGesture alloc] init];
                tg.objectId = [@(gestureId) stringValue];
                tg.name = g.name;
                tg.type = g.type;
                
                [self.delegate tableView:self.tableView gesture:tg forEvent:results[0] atIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)customGestureRecognizer.view]];
            }
            
        }else if ([self.delegate respondsToSelector:@selector(recogizedEvent:)] && results.count) {
            [self.delegate recogizedEvent:results[0]];
        }
    }
}

- (void)pinchRecognizer:(UICustomPinchGestureRecognizer *)customPinchGestureRecognizer gestureType:(TBGestureType)type gestureId:(int)gestureId recognized:(BOOL)succeed{

    if (succeed) {
        RLMResults *results = [RLMEvent objectsWhere:@"gestureId = %d", gestureId];
        if ([customPinchGestureRecognizer.view isKindOfClass:[UITableViewCell class]]) {
            if ([self.delegate respondsToSelector:@selector(tableView:gesture:forEvent:atIndexPath:)] && results.count) {
                RLMGesture *g = [RLMGesture objectForPrimaryKey:@(gestureId)];
                TBGesture *tg = [[TBGesture alloc] init];
                tg.objectId = [@(gestureId) stringValue];
                tg.name = g.name;
                tg.type = g.type;
                
                [self.delegate tableView:self.tableView gesture:tg forEvent:results[0] atIndexPath:[self.tableView indexPathForCell:(UITableViewCell *)customPinchGestureRecognizer.view]];
            }
            
        }else if ([self.delegate respondsToSelector:@selector(recogizedEvent:)] && results.count) {
            [self.delegate recogizedEvent:results[0]];
        }
    }
}

@end
