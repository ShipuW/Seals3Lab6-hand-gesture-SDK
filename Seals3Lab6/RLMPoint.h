//
//  RLMPoint.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/12/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
@interface RLMPoint : RLMObject
@property CGFloat x;
@property CGFloat y;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLMPoint>
RLM_ARRAY_TYPE(RLMPoint)
