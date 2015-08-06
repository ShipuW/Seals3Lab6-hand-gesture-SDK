//
//  TBGestureRecognizer.m
//  GesturesDemo
//
//  Created by 蒙箫 on 15/8/5.
//
//
#import <UIKit/UIKit.h>
#import "TBGestureRecognizer.h"

#define kSamplePoints 30
#define MIN_SCORE 0.5
#define PI 3.14

// Utility/Math Functions:
CGPoint Centroid(CGPoint *samples, int samplePoints);
void Translate(CGPoint *samples, int samplePoints, float x, float y);
void Rotate(CGPoint *samples, int samplePoints, float radians);
void Scale(CGPoint *samples, int samplePoints, float xScale, float yScale);
float Distance(CGPoint p1, CGPoint p2);
float PathDistance(CGPoint *pts1, CGPoint *pts2, int count);
float DistanceAtAngle(CGPoint *samples, int samplePoints, CGPoint *template, float theta);
float DistanceAtBestAngle(CGPoint *samples, int samplePoints, CGPoint *template);

@interface TBGestureRecognizer()

@property (nonatomic, strong) NSDictionary *gestureDic;
@property (nonatomic, strong) NSArray *gesture;
@property (nonatomic, strong) NSMutableArray *resampleGesture;

@end

@implementation TBGestureRecognizer

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.resampleGesture = [NSMutableArray array];
        self.gestureDic = [NSDictionary dictionary];
        self.gesture = [NSArray array];
        NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Gestures" ofType:@"json"]];
        NSError *error;
        [self loadTemplatesFromJsonData:jsonData error:&error];
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

// TO BE DELETED
- (BOOL)loadTemplatesFromJsonData:(NSData *)jsonData error:(NSError **)errorOut
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:errorOut];
    if (!dict)
        return NO;
    
    NSMutableDictionary *output = [NSMutableDictionary dictionary];
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSArray *value, BOOL *stop) {
        NSMutableArray *points = [NSMutableArray arrayWithCapacity:value.count];
        for (NSArray *pointArray in value)
        {
            CGPoint point = CGPointMake([pointArray[0] floatValue], [pointArray[1] floatValue]);
            [points addObject:[NSValue valueWithCGPoint:point]];
        }
        output[key] = [points copy]; // mutable to immutable
    }];
    self.gestureDic = [output copy]; // mutable to immuatable
    return YES;
}


#pragma mark --- callback
-(void)matchGestureFrom:(NSArray *)points completion:(void(^) (NSString *gestureId, NSArray *resampledGesture)) completion
{
    NSString *result = [self recognizeGestureWithPoints:points];
    completion(result, self.resampleGesture);
}

-(NSString *)recognizeGestureWithPoints:(NSArray *)points
{
    self.gesture = points;
    
    NSString *bestTemplateName;
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
    
    CGPoint lowerLeft, upperRight;
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
    for (NSString *templateName in [self.gestureDic allKeys]) {
        NSArray *templateSamples = [self.gestureDic objectForKey:templateName];
        CGPoint template[kSamplePoints];
        NSAssert(kSamplePoints == [templateSamples count], @"Template size mismatch");
        for (i = 0; i < kSamplePoints; i++) {
            template[i] = [[templateSamples objectAtIndex:i] CGPointValue];
        }
        float score = DistanceAtBestAngle(samples, kSamplePoints, template);
        NSLog(@"%@: %f", templateName, score);

        if (score < best) {
            bestTemplateName = [NSString stringWithString:templateName];
            best = score;
        }
    }
    self.resampleGesture = [NSMutableArray arrayWithCapacity:kSamplePoints];
    for (i = 0; i < kSamplePoints; i++)
    {
        CGPoint pt = samples[i];
        [self.resampleGesture addObject:[NSValue valueWithCGPoint:pt]];
    }
    
//    NSMutableString *string = [NSMutableString stringWithString:@"\"template_name\": [ "];
//    for (i = 0; i < kSamplePoints; i++)
//    {
//        CGPoint pt = samples[i];
//        [string appendFormat:@"[%0.2f, %0.2f], ", pt.x, pt.y];
//    }
//    [string appendString:@"],\n"];
//    NSLog(@"Read:\n%@", string);
    
    if (best < MIN_SCORE) {
        return bestTemplateName;
    } else {
        return nil;
    }
}

@end

#pragma mark --- math
CGPoint Centroid(CGPoint *samples, int samplePoints)
{
    CGPoint center = CGPointZero;
    for (int i = 0; i < samplePoints; i++)
    {
        CGPoint pt = samples[i];
        center.x += pt.x;
        center.y += pt.y;
    }
    center.x /= samplePoints;
    center.y /= samplePoints;
    return center;
}
void Translate(CGPoint *samples, int samplePoints, float x, float y)
{
    for (int i = 0; i < samplePoints; i++)
    {
        CGPoint pt = samples[i];
        samples[i] = CGPointMake(pt.x+x, pt.y+y);
    }
}
void Rotate(CGPoint *samples, int samplePoints, float radians)
{
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(radians);
    for (int i = 0; i < samplePoints; i++)
    {
        CGPoint pt0 = samples[i];
        CGPoint pt = CGPointApplyAffineTransform(pt0, rotateTransform);
        samples[i] = pt;
    }
}
void Scale(CGPoint *samples, int samplePoints, float xScale, float yScale)
{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(xScale, yScale); //1.0f/(upperRight.x - lowerLeft.x), 1.0f/(upperRight.y - lowerLeft.y));
    for (int i = 0; i < samplePoints; i++)
    {
        CGPoint pt0 = samples[i];
        CGPoint pt = CGPointApplyAffineTransform(pt0, scaleTransform);
        samples[i] = pt;
    }
}
float Distance(CGPoint p1, CGPoint p2)
{
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    return sqrtf(dx * dx + dy * dy);
}
float PathDistance(CGPoint *pts1, CGPoint *pts2, int count)
{
    float d = 0.0;
    for (int i = 0; i < count; i++) // assumes pts1.length == pts2.length
        d += Distance(pts1[i], pts2[i]);
    return d / (float)count;
}
float DistanceAtAngle(CGPoint *samples, int samplePoints, CGPoint *template, float theta)
{
    const int maxPoints = 128;
    CGPoint newPoints[maxPoints];
    assert(samplePoints <= maxPoints);
    memcpy(newPoints, samples, sizeof(CGPoint)*samplePoints);
    Rotate(newPoints, samplePoints, theta);
    return PathDistance(newPoints, template, samplePoints);
}
float DistanceAtBestAngle(CGPoint *samples, int samplePoints, CGPoint *template)
{
    float a = -0.25f*M_PI;
    float b = -a;
    float threshold = 0.1f;
    float Phi = 0.5 * (-1.0 + sqrtf(5.0)); // Golden Ratio
    float x1 = Phi * a + (1.0 - Phi) * b;
    float f1 = DistanceAtAngle(samples, samplePoints, template, x1);
    float x2 = (1.0 - Phi) * a + Phi * b;
    float f2 = DistanceAtAngle(samples, samplePoints, template, x2);
    while (fabs(b - a) > threshold)
    {
        if (f1 < f2)
        {
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = Phi * a + (1.0 - Phi) * b;
            f1 = DistanceAtAngle(samples, samplePoints, template, x1);
        }
        else
        {
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = (1.0 - Phi) * a + Phi * b;
            f2 = DistanceAtAngle(samples, samplePoints, template, x2);
        }
    }
    return MIN(f1, f2);
}