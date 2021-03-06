//
//  TBGestureRecognizer.m
//  GesturesDemo
//
//  Created by 蒙箫 on 15/8/5.
//
//
#import "TBGestureRecognizer.h"
#import "TBDataManager.h"
#import "MacroUtils.h"
#import "TBGesture.h"
#import "TBGMath.h"
#import "Point.h"
#import "SlopeRecognizer.h"
#define kSamplePoints 40
#define MIN_SCORE 0.3
#define SlopeScore 10
//#define NSLog(...)

@interface TBGestureRecognizer()

@property (nonatomic, strong) RLMResults *gestureTemplates;

@end

@implementation TBGestureRecognizer

-(instancetype)init
{
    self = [super init];
    return self;
}

+(instancetype)shareGestureRecognizer
{
    static TBGestureRecognizer  *recognizer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        recognizer = [[TBGestureRecognizer alloc] init];
    });
    return recognizer;
}

#pragma mark --- callback
-(void)matchGestureFrom:(RLMArray *)points GesturesToMatch:(RLMResults *)gesturesToMatch completion:(void(^) (NSString *matchResultId, RLMArray *resampledPoints)) completion
{
    
    RLMResults *template = gesturesToMatch ? gesturesToMatch : [RLMGesture objectsWhere:@"type = %d", 1 << 20];
    RLMArray<RLMPoint> *resampledPoints = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
    RLMGesture * bestGesture = [[RLMGesture alloc]init];
//    RLMArray<RLMPoint> *Points = (RLMArray<RLMPoint> *)[[RLMArray alloc] initWithObjectClassName:@"RLMPoint"];
    
////    
////    for (RLMGesture *templateGesture in template) {
////        NSLog(@"斜率匹配相似度：%f",[SlopeRecognizer recognize:points template:templateGesture.rawPath]);
////        
////    }
//    // 数量归一化
//    for (int i = 0; ; i++){
//        [Points addObject:[[RLMPoint alloc] initWithValue:@[@([(RLMPoint *)points[i] x]), @([(RLMPoint *)points[i] y])]]];
//        if ((RLMPoint *)points[i] == points.lastObject) {
//            break;
//        }
//    }
//
//    for (int i = 0; i < kSamplePoints; i++)
//        [resampledPoints addObject:Points[MAX(0, (Points.count-1)*i/(kSamplePoints-1))]];
//    
//    // 位置归一化
//    RLMPoint *center = Centroid(resampledPoints, kSamplePoints);
//    Translate(resampledPoints, kSamplePoints, -center.x, -center.y);
//    
//    // 角度归一化
//    RLMPoint* firstPoint = resampledPoints[0];
//    float firstPointAngle = atan2(firstPoint.y, firstPoint.x);
//    if (firstPointAngle >= -0.25 * M_PI && firstPointAngle <= 0.25 * M_PI) {
//        firstPointAngle += 0;
//    } else if (firstPointAngle >= 0.25 * M_PI && firstPointAngle <= 0.75 * M_PI) {
//        firstPointAngle += 0.5 * M_PI;
//    } else if (firstPointAngle <= -0.25 * M_PI && firstPointAngle >= -0.75 * M_PI) {
//        firstPointAngle += -0.5 * M_PI;
//    } else {
//        firstPointAngle += -1 * M_PI;
//    }
//    Rotate(resampledPoints, kSamplePoints, -firstPointAngle);
//    
//    // 大小归一化
//    RLMPoint* lowerLeft = [[RLMPoint alloc]initWithCGPoint:CGPointMake(0, 0)];
//    RLMPoint* upperRight = [[RLMPoint alloc]initWithCGPoint:CGPointMake(0, 0)];
//    for (int i = 0; i < kSamplePoints; i++) {
//        RLMPoint* pt = resampledPoints[i];
//        if (pt.x < lowerLeft.x)
//            lowerLeft.x = pt.x;
//        if (pt.y < lowerLeft.y)
//            lowerLeft.y = pt.y;
//        if (pt.x > upperRight.x)
//            upperRight.x = pt.x;
//        if (pt.y > upperRight.y)
//            upperRight.y = pt.y;
//    }
//    float scale = 2.0f/MAX(upperRight.x - lowerLeft.x, upperRight.y - lowerLeft.y);
//    Scale(resampledPoints, kSamplePoints, scale, scale);
//    
//    // 位置归一化
//    center = Centroid(resampledPoints, kSamplePoints);
//    Translate(resampledPoints, kSamplePoints, -center.x, -center.y);
//    
//    // 匹配
    
//    float bestScore = INFINITY;
//    for (RLMGesture *templateGesture in template) {
//       // NSLog(@"斜率匹配相似度：%f",[SlopeRecognizer recognize:points template:templateGesture.rawPath]);
//        RLMArray *tmpTemplate = [[RLMArray alloc]initWithObjectClassName:@"RLMPoint"];
//        [tmpTemplate addObjects:templateGesture.path];
//        float score = DistanceAtBestAngle(resampledPoints, kSamplePoints, tmpTemplate);
//        if (score < bestScore) {
//            bestGesture = templateGesture;
//            bestScore = score;
//            NSLog(@"best: %@: %f", bestGesture.name, score);
//        }
//    }
//    
    CGFloat bestScore = 0;
    
    for (RLMGesture *templateGesture in template) {
        //NSLog(@"斜率匹配相似度：%f",[SlopeRecognizer recognize:points template:templateGesture.rawPath]);
        float score=[SlopeRecognizer recognize:points template:templateGesture.rawPath];
        if (score > bestScore) {
            bestGesture = templateGesture;
            bestScore = score;
            NSLog(@"best: %@: %f", bestGesture.name, score);
        }
    }
    
    RLMGesture * resampledGesture = [[RLMGesture alloc]init];
    resampledGesture.path = resampledPoints;
    resampledGesture.rawPath = (RLMArray<RLMPoint> *)points;
    if (bestScore > SlopeScore) {
    //if (bestScore < MIN_SCORE) {
        //SlopeRecognizer* slopeResult;
        
        //NSLog(@"斜率匹配相似度：%f",slopeResult.resultSimilarity);
        completion([@(bestGesture.objectId) stringValue], resampledPoints);
    } else {
        completion(nil, resampledPoints);
    }
}

@end
