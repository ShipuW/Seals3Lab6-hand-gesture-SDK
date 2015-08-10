//
//  PostConnection.m
//  Seals3Lab6
//
//  Created by 王士溥 on 15/8/9.
//  Copyright (c) 2015年 Veight Zhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostConnection.h"

@implementation PostConnection

+ (id)PostGestureWithAction:(NSString *)action_id UsrId:(NSString *)usr_id EventId:(NSString *)event_id Points:(NSArray *)points
{
    NSURL *url = [NSURL URLWithString:@"10.2.43.153:8080/JsonProject/GSAction?action_flag=mapAll"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:action_id forKey:@"action_id"];
    [dictionary setValue:usr_id forKey:@"usrId"];
    [dictionary setValue:event_id forKey:@"eventName"];
    [dictionary setValue:points forKey:@"points"];
    NSMutableData* data = [[NSMutableData alloc]init];
    NSKeyedArchiver* archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:dictionary forKey:@"gestureData"];
    [archiver finishEncoding];
    
    
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"http返回数据：%@",str1);
    return 0;

}

+ (id)GetGestureWithUsr:(NSString *)usr_id{
    NSURL *url = [NSURL URLWithString:@"http://api.hudong.com/iphonexml.do"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = @"type=focus-c";//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str1);
    
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:@"Gesture.json"];     /* Now try to deserialize the JSON object into a dictionary */
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            if ([jsonObject isKindOfClass:[NSDictionary class]]){
                NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
            } else if ([jsonObject isKindOfClass:[NSArray class]]){
                NSArray *deserializedArray = (NSArray *)jsonObject;
                NSLog(@"Dersialized JSON Array = %@", deserializedArray);
            } else {
                NSLog(@"An error happened while deserializing the JSON data.");
            }
        }
   // [jsonData release];
    
    
    return 0;

}

@end