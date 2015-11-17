//
// Created by Veight Zhou on 8/12/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface RLMPoint : RLMObject

@property CGFloat x;
@property CGFloat y;

- (CGPoint)CGPoint;

- (instancetype)initWithCGPoint:(CGPoint)cgp;

@end

RLM_ARRAY_TYPE(RLMPoint)
