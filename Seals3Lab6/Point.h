//
// Created by Veight Zhou on 8/12/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RLMPoint : RLMObject

@property float x;
@property float y;

@end

RLM_ARRAY_TYPE(RLMPoint)
