//
// Created by Veight Zhou on 8/9/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TBCellViewModel : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) void (^didSelectAction)();

@end