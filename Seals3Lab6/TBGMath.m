//
//  TBGMath.m
//  Seals3Lab6
//
//  Created by 蒙箫 on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import "TBGMath.h"

@implementation TBGMath

RLMPoint* Centroid(RLMArray *samples, int samplePoints)
{
    RLMPoint* center = [[RLMPoint alloc]init];
    center.x = 0;
    center.y = 0;
    if (samplePoints == 0) {
        return center;
    }
    for (int i = 0; i < samplePoints; i++) {
        RLMPoint* pt = samples[i];
        center.x += pt.x;
        center.y += pt.y;
    }
    center.x /= samplePoints;
    center.y /= samplePoints;
    return center;
}

void Translate(RLMArray *samples, int samplePoints, float x, float y)
{
    for (int i = 0; i < samplePoints; i++) {
        ((RLMPoint*)samples[i]).x += x;
        ((RLMPoint*)samples[i]).y += y;
    }
}

void Rotate(RLMArray *samples, int samplePoints, float radians)
{
    CGAffineTransform rotateTransform = CGAffineTransformMakeRotation(radians);
    for (int i = 0; i < samplePoints; i++)
    {
        CGPoint pt0 = [(RLMPoint*)samples[i] CGPoint];
        CGPoint pt = CGPointApplyAffineTransform(pt0, rotateTransform);
        ((RLMPoint*)samples[i]).x = pt.x;
        ((RLMPoint*)samples[i]).y = pt.y;
    }
}

void Scale(RLMArray *samples, int samplePoints, float xScale, float yScale)
{
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(xScale, yScale); //1.0f/(upperRight.x - lowerLeft.x), 1.0f/(upperRight.y - lowerLeft.y));
    for (int i = 0; i < samplePoints; i++)
    {
        CGPoint pt0 = [(RLMPoint*)samples[i] CGPoint];
        CGPoint pt = CGPointApplyAffineTransform(pt0, scaleTransform);
        ((RLMPoint*)samples[i]).x = pt.x;
        ((RLMPoint*)samples[i]).y = pt.y;
    }
}

float Distance(RLMPoint *p1, RLMPoint *p2)
{
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    return sqrtf(dx * dx + dy * dy);
}

float PathDistance(RLMArray *pts1, RLMArray *pts2, int count)
{
    float d = 0.0;
    for (int i = 0; i < count; i++) // assumes pts1.length == pts2.length
        d += Distance((RLMPoint*)pts1[i], (RLMPoint*)pts2[i]);
    return d / (float)count;
}

float DistanceAtAngle(RLMArray *samples, int samplePoints, RLMArray *template, float theta)
{
    RLMArray *tmp = [samples copy];
    Rotate(tmp, samplePoints, theta);
    return PathDistance(tmp, template, samplePoints);
}

float DistanceAtBestAngle(RLMArray *samples, int samplePoints, RLMArray *template)
{
    float a = -0.25f*M_PI;
    float b = -a;
    float threshold = 0.1f;
    float Phi = 0.5 * (-1.0 + sqrtf(5.0)); // Golden Ratio
    float x1 = Phi * a + (1.0 - Phi) * b;
    float f1 = DistanceAtAngle(samples, samplePoints, template, x1);
    float x2 = (1.0 - Phi) * a + Phi * b;
    float f2 = DistanceAtAngle(samples, samplePoints, template, x2);
    while (fabs(b - a) > threshold) {
        if (f1 < f2) {
            b = x2;
            x2 = x1;
            f2 = f1;
            x1 = Phi * a + (1.0 - Phi) * b;
            f1 = DistanceAtAngle(samples, samplePoints, template, x1);
        } else {
            a = x1;
            x1 = x2;
            f1 = f2;
            x2 = (1.0 - Phi) * a + Phi * b;
            f2 = DistanceAtAngle(samples, samplePoints, template, x2);
        }
    }
    return MIN(f1, f2);
}

@end
