//
//  TBGestureRecognizer.h
//  GesturesDemo
//
//  Created by 蒙箫 on 15/8/5.
//
//

#import <Foundation/Foundation.h>

@interface TBGestureRecognizer : NSObject
+(instancetype) shareGestureRecognizer;
// points内为NSValue，由CGPoint转化
-(void)matchGestureFrom:(NSArray *)points completion:(void(^) (NSString *gestureId, NSArray *resampledGesture)) completion;
@end
