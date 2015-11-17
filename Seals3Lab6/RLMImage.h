//
//  RLMImage.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/13/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Realm/Realm.h>

@interface RLMImage : RLMObject
@property int gestureId;
@property NSData *imageData;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<RLMImage>
RLM_ARRAY_TYPE(RLMImage)
