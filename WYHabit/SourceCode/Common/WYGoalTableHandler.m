//
//  WYGoalTableHandler.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYGoalTableHandler.h"

#import <FMDatabase.h>

@interface WYGoalTableHandler()


@end

@implementation WYGoalTableHandler

- (BOOL)createTables {
    return [self createGoalsTable];
}

- (BOOL)createGoalsTable {
    __block BOOL createTableSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS Goals(id TEXT NO NULL, action TEXT, startTime INT8, endTime INT8, achiveTime INT8, interval INT8, Reserve1 TEXT, Reserve2 TEXT, Reserve3 TEXT, PRIMARY KEY(id));";
        createTableSucceed = [database executeUpdate:sql];
    }];
    return createTableSucceed;
}

@end
