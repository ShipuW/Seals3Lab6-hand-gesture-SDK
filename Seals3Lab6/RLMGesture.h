//
//  RLMGesture.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/12/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Realm/Realm.h>
#import "Point.h"


@interface RLMGesture : RLMObject
@property int objectId;
@property NSString *name;
@property int type;
@property RLMArray<RLMPoint> *path;
@property RLMArray<RLMPoint> *rawPath;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLMGesture>
RLM_ARRAY_TYPE(RLMGesture)
