//
//  UIGestureRecognizer+UICustomGestureRecognizer.h
//  LongPressDrag
//
//  Created by 王士/Users/wangshipu/Desktop/LongPressDrag/LongPressDrag/AppDelegate.h溥 on 15/8/5.
//  Copyright (c) 2015年 王士溥. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIGestureRecognizer.h>

#import <Foundation/Foundation.h>
#import "MyView.h"
#import "TBGesture.h"

typedef NS_OPTIONS(NSUInteger, UICustomGestureRecognizerDirection) {
    //UICustomGestureRecognizerDirectionNot         = 0,
    UICustomGestureRecognizerDirectionUp       = 1 << 0,
    UICustomGestureRecognizerDirectionDown     = 1 << 1,
    UICustomGestureRecognizerDirectionLeft     = 1 << 2,
    UICustomGestureRecognizerDirectionRight    = 1 << 3,

    UICustomGestureRecognizerDirectionNot      = 1 << 20,
//    UICustomGestureRecognizerDirectionRight = 1 << 0,
//    UICustomGestureRecognizerDirectionLeft  = 1 << 1,
//    UICustomGestureRecognizerDirectionUp    = 1 << 2,
//    UICustomGestureRecognizerDirectionDown  = 1 << 3,
//    UICustomGestureRecognizerDirectionNot   = 1 << 4
    
//    TBGestureTypeSystem         = 0,
//
//    TBGestureTypeSimplePinchIN  = 1 << 5,
//    TBGestureTypeSimplePinchOUT = 1 << 6,
//    TBGestureTypeCustom         = 1 << 20,
};


@class UICustomGestureRecognizer;
@protocol TBCustomGestureRecognizerDelegate <NSObject>

- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateBeginAtPosition:(CGPoint)position;
- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateChangedAtPosition:(CGPoint)position;
- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer stateEndAtPosition:(CGPoint)position;
- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer trackGenerate:(NSArray*)trackPoints;
- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer gestureType:(TBGestureType)type recognized:(BOOL)succeed;
- (void)gestureRecognizer:(UICustomGestureRecognizer *)customGestureRecognizer gestureType:(TBGestureType)type gestureId:(int)gestureId recognized:(BOOL)succeed;

@end
//@interface UIGestureRecognizer (UICustomGestureRecognizer)

@interface UICustomGestureRecognizer : UILongPressGestureRecognizer
{
    @package
    BOOL                _needSimpleMatch;
    BOOL                _displayPoint;
    BOOL                _contain;
    BOOL                _shouldEnd;
    BOOL                _isMoved;
    CGPoint             _startPoint;
    CGPoint             _lastPoint;
    CGPoint             _originPoint;
    id                  _gestureTarget;
    
    CGPoint             _touchPoint;
    UIView             *_touchView;
    UIView             *_baseView;
    MyView             *_myView;
    TBGestureType       _targetType;
}
@property (weak) id target;
@property SEL action;
@property (nonatomic) NSString *gestureId;
@property (nonatomic) BOOL isSimpleGesture;
@property (nonatomic) NSMutableArray *trackPoints;
@property (nonatomic) NSMutableArray *itemArray;
//@property (assign, nonatomic) CGMutablePathRef path;
@property (nonatomic, readwrite) NSArray *touchPoints;
@property (nonatomic) UICustomGestureRecognizerDirection direction;
@property (nonatomic, strong) NSArray *customGestureIds;
//@property (nonatomic, weak) TBGesture *tbGesture;
@property (nonatomic) id<TBCustomGestureRecognizerDelegate> recognizeDelegate;

- (instancetype)initWithTarget:(id)target action:(SEL)action type:(TBGestureType)type;
- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender;

@end
