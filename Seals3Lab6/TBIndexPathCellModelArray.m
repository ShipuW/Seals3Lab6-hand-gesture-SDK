//
//  TBIndexPathArray.m
//  Seals3Lab6
//
//  Created by Frank on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import "TBIndexPathCellModelArray.h"

@implementation TBIndexPathCellModelArray

+ (instancetype)sharedManager {
    static TBIndexPathCellModelArray *modelArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelArray = [[TBIndexPathCellModelArray alloc] init];
        
    });
    return modelArray;
}

-(NSMutableArray *)modelArray {
    if (_modelArray==nil) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

@end
