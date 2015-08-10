//
//  PostConnection.h
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/9.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

//#ifndef Seals3Lab6_PostConnection_h
//#define Seals3Lab6_PostConnection_h
//
//
//#endif


@interface PostConnection : NSObject


+ (id)PostGestureWithAction:(NSString *)action_id UsrId:(NSString *)usr_id EventId:(NSString *)event_id Points:(NSArray *)points;

+ (id)GetGestureWithUsr:(NSString *)usr_id;

@end