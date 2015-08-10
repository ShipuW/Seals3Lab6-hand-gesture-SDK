//
//  TBGMath.h
//  Seals3Lab6
//
//  Created by 蒙箫 on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBGMath : NSObject

CGPoint Centroid(CGPoint *samples, int samplePoints);
void Translate(CGPoint *samples, int samplePoints, float x, float y);
void Rotate(CGPoint *samples, int samplePoints, float radians);
void Scale(CGPoint *samples, int samplePoints, float xScale, float yScale);
float Distance(CGPoint p1, CGPoint p2);
float PathDistance(CGPoint *pts1, CGPoint *pts2, int count);
float DistanceAtAngle(CGPoint *samples, int samplePoints, CGPoint *template, float theta);
float DistanceAtBestAngle(CGPoint *samples, int samplePoints, CGPoint *template);

@end
