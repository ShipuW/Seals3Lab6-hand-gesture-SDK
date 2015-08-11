//
//  RLMEvent.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/11/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Realm/Realm.h>
//#import "RLMGesture.h"

@class RLMGesture;

@interface RLMEvent : RLMObject

@property int objectId;
@property NSString *name;
//@property RLMGesture *gesture;
@property int gestureId;

//+ (instancetype)eventForName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLMEvent>
RLM_ARRAY_TYPE(RLMEvent)

