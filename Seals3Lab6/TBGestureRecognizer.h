//
//  TBGestureRecognizer.h
//  GesturesDemo
//
//  Created by 蒙箫 on 15/8/5.
//
//

#import <Foundation/Foundation.h>
#import "RLMGesture.h"

@interface TBGestureRecognizer : NSObject

// 调用方法：
// [[TBGestureRecognizer shareGestureRecognizer]matchGestureFrom: GesturesToMatch: completion: {}];

+(instancetype) shareGestureRecognizer;
-(void)matchGestureFrom:(RLMArray *)points GesturesToMatch:(RLMResults *)gesturesToMatch completion:(void(^) (NSString *matchResultId, RLMArray *resampledPoints)) completion;
@end
