//
//  WYKeyValueTableHandler.m
//  WYHabit
//
//  Created by Jia Ru on 2/24/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYKeyValueTableHandler.h"

#import <FMDatabase.h>
#import "FMDatabase+Addition.h"

#define kKeyValueConfigTableName  @"KVConfigTable"

#define kKeyValueConfigTrue         @"1"
#define kKeyValueConfigFalse        @"0"

@implementation WYKeyValueTableHandler

- (BOOL)createTables {
    return [self createKeyValueTable];
}

- (BOOL)createKeyValueTable {
    __block BOOL createTableSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (key TEXT NOT NULL PRIMARY KEY, value TEXT DEFAULT NULL);", kKeyValueConfigTableName];
        createTableSucceed = [database executeUpdate:sql];
    }];
    return createTableSucceed;
}

- (BOOL)setConfigValue:(NSString *)value forKey:(NSString *)key {
    __block BOOL updateKeyValueSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:2];
        dataDict[@"key"] = key;
        dataDict[@"value"] = value;
        updateKeyValueSucceed = [database updateTable:kKeyValueConfigTableName withParameterDictionary:dataDict];
    }];
    return updateKeyValueSucceed;
}

- (NSString *)configValueForKey:(NSString *)key {
    __block NSString *value = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:[NSString stringWithFormat:@"SELECT value FROM %@ WHERE key=?", kKeyValueConfigTableName], key];
        [resultSet next];
        value = [resultSet stringForColumn:@"value"];
    }];
    return value;
}

@end
