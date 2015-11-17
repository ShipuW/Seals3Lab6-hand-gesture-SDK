//
//  TBGestureEventMap.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TBGesture;
@class TBGEvent;

@interface TBGestureEventMap : NSObject

@property (nonatomic, copy) NSString *mapId;
@property (nonatomic, copy) NSString *gestureId;
@property (nonatomic, copy) NSString *eventId;

- (TBGesture *)gesture;
- (TBGEvent *)event;


@end
