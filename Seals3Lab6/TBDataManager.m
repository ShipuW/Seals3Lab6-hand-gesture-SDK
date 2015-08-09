//
// Created by Veight Zhou on 8/9/15.
// Copyright (c) 2015 Veight Zhou. All rights reserved.
//

#import "TBDataManager.h"
#import "MacroUtils.h"
#import "TBGesture.h"
#import <FMDB.h>
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

- (void)addCustomGesture:(TBGesture *)gesture completion:(void (^)(NSError *error))completion {
    if (!gesture.path) {
        NSError *error = [[NSError alloc] init];
        !completion ?: completion(error);
        return;
    }
    int id = [@([[NSDate date] timeIntervalSince1970]) intValue];
    NSError *error = nil;

    NSMutableArray *jsonArray = [NSMutableArray arrayWithCapacity:gesture.path.count];
    for (NSValue *value in gesture.path) {
        CGPoint point = [value CGPointValue];
        NSArray *arr = @[@(point.x), @(point.y)];
        [jsonArray addObject:arr];
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        !completion ?: completion(error);
        return;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];


    NSString *rawJsonString;
    if (gesture.rawPath.count) {
        NSData *rawJsonData = [NSJSONSerialization dataWithJSONObject:gesture.rawPath options:NSJSONWritingPrettyPrinted error:&error];
        if (error) {
            !completion ?: completion(error);
            return;
        }
        rawJsonString = [[NSString alloc] initWithData:rawJsonData encoding:NSUTF8StringEncoding];
    } else {
        rawJsonString = jsonString;
    }



    NSString *sql = @"INSERT INTO Gesture VALUES (?, ?, ?, ?, ?)";
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    NSError *rsError;
    if ([db open]) {
        BOOL rs = [db executeUpdate:sql, @(id), @"自定义手势", @(TBGestureTypeCustom), jsonString, rawJsonString];
        rsError = rs ? nil : [[NSError alloc] init];
        [db close];
    }
    !completion ?: completion(rsError);
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
                    @")";
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
        gesture.objectId = object[@"id"];
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
        [gestures addObject:gesture];
    }
    !completion ?: completion(gestures, nil);
}


@end