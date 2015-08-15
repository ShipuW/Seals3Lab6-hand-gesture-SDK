//
//  SlopeRecognizer.m
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/14.
//  Copyright © 2015年 Veight Zhou. All rights reserved.
//

#import "SlopeRecognizer.h"

#import "TBDataManager.h"
#import "MacroUtils.h"
#import "TBGesture.h"
#import "TBGMath.h"
#import "Point.h"

#define NumResamplingPoints 16

@implementation SlopeRecognizer



+(CGFloat)recognize:(RLMArray *)points template:(RLMArray *)templatePoints{
    if ([points count] == 0) {
        return -1;
    }
    
    RLMArray *c = [self resampleBetweenPoints:points];
    RLMArray *t = [self resampleBetweenPoints:templatePoints];
    
    
    if ([c count] == 0 || [t count] == 0) {
        return -1;
    }
    
    CGFloat similarity = CGFLOAT_MIN;
    CGFloat d = 0.0;
    CGFloat count = MIN([c count], [t count]);
//    if (count != [c count] || count != [t count]) {
//        return -1;
//    }
    for (int i = 0; i < count; i++) {
        RLMPoint *tp = t[i];
        RLMPoint *cp = c[i];
        
        d = d + tp.x * cp.x + tp.y * cp.y; //cos(a-b)
        
        if (d > similarity) {
            similarity = d;
        }
    }
    
    return similarity;
}


+(RLMArray *)resampleBetweenPoints:(RLMArray *)Points{
    RLMArray *points = [[RLMArray alloc]initWithObjectClassName:@"RLMPoint"];
    [points addObjects:Points];
    CGFloat i = [self pathLenth:points] / (NumResamplingPoints - 1);
    debugLog(@"总长度%f",[self pathLenth:points]);
    debugLog(@"规范片段长度%f",i);
    CGFloat d = 0;
    RLMArray *v = [[RLMArray alloc]initWithObjectClassName:@"RLMPoint"];
    RLMPoint *prev = points.firstObject;
    RLMPoint *thisPoint;
    RLMPoint *prevPoint;
    CGFloat pd;
    NSInteger ti = 1;
    NSUInteger index = 0;
    while (YES) {
        
//    for (id pp in points) {
//        if(pp==nil){};
        if (index == 0) {
            index ++ ;
            continue;
        }
        thisPoint = points[index];
        prevPoint = points[index - 1];
        pd = [self distanceBetweenPoint:thisPoint andPoint:prevPoint];
        
        if ((d + pd) >= i) {
            
            RLMPoint *q = [[RLMPoint alloc]initWithCGPoint:CGPointMake(prevPoint.x + (thisPoint.x - prevPoint.x) * (i - d) / pd, prevPoint.y + (thisPoint.y - prevPoint.y) * (i - d) / pd)];
            RLMPoint *r = [[RLMPoint alloc]initWithCGPoint:CGPointMake(q.x - prev.x, q.y - prev.y)];
            CGFloat rd = [self distanceBetweenPoint:[[RLMPoint alloc]initWithCGPoint:CGPointZero] andPoint:r];
            debugLog(@"第%ld段实际片段长度%f", (long)ti, d+pd-[self distanceBetweenPoint:q andPoint:points[index]]);
            ti++;
            d = 0.0;
            d = d + [self distanceBetweenPoint:q andPoint:points[index]];
            
            r.x = r.x / rd;
            r.y = r.y / rd;
            
            
            prev = q;
            
            [v addObject:r];
            [points insertObject:q atIndex:index];
            index++;
        }else{
            d = d + pd;
        }
        
        if (points[index]==points.lastObject) {
            break;
        }
        index++;
    }
    return v;

}

///
///


+(CGFloat)pathLenth:(RLMArray *)points{
    CGFloat d = 0.0;
    for (int i = 1; i < points.count; i++) {
        d = d + [self distanceBetweenPoint:points[i - 1] andPoint:points[i]];
    }
    return d;
}


+(CGFloat)distanceBetweenPoint:(RLMPoint *)pointA andPoint:(RLMPoint *)pointB{
    CGFloat distX = pointA.x - pointB.x;
    CGFloat distY = pointA.y - pointB.y;
    return sqrt((distX * distX) + (distY * distY));
}


@end
