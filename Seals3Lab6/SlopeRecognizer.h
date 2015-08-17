//
//  SlopeRecognizer.h
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/14.
//  Copyright © 2015年 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TBDataManager.h"
#import "MacroUtils.h"
#import "TBGesture.h"
#import "TBGMath.h"
#import "Point.h"
@interface SlopeRecognizer : NSObject
//{
//    @package
//    int                 _index;
//}
@property (nonatomic) CGFloat *gestureId;
//@property (nonatomic) int index;

+(CGFloat)recognize:(RLMArray*)points template:(RLMArray *)templatePoints;
+(RLMArray *)resampleBetweenPoints:(RLMArray *)points;
+(CGFloat)pathLenth:(RLMArray *)points;
+(CGFloat)distanceBetweenPoint:(RLMPoint *)pointA andPoint:(RLMPoint *)pointB;
+(NSMutableArray *)retrunTurnLocation:(RLMArray *)Points;
@end
