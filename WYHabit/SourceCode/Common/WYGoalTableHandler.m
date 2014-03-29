//
//  WYGoalTableHandler.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYGoalTableHandler.h"

#import <FMDatabase.h>
#import "FMDatabase+Addition.h"

@interface WYGoalTableHandler()


@end

@implementation WYGoalTableHandler

- (BOOL)createTables {
    return [self createGoalsTable];
}

- (BOOL)createGoalsTable {
    __block BOOL createTableSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS Goals(goalID TEXT NO NULL, action TEXT, startTime INT8, endTime INT8, achiveTime INT8, totalDays INT, totalHours INT, Reserve1 TEXT, Reserve2 TEXT, Reserve3 TEXT, PRIMARY KEY(goalID));";
        createTableSucceed = [database executeUpdate:sql];
    }];
    return createTableSucceed;
}

- (BOOL)updateGoal:(WYGoal *)goal {
    __block BOOL updateGoalSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithCapacity:10];
        dataDict[@"goalID"] = goal.goalID;
        dataDict[@"action"] = goal.action;
        dataDict[@"startTime"] = @((goal.startTime == nil ? 0 : [goal.startTime timeIntervalSince1970]));
        dataDict[@"endTime"] = @((goal.endTime == nil ? 0 : [goal.endTime timeIntervalSince1970]));
        dataDict[@"achiveTime"] = @((goal.achiveTime == nil ? 0 : [goal.achiveTime timeIntervalSince1970]));
        dataDict[@"totalDays"] = @(goal.totalDays);
        dataDict[@"totalHours"] = @(goal.totalHours);
        updateGoalSucceed = [database updateTable:@"Goals" withParameterDictionary:dataDict];
    }];
    return updateGoalSucceed;
}

- (WYGoal *)getGoalByID:(NSString *)goalID {
    __block WYGoal *goal = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM Goals WHERE goalID=?", goalID];
        [resultSet next];
        goal = [self fillGoal:resultSet];
    }];
    return goal;
}

- (NSArray *)getAllGoalList {
    __block NSMutableArray *allGoalList = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM Goals ORDER BY startTime ASC;"];
        while ([resultSet next]) {
            WYGoal *eachGoal = [self fillGoal:resultSet];
            [allGoalList addObject:eachGoal];
        }
    }];
    return allGoalList;
}

- (NSArray *)getLiveGoalList {
    __block NSMutableArray *allGoalList = [NSMutableArray array];
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM Goals WHERE achiveTime = 0 ORDER BY startTime ASC;"];
        while ([resultSet next]) {
            WYGoal *eachGoal = [self fillGoal:resultSet];
            [allGoalList addObject:eachGoal];
        }
    }];
    return allGoalList;
}

- (BOOL)deleteGoalByID:(NSString *)goalID {
    __block BOOL deleteGoalSucceed = NO;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        deleteGoalSucceed = [database executeUpdate:@"DELETE FROM Goals WHERE goalID=?", goalID];
    }];
    return deleteGoalSucceed;
}

- (WYGoal *)fillGoal:(FMResultSet *)resultSet {
    WYGoal *goal = [[WYGoal alloc] init];
    goal.goalID = [resultSet stringForColumn:@"goalID"];
    goal.action = [resultSet stringForColumn:@"action"];
    goal.startTime = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"startTime"]];
    goal.endTime = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"endTime"]];
    goal.achiveTime = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"achiveTime"]];
    goal.totalDays = [resultSet intForColumn:@"totalDays"];
    goal.totalHours = [resultSet intForColumn:@"totalHours"];
    return goal;
}

@end
