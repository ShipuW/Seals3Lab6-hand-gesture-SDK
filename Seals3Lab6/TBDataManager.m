//
// Created by Veight Zhou on 8/9/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBDataManager.h"
#import "MacroUtils.h"
#import "TBGesture.h"
#import <FMDB.h>
#import "TBEvent.h"
#import "NSNumber+Utils.h"
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@interface TBDataManager ()

@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) FMDatabase *db;

@end

@implementation TBDataManager {

}

+ (instancetype)sharedManager {
    static TBDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TBDataManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)dbPath {
    if (!_dbPath) {
        NSString * doc = PATH_OF_DOCUMENT;
        NSString * path = [doc stringByAppendingPathComponent:@"tbg.sqlite"];
        _dbPath = path;
    }
    return _dbPath;
}

//- (FMDatabase *)db {
//    return _db;
//}


- (void)createDatabase {
    debugMethod();
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        // create it
        self.db = [FMDatabase databaseWithPath:self.dbPath];
        if ([self.db open]) {
            if ([self createGestureTable]) {
                debugLog(@"创建 GestureTable 成功");
            } else {
                debugLog(@"创建 GestureTable 失败");
            }

            if ([self createEventTable]) {
                debugLog(@"创建 EventTable 成功");
            } else {
                debugLog(@"创建 EventTable 失败");
            }

            if ([self createMapTable]) {
                debugLog(@"创建 MapTable 成功");
            } else {
                debugLog(@"创建 MapTable 失败");
            }

            [self.db close];
        } else {
            debugLog(@"error when open db");
        }
    } else {
        debugLog(@"数据库文件已存在");
    }
}

- (void)addCustomGesture:(TBGesture *)gesture completion:(void (^)(TBGesture *gesture, NSError *error))completion {
    if (!gesture.path) {
        NSError *error = [[NSError alloc] init];
        !completion ?: completion(nil, error);
        return;
    }
//    int objectId = [@([[NSDate date] timeIntervalSince1970]) intValue];

    double ts = [[NSDate date] timeIntervalSince1970];
    ts = fmod(ts, @(1000000).doubleValue);
    ts = ts * 1000;
    int objectId = @(ts).intValue;

    NSError *error = nil;
    
    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:gesture.path.count];
    for (NSValue *value in gesture.path) {
        CGPoint point = [value CGPointValue];
        NSArray *arr = @[@(point.x), @(point.y)];
        [jsonArray addObject:arr];
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        !completion ?: completion(nil, error);
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];


    NSString *rawJSONString;
    if (gesture.rawPath.count && (gesture.rawPath.count != gesture.path.count)) {
        NSMutableArray *rawJSONArray = [NSMutableArray arrayWithCapacity:gesture.rawPath.count];
        for (NSValue *value in gesture.rawPath) {
            CGPoint point = [value CGPointValue];
            NSArray *arr = @[@(point.x), @(point.y)];
            [rawJSONArray addObject:arr];
        }
        NSData *rawJsonData = [NSJSONSerialization dataWithJSONObject:rawJSONArray options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            !completion ?: completion(nil, error);
            return;
        }
        rawJSONString = [[NSString alloc] initWithData:rawJsonData encoding:NSUTF8StringEncoding];
    } else {
        rawJSONString = jsonString;
    }



    NSString *sql = @"INSERT INTO Gesture VALUES (?, ?, ?, ?, ?)";
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        NSError *rsError = nil;
        if ([db open]) {
            BOOL rs = [db executeUpdate:sql, @(objectId), @"自定义手势", @(TBGestureTypeCustom), jsonString, rawJSONString];
            rsError = rs ? nil : [[NSError alloc] init];
            [db close];
            if (rs) {
                gesture.objectId = [@(objectId) stringValue];
                !completion ?: completion(gesture, nil);
            } else {
                !completion ?: completion(nil, rsError);
            }
        } else {
            !completion ?: completion(nil, rsError);
        }
    }];
//    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
//    NSError *rsError;
//    if ([db open]) {
//        BOOL rs = [db executeUpdate:sql, @(objectId), @"自定义手势", @(TBGestureTypeCustom), jsonString, rawJSONString];
//        rsError = rs ? nil : [[NSError alloc] init];
//        [db close];
//    }
//    !completion ?: completion(rsError);
}

- (void)fetchGestureWithEvent:(TBEvent *)event completion:(void (^)(TBGesture *gesture))completion {
    NSString *sql = @"SELECT * FROM Map WHERE eventId = ?";
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:sql, event.objectId];
        if ([s next]) {
            TBGesture *gesture = [[TBGesture alloc] init];
            gesture.objectId = [s stringForColumn:@"gestureId"];
//
//            FMResultSet *gs = [db executeQuery:@"SELECT * FROM Gesture WHERE id = ?", gesture.objectId];
//            if ([gs next]) {
//
//                gesture.name = [gs stringForColumn:@"name"];
//                gesture.type = [@([gs intForColumn:@"type"]) integerValue];
//
//                NSString *path = [gs stringForColumn:@"path"];
//                gesture.path = [self CGPointsArrayFromPointsString:path];
//                NSString *rawPath = [gs stringForColumn:@"rawPath"];
//                gesture.rawPath = [self CGPointsArrayFromPointsString:rawPath];
//                [db close];
//                !completion ?: completion(gesture);
//            }
//        } else {
//            [db close];
//            !completion ?: completion(nil);
//        }
//        [db close];
//    } else {
//        !completion ?: completion(nil);
//    }
//}
//
//
//- (void)loadAllEventsFromDatabase:(void (^)(NSArray *results, NSError *error))completion {
//    NSString *sql = @"SELECT * FROM Event";
//    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
//    if ([db open]) {
//        FMResultSet *s = [db executeQuery:sql, event.objectId];
//        if ([s next]) {
//            TBGesture *gesture = [[TBGesture alloc] init];
//            gesture.objectId = [s stringForColumn:@"gestureId"];
            
            FMResultSet *gs = [db executeQuery:@"SELECT * FROM Gesture WHERE id = ?", gesture.objectId];
            if ([gs next]) {
                
                gesture.name = [gs stringForColumn:@"name"];
                gesture.type = [@([gs intForColumn:@"type"]) integerValue];
                
                NSString *path = [gs stringForColumn:@"path"];
                gesture.path = [self CGPointsArrayFromPointsString:path];
                NSString *rawPath = [gs stringForColumn:@"rawPath"];
                gesture.rawPath = [self CGPointsArrayFromPointsString:rawPath];
                [db close];
                !completion ?: completion(gesture);
                return;
            }
        } else {
            [db close];
            !completion ?: completion(nil);
            return;
        }
        [db close];
        !completion ?: completion(nil);
        return;
        
    } else {
        !completion ?: completion(nil);
        return;
    }
}

- (void)loadAllEventsFromDatabase:(void (^)(NSArray *results, NSError *error))completion {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
    [queue inDatabase:^(FMDatabase *db) {
        NSMutableArray *results = [NSMutableArray array];
        NSString *sql = @"SELECT * from Event";
        FMResultSet *s = [db executeQuery:sql];
        while ([s next]) {
            TBEvent *event = [[TBEvent alloc] init];
            event.objectId = [s stringForColumn:@"id"];
            event.name = [s stringForColumn:@"name"];
            event.enabled = [s intForColumn:@"enable"] == 1;
            event.canEditGesture = [s intForColumn:@"canEditGesture"] == 1;
            [results addObject:event];
        }
        !completion ?: completion(results, nil);
    }];
}

- (void)loadAllGesturesFromDatabase:(void (^)(NSArray *, NSError *))completion {
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    NSMutableArray *results = [NSMutableArray array];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:@"SELECT * FROM Gesture"];
        while ([s next]) {
            TBGesture *gesture = [[TBGesture alloc] init];
            gesture.objectId = [s stringForColumn:@"id"];
            NSString *path = [s stringForColumn:@"path"];
            gesture.path = [self CGPointsArrayFromPointsString:path];
            NSString *rawPath = [s stringForColumn:@"rawPath"];
            gesture.rawPath = [self CGPointsArrayFromPointsString:rawPath];
            [results addObject:gesture];
        }
        !completion ?: completion([results copy], nil);
        [db close];
    } else  {
        !completion ?: completion(nil, [[NSError alloc] init]);
    }
}
- (BOOL)createGestureTable {

    NSString *sql = @"CREATE TABLE IF NOT EXISTS "
                    @"Gesture ("
                    @"id integer primary key,"
                    @"name varchar(20),"
                    @"type integer,"
                    @"path text,"
                    @"rawPath text"
                    @")";
    return [self.db executeStatements:sql];
}

- (BOOL)createEventTable {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS "
                    @"Event ("
                    @"id integer primary key,"
                    @"enable integer,"
                    @"name varchar(20),"
                    @"canEditGesture integer"
                    @");"
                    @"INSERT INTO Event (enable, name, canEditGesture) values(1, '收藏', 1);"
                    @"INSERT INTO Event (enable, name, canEditGesture) values(1, '分享', 1);"
                    @"INSERT INTO Event (enable, name, canEditGesture) values(1, '测试事件1', 1);"
                    @"INSERT INTO Event (enable, name, canEditGesture) values(1, '测试事件2', 1);"
                    @"INSERT INTO Event (enable, name, canEditGesture) values(1, '测试事件3', 1);"
                    @"INSERT INTO Event (enable, name, canEditGesture) values(1, '测试事件4', 1);"
    ;
    return [self.db executeStatements:sql];
}

- (BOOL)createMapTable {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS "
                    @"Map ("
                    @"id integer primary key,"
                    @"gestureId varchar(20),"
                    @"eventId varchar(20)"
                    @")";
    return [self.db executeUpdate:sql];
}

- (void)deleteGesture:(TBGesture *)gesture completion:(void (^)(NSError *))completion {
    if (!gesture.objectId) {
        !completion ?: completion([[NSError alloc] init]);
        return;
    }
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        BOOL rs = [db executeUpdate:@"DELETE FROM Gesture WHERE id = ?", gesture.objectId];
        if (rs) {
            [db close];
            !completion ?: completion(nil);
            return;
        } else {
            [db close];
            !completion ?: completion([[NSError alloc] init]);
            return;
        }
//        [db close];
//        !completion ?: completion(nil);
//        return;
    } else {
        !completion ?: completion([[NSError alloc] init]);
        return;
    }
    
}

- (void)loadLocalGestureTemplets:(void (^)(NSArray *results, NSError *error))completion {
    NSData *templetsData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GestureTemplets" ofType:@"json"]];
    NSError *error = nil;
    NSArray *templets = [NSJSONSerialization JSONObjectWithData:templetsData options:NSJSONReadingMutableContainers error:&error];
    if (error || (templets.count <= 0)) {
        !completion ?: completion(nil, error);
    }
    NSMutableArray *gestures = [NSMutableArray array];
    for (NSDictionary *object in templets) {
        TBGesture *gesture = [[TBGesture alloc] init];
        gesture.objectId = [object[@"id"] stringValue];
        gesture.name = object[@"name"];
        gesture.type = TBGestureTypeCustom;
        
        NSArray *pointsArray = object[@"path"];
        NSMutableArray *path = [NSMutableArray array];
        for (NSArray *ponitArray in pointsArray) {
            if (ponitArray.count >= 2) {
                CGPoint point = CGPointMake([ponitArray[0] CGFloatValue], [ponitArray[1] CGFloatValue]);
                NSValue *value = [NSValue valueWithCGPoint:point];
                [path addObject:value];
            }
        }
        gesture.path = path;
        gesture.rawPath = path;
        [gestures addObject:gesture];
    }
    !completion ?: completion(gestures, nil);
}


- (void)mapEvent:(TBEvent *)event withGesture:(TBGesture *)gesture completion:(void (^)(NSError *))completion {
    if (!(event.objectId.length > 0 && event.objectId.length > 0)) {
        !completion ?: completion([[NSError alloc] init]);
        return;
    }

    NSString *queryCountSql = @"SELECT COUNT(*) FROM Map WHERE eventId = ?";
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet *s = [db executeQuery:queryCountSql, event.objectId];
        if ([s next]) {
            int totalCount = [s intForColumnIndex:0];
            if (totalCount > 0) {
                if ([db executeUpdate:@"UPDATE Map SET gestureId = ? WHERE eventId = ?", gesture.objectId, event.objectId]) {
                    debugLog(@"更新映射关系成功");
                    [db close];
                    !completion ?: completion(nil);
                    return;
                } else {
                    debugLog(@"更新映射关系失败");
                    !completion ?: completion([[NSError alloc] init]);
                }
            } else {
                if ([db executeUpdate:@"INSERT INTO Map VALUES (?, ?, ?)", @([event.objectId intValue]), gesture.objectId, event.objectId ]) {
                    debugLog(@"映射关系写入成功");
                    [db close];
                    !completion ?: completion(nil);
                    return;
                } else {
                    debugLog(@"映射关系写入失败");
                    [db close];
                    !completion ?: completion([[NSError alloc] init]);
                }
            }
        }

        [db close];
    }
    
    
//    NSString *sql = @"UPDATE Map SET gestureId = ? WHERE eventId = ?";
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
//    [queue inDatabase:^(FMDatabase *db) {
//        if ([db open]) {
//            BOOL rs = [db executeUpdateWithFormat:sql, @]
//        }
//    }];
}

- (NSString *)pointsStringFromCGPointsArray:(NSArray *)pointsArray {
    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:pointsArray.count];
    for (NSValue *value in pointsArray) {
        CGPoint point = [value CGPointValue];
        NSArray *arr = @[@(point.x), @(point.y)];
        [jsonArray addObject:arr];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSArray *)CGPointsArrayFromPointsString:(NSString *)pointsString {
    NSData *jsonData = [pointsString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *pointsArray = [NSMutableArray array];
    for (NSArray *p in jsonArray) {
        CGPoint point;
        point = CGPointMake([p[0] CGFloatValue], [p[1] CGFloatValue]);
        NSValue *value = [NSValue valueWithCGPoint:point];
        [pointsArray addObject:value];
    }
    return [pointsArray copy];
}

- (void)deleteGestureWithEvent:(TBEvent *)event completion:(void (^)(NSError *))completion {
    [self fetchGestureWithEvent:event completion:^(TBGesture *gesture) {
        if (gesture) {
            [self deleteGesture:gesture completion:^(NSError *error) {
                !completion ?: completion(error);
            }];
        } else {
            !completion ?: completion([[NSError alloc] init]);
        }
    }];
}

//- (NSArray *)CGPointsArrayFromPointsString:(NSString *)pointsString {
//    NSData *jsonData = [pointsString dataUsingEncoding:NSUTF8StringEncoding];
//    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    NSMutableArray *pointsArray = [NSMutableArray array];
//    for (NSArray *p in jsonArray) {
//        CGPoint point;
//        point = CGPointMake([p[0] CGFloatValue], [p[1] CGFloatValue]);
//        NSValue *value = [NSValue valueWithCGPoint:point];
//        [pointsArray addObject:value];
//    }
//    return [pointsArray copy];
//}
@end