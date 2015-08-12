//
//  TBGMath.h
//  Seals3Lab6
//
//  Created by 蒙箫 on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Point.h"

@interface TBGMath : NSObject

RLMPoint* Centroid(RLMArray *samples, int samplePoints);
void Translate(RLMArray *samples, int samplePoints, float x, float y);
void Rotate(RLMArray *samples, int samplePoints, float radians);
void Scale(RLMArray *samples, int samplePoints, float xScale, float yScale);
float Distance(RLMPoint *p1, RLMPoint *p2);
float PathDistance(RLMArray *pts1, RLMArray *pts2, int count);
float DistanceAtAngle(RLMArray *samples, int samplePoints, RLMArray *template, float theta);
float DistanceAtBestAngle(RLMArray *samples, int samplePoints, RLMArray *template);

@end
