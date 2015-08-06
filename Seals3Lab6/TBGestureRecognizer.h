//
//  TBGestureRecognizer.h
//  GesturesDemo
//
//  Created by 蒙箫 on 15/8/5.
//
//

#import <Foundation/Foundation.h>

@interface TBGestureRecognizer : NSObject

// 调用方法：
// [[TBGestureRecognizer shareGestureRecognizer]matchGestureFrom: completion: {}];


+(instancetype) shareGestureRecognizer;
// points内为NSValue，由CGPoint转化
-(void)matchGestureFrom:(NSArray *)points completion:(void(^) (NSString *gestureId, NSArray *resampledGesture)) completion;
@end
