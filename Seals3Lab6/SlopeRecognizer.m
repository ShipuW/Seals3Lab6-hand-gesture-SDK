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

//#define TurnAngle 0.342     //70度
//#define TurnAngle 0.174     //80度
//#define TurnAngle 0.087     //85度
#define TurnAngle 0         //90度
//#define TurnAngle -0.174    //100度
//#define TurnAngle -0.342    //110度
//#define TurnAngle -0.5      //120度

@implementation SlopeRecognizer


+(NSMutableArray *)retrunTurnLocation:(RLMArray *)Points{
    //_index = 0;
    NSMutableArray *array = [NSMutableArray array];
    for (int index = 0; ; index++) {
        if ([(RLMPoint*)Points[index] x] * [(RLMPoint*)Points[index + 2] x] + [(RLMPoint*)Points[index] y] * [(RLMPoint*)Points[index + 2] y] < TurnAngle) {
            [array addObject:[NSNumber numberWithInteger:(index+1)]];
        }
        if ((RLMPoint*)Points[index + 2] == Points.lastObject) {
            break;
        }
    }

    return array;
}

+(NSMutableArray*)countTurnLocation:(NSMutableArray*)array{
    NSMutableArray *rearray = [NSMutableArray array];
    //int count = 0;
    int preNumber = -2;
    for (NSNumber *number in array) {//未考虑多个连续的情况
        if ([number integerValue]!=preNumber+1) {
            [rearray addObject:[NSNumber numberWithFloat:([number integerValue])]];
        }else{
            [rearray removeObject:rearray.lastObject];
            [rearray addObject:[NSNumber numberWithFloat:(preNumber+0.5)]];
        }
        preNumber = [number integerValue];
    }
    return rearray;
}

+(BOOL)turnRecognizer:(RLMArray *)Points1 and:(RLMArray *)Points2{
    NSArray *p1=[self countTurnLocation:[self retrunTurnLocation:Points1]];
    NSArray *p2=[self countTurnLocation:[self retrunTurnLocation:Points2]];
    if ([p1 count]==[p2 count]) {
        for (int i = 0; i < [p1 count]; i++) {
            if(fabs([p1[i] floatValue]-[p2[i] floatValue])>2){
                return NO;
            }else{
                continue;
            }
        }
        return YES;
    }else{
        return NO;
    }
}

+(void)modifyValue:(RLMArray *)Points1 and:(RLMArray *)Points2{
    NSArray *p1=[self countTurnLocation:[self retrunTurnLocation:Points1]];
    NSArray *p2=[self countTurnLocation:[self retrunTurnLocation:Points2]];
//    int i = 0;
//    for (NSNumber *pp in p1) {
//        int j = 0;
//        for (NSNumber *pq in p2) {
//            debugLog(@"%f",ceilf([pp floatValue])) ;
//            if (i!=j) {
//                j++;
//                continue;
//            }else{
//                CGFloat dif = [pp floatValue]-[pq floatValue];
//                if (fabs(dif) < 1) {
//                    continue;
//                }else if(fabs(dif)<2){
//                    if (dif>0) {//模板拐点前短//变换有坑-------------------------------
//                        Points2[(int)ceilf([pq floatValue])]=Points2[(int)ceilf([pq floatValue])-1];
//                    }else{
//                        Points1[(int)ceilf([pp floatValue])]=Points1[(int)ceilf([pp floatValue])-1];
//                    }
//                }else if(fabs(dif)<3){
//                    if (dif>0) {
//                        Points2[(int)ceilf([pq floatValue])]=Points2[(int)ceilf([pq floatValue])-1];
//                        Points2[(int)ceilf([pq floatValue])+1]=Points2[(int)ceilf([pq floatValue])-1];
//                    }else{
//                        Points1[(int)ceilf([pp floatValue])]=Points1[(int)ceilf([pp floatValue])-1];
//                        Points1[(int)ceilf([pp floatValue])+1]=Points1[(int)ceilf([pp floatValue])-1];
//                    }
//                }else{
//                    break;
//                }
//                break;
//            }
//        }
//        i++;
//    }
    if ([p1 count]!=[p2 count])
    {
    }else{
        for (int i = 0; i < [p1 count]; i++) {
            CGFloat dif = [p1[i] floatValue]-[p2[i] floatValue];
            if (fabs(dif) < 1) {
                continue;
            }else if(fabs(dif)<2){
                if (dif>0) {//模板拐点前短//变换有坑-------------------------------
                    Points2[(int)ceilf([p2[i] floatValue])]=Points2[(int)ceilf([p2[i] floatValue])-1];
                }else{
                    Points1[(int)ceilf([p2[i] floatValue])]=Points1[(int)ceilf([p1[i] floatValue])-1];
                }
            }else if(fabs(dif)<3){
                if (dif>0) {
                    Points2[(int)ceilf([p2[i] floatValue])]=Points2[(int)ceilf([p2[i] floatValue])-1];
                    Points2[(int)ceilf([p2[i] floatValue])+1]=Points2[(int)ceilf([p2[i] floatValue])-1];
                }else{
                    Points1[(int)ceilf([p1[i] floatValue])]=Points1[(int)ceilf([p1[i] floatValue])-1];
                    Points1[(int)ceilf([p1[i] floatValue])+1]=Points1[(int)ceilf([p1[i] floatValue])-1];
                }
            }else{
                continue;
            }
        }
//    NSMutableArray *returnArray = [NSMutableArray array];
//    [returnArray addObject:Points1];
//    [returnArray addObject:Points2];
//    return returnArray;
    }
}


+(CGFloat)recognize:(RLMArray *)points template:(RLMArray *)templatePoints{
    if ([points count] == 0) {
        return -1;
    }
    
    RLMArray *c = [self resampleBetweenPoints:points];
    RLMArray *t = [self resampleBetweenPoints:templatePoints];
    
    debugLog(@"画的%@个拐点：%@",[self countTurnLocation:[self retrunTurnLocation:c]] ,[self retrunTurnLocation:c]);
    debugLog(@"模板%@个拐点：%@",[self countTurnLocation:[self retrunTurnLocation:t]] ,[self retrunTurnLocation:t]);
    if ([self turnRecognizer:c and:t]) {
        debugLog(@"匹配");
    }else{
        debugLog(@"不匹配");
    }
    //debugLog(@"%@哦哦哦%@",c,t);
//    [self modifyValue:c and:t];
//    NSArray *resultArray = [self modifyValue:c and:t];
//    c=resultArray[0];
//    t=resultArray[1];
    //debugLog(@"%@哦哦哦%@",c,t);
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
    debugLog(@"未调整拐点相似度：%f",similarity);
    [self modifyValue:c and:t];
    similarity = CGFLOAT_MIN;
    d = 0.0;
    count = MIN([c count], [t count]);
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
    //debugLog(@"总长度%f",[self pathLenth:points]);
    //debugLog(@"规范片段长度%f",i);
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
            //debugLog(@"第%ld段实际片段长度%f", (long)ti, d+pd-[self distanceBetweenPoint:q andPoint:points[index]]);
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
