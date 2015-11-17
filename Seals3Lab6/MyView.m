//
//  MyView.m
//  LongPressDrag
//
//  Created by 王士/Users/wangshipu/Desktop/LongPressDrag/LongPressDrag/AppDelegate.h溥 on 15/8/5.
//  Copyright (c) 2015年 王士溥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyView.h"
#import "MyViewModel.h"
#import "RLMEvent.h"
#import "LineView.h"
@interface MyView ()

@end

@implementation MyView

//static MyView *sharedView = nil;

+ (instancetype)sharedView {
    static MyView *sharedInstance = nil;
    if (!sharedInstance) {
//        sharedInstance = [MyView alloc] initWithFrame:[UIScreen mainScreen].bounds tint:nil baseViewFrame:[UIScreen mainScreen].bounds emptySideLength:<#(CGFloat)#>
        sharedInstance = [[MyView alloc] init];
        sharedInstance.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];////////////-------颜色没变？
        
    }
    return sharedInstance;
}

- (void)updateWithFrame:(CGRect)frame tint:(NSArray*)array baseViewFrame:(CGRect)baseViewFrame emptySideLength:(CGFloat)emptySideLength {
        _emptyView = 0;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
        for (RLMEvent *tintDetail in array) {
            switch (tintDetail.gestureId) {
                case 1: {//UP
                    _emptyView = _emptyView | (1 << 0) | (1 << 1);
                    //UIView *v_one = [[UIView alloc]initWithFrame:CGone];
                    UILabel *tintViewUP=[[UILabel alloc]initWithFrame:CGRectMake(emptySideLength, 0, baseViewFrame.size.width - 2 * emptySideLength, emptySideLength)];
                    tintViewUP.textColor = [UIColor whiteColor];
                    //tintViewUP.
                    //tintViewUP.layer.borderWidth = 0;
                    tintViewUP.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
                    tintViewUP.text = tintDetail.name;
                    tintViewUP.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:tintViewUP];
                    break;
                }
                case 2:{//DOWN
                    _emptyView = _emptyView | (1 << 2) | (1 << 3);
                    UILabel *tintViewDOWN=[[UILabel alloc] initWithFrame:CGRectMake(emptySideLength, baseViewFrame.size.height - emptySideLength, baseViewFrame.size.width - 2 * emptySideLength, emptySideLength)];
                    tintViewDOWN.textColor = [UIColor whiteColor];
                    tintViewDOWN.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
                    tintViewDOWN.text = tintDetail.name;
                    tintViewDOWN.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:tintViewDOWN];
                    break;
                }
                case 4:{//LEFT
                    _emptyView = _emptyView | (1 << 0) | (1 << 2);
                    UILabel *tintViewLEFT=[[UILabel alloc]initWithFrame:CGRectMake(0, emptySideLength, emptySideLength, baseViewFrame.size.height - 2 * emptySideLength)];
                    tintViewLEFT.textColor = [UIColor whiteColor];
                    tintViewLEFT.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
                    tintViewLEFT.text = tintDetail.name;
                    tintViewLEFT.textAlignment = NSTextAlignmentCenter;
                    [self addSubview:tintViewLEFT];
                    break;
                }
                case 8:{//RIGHT
                    _emptyView = _emptyView | (1 << 1) | (1 << 3);
                    UILabel *tintViewRIGHT=[[UILabel alloc]initWithFrame:CGRectMake(baseViewFrame.size.width - emptySideLength, emptySideLength, emptySideLength, baseViewFrame.size.height - 2 * emptySideLength)];
                    tintViewRIGHT.textColor = [UIColor whiteColor];
                    tintViewRIGHT.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
                    tintViewRIGHT.text = tintDetail.name;
                    tintViewRIGHT.textAlignment = NSTextAlignmentCenter;

                    [self addSubview:tintViewRIGHT];
                    break;
                }
                default:
                    continue;
            }
        }
    if (_emptyView & (1 << 0)) {
        UIView *tintViewEmpty=[[UIView alloc]initWithFrame:CGRectMake(0, 0, emptySideLength, emptySideLength)];
        tintViewEmpty.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        [self addSubview:tintViewEmpty];
    }
    if (_emptyView & (1 << 1)) {
        UIView *tintViewEmpty=[[UIView alloc]initWithFrame:CGRectMake(baseViewFrame.size.width - emptySideLength, 0, emptySideLength, emptySideLength)];
        tintViewEmpty.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        [self addSubview:tintViewEmpty];
    }
    if (_emptyView & (1 << 2)) {
        UIView *tintViewEmpty=[[UIView alloc]initWithFrame:CGRectMake(0, baseViewFrame.size.height - emptySideLength, emptySideLength, emptySideLength)];
        tintViewEmpty.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        [self addSubview:tintViewEmpty];
    }
    if (_emptyView & (1 << 3)) {
        UIView *tintViewEmpty=[[UIView alloc]initWithFrame:CGRectMake(baseViewFrame.size.width - emptySideLength, baseViewFrame.size.height - emptySideLength, emptySideLength, emptySideLength)];
        tintViewEmpty.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.8];
        [self addSubview:tintViewEmpty];
    }
}




- (LineView*) addLineViewWithFrame:(CGRect)baseViewFrame
{
    //NSLog(@"%@",array);
//    if ([self viewWithTag:(13579)] != nil) {
//        
//    }else

    LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(0, 0, baseViewFrame.size.width, baseViewFrame.size.height) ];
    [self.lineViews addObject:lineView];
    for (LineView *lineview in _lineViews) {
        [self addSubview:lineview];
    }
    
    return lineView;
    
}

- (NSMutableArray *)lineViews {
    if (!_lineViews) {
        _lineViews = [NSMutableArray array];
    }
    return _lineViews;
}

- (void) removeAllLineView{
    NSArray *subviews = [self subviews];
    for(__strong UIView *tmpView in subviews)
    {
        if([tmpView isKindOfClass:([LineView class])])
        {
            [tmpView removeFromSuperview];
            tmpView = nil;
            
        }
    }
    _lineViews = nil;
    if (!_lineViews) {
        _lineViews = [NSMutableArray array];
    }
}

@end



