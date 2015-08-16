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
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
        for (RLMEvent *tintDetail in array) {
            switch (tintDetail.gestureId) {
                case 1: {//UP
                    //UIView *v_one = [[UIView alloc]initWithFrame:CGone];
                    UILabel *tintViewUP=[[UILabel alloc]initWithFrame:CGRectMake(emptySideLength, 0, baseViewFrame.size.width - 2 * emptySideLength, emptySideLength)];
                    tintViewUP.text = tintDetail.name;
                    tintViewUP.textAlignment = NSTextAlignmentCenter;
                    tintViewUP.backgroundColor = [UIColor yellowColor];
                    [self addSubview:tintViewUP];
                    break;
                }
                case 2:{//DOWN
                    UILabel *tintViewDOWN=[[UILabel alloc] initWithFrame:CGRectMake(emptySideLength, baseViewFrame.size.height - emptySideLength, baseViewFrame.size.width - 2 * emptySideLength, emptySideLength)];
                    tintViewDOWN.text = tintDetail.name;
                    tintViewDOWN.textAlignment = NSTextAlignmentCenter;
                    tintViewDOWN.backgroundColor = [UIColor yellowColor];
                    [self addSubview:tintViewDOWN];
                    break;
                }
                case 4:{//LEFT
                    UILabel *tintViewLEFT=[[UILabel alloc]initWithFrame:CGRectMake(0, emptySideLength, emptySideLength, baseViewFrame.size.height - 2 * emptySideLength)];
                    tintViewLEFT.text = tintDetail.name;
                    tintViewLEFT.textAlignment = NSTextAlignmentCenter;
                    tintViewLEFT.backgroundColor = [UIColor yellowColor];
                    [self addSubview:tintViewLEFT];
                    break;
                }
                case 8:{//RIGHT
                    UILabel *tintViewRIGHT=[[UILabel alloc]initWithFrame:CGRectMake(baseViewFrame.size.width - emptySideLength, emptySideLength, emptySideLength, baseViewFrame.size.height - 2 * emptySideLength)];
                    tintViewRIGHT.text = tintDetail.name;
                    tintViewRIGHT.textAlignment = NSTextAlignmentCenter;
                    tintViewRIGHT.backgroundColor = [UIColor yellowColor];
                    [self addSubview:tintViewRIGHT];
                    break;}
                default:
                    continue;
            }
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



