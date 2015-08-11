//
//  RLMTestObject.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/11/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMTestObject : RLMObject
@property NSString *name;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLMTestObject>
RLM_ARRAY_TYPE(RLMTestObject)
