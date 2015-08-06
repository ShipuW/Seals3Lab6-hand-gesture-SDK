//
//  TBEvent.h
//  Seals3Lab6
//
//  Created by Veight Zhou on 8/5/15.
//  Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBEvent : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL canEditGesture;

+ (NSArray *)allEvents;

@end
