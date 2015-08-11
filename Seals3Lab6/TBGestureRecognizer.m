//
//  TBGestureRecognizer.m
//  GesturesDemo
//
//  Created by 蒙箫 on 15/8/5.
//
//
#import <UIKit/UIKit.h>
#import "TBGestureRecognizer.h"
#import "TBDataManager.h"
#import "MacroUtils.h"
#import "TBGesture.h"
#import "TBGMath.h"

#define kSamplePoints 30
#define MIN_SCORE 0.5
#define PI 3.14


#define NSLog(...)

@interface TBGestureRecognizer()

@property (nonatomic, strong) NSArray *gestureTemplates;
@property (nonatomic, strong) NSArray *gesture;
@property (nonatomic, strong) NSMutableArray *resampleGesture;

@end

@implementation TBGestureRecognizer

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.resampleGesture = [NSMutableArray array];
        self.gestureTemplates = [NSArray array];
        self.gesture = [NSArray array];
        
    }
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
-(void)matchGestureFrom:(NSArray *)points completion:(void(^) (NSString *gestureId, NSArray *resampledGesture)) completion
{
    @weakify(self);
    [SharedDataManager loadAllGesturesFromDatabase:^(NSArray *results, NSError *error) {
        @strongify(self);
        self.gestureTemplates = results;
    }];
    NSString *result = [self recognizeGestureWithPoints:points];
    completion(result, self.resampleGesture);
}

-(NSString *)recognizeGestureWithPoints:(NSArray *)points
{
    self.gesture = points;
    
    NSString *bestTemplateId;
    int i;
    CGPoint samples[kSamplePoints];
    
    for (i = 0; i < kSamplePoints; i++) {
        samples[i] = [[self.gesture objectAtIndex:MAX(0, (self.gesture.count-1)*i/(kSamplePoints-1))] CGPointValue];
    }
    
    CGPoint center = Centroid(samples, kSamplePoints);
    Translate(samples, kSamplePoints, -center.x, -center.y);
    
    CGPoint firstPoint = samples[0];
    float firstPointAngle = atan2(firstPoint.y, firstPoint.x);
    if (firstPointAngle >= -0.25 * PI && firstPointAngle <= 0.25 * PI) {
        firstPointAngle += 0;
    } else if (firstPointAngle >= 0.25 * PI && firstPointAngle <= 0.75 * PI) {
        firstPointAngle += 0.5 * PI;
    } else if (firstPointAngle <= -0.25 * PI && firstPointAngle >= -0.75 * PI) {
        firstPointAngle += -0.5 * PI;
    } else {
        firstPointAngle += -1 * PI;
    }
    Rotate(samples, kSamplePoints, -firstPointAngle);
    
    CGPoint lowerLeft = CGPointMake(0, 0);
    CGPoint upperRight = CGPointMake(0, 0);
    for (i = 0; i < kSamplePoints; i++) {
        CGPoint pt = samples[i];
        if (pt.x < lowerLeft.x)
            lowerLeft.x = pt.x;
        if (pt.y < lowerLeft.y)
            lowerLeft.y = pt.y;
        if (pt.x > upperRight.x)
            upperRight.x = pt.x;
        if (pt.y > upperRight.y)
            upperRight.y = pt.y;
    }

    float scale = 2.0f/MAX(upperRight.x - lowerLeft.x, upperRight.y - lowerLeft.y);
    Scale(samples, kSamplePoints, scale, scale);

    center = Centroid(samples, kSamplePoints);
    Translate(samples, kSamplePoints, -center.x, -center.y);
    
    float best = INFINITY;
    for (TBGesture *templateGesture in self.gestureTemplates) {
        CGPoint template[kSamplePoints];
        for (i = 0; i < kSamplePoints; i++) {
            template[i] = [templateGesture.path[i] CGPointValue];
        }
        float score = DistanceAtBestAngle(samples, kSamplePoints, template);
        
        if (score < best) {
            bestTemplateId = [NSString stringWithString:templateGesture.objectId];
            best = score;
            NSLog(@"best: %@: %f", templateGesture.name, score);
        }
    }
    self.resampleGesture = [NSMutableArray arrayWithCapacity:kSamplePoints];
    for (i = 0; i < kSamplePoints; i++)
    {
        CGPoint pt = samples[i];
        [self.resampleGesture addObject:[NSValue valueWithCGPoint:pt]];
    }
    
    if (best < MIN_SCORE) {
        return bestTemplateId;
    } else {
        return nil;
    }
}

@end
