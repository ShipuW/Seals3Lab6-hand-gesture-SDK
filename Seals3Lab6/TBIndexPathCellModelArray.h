//
//  TBIndexPathArray.h
//  Seals3Lab6
//
//  Created by Frank on 15/8/10.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBIndexPathCellModelArray : NSObject

@property(nonatomic, strong) NSMutableArray *modelArray;

@property(nonatomic) int times;

+ (instancetype)sharedManager;

@end
