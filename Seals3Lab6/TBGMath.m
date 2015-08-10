//
//  TBGMath.m
//  Seals3Lab6
//
//  Created by 蒙箫 on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import "TBGMath.h"

@implementation TBGMath

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

@end
