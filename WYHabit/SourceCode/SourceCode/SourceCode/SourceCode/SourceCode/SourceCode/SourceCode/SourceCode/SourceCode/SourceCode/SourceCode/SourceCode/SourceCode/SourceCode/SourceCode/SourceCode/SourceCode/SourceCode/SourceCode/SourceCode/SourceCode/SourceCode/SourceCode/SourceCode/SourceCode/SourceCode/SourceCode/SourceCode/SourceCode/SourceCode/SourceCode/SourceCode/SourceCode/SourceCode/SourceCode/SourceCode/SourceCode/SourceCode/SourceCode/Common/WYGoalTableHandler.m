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
        NSString *sql = @"CREATE TABLE IF NOT EXISTS Goals(goalID TEXT NO NULL, action TEXT, startTime INT8, endTime INT8, achiveTime INT8, interval INT8, Reserve1 TEXT, Reserve2 TEXT, Reserve3 TEXT, PRIMARY KEY(goalID));";
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
        dataDict[@"startTime"] = @([goal.startTime timeIntervalSince1970]);
        dataDict[@"endTime"] = @([goal.endTime timeIntervalSince1970]);
        dataDict[@"achiveTime"] = @([goal.achiveTime timeIntervalSince1970]);
        dataDict[@"interval"] = @(goal.interval);
        updateGoalSucceed = [database updateTable:@"Goals" withParameterDictionary:dataDict];
    }];
    return updateGoalSucceed;
}

- (WYGoal *)getGoalByID:(NSString *)goalID {
    __block WYGoal *goal = nil;
    [self.databaseQueue inDatabase:^(FMDatabase *database) {
        FMResultSet *resultSet = [database executeQuery:@"SELECT * from Goals WHERE goalID=?", goalID];
        [resultSet next];
        goal = [self fillGoal:resultSet];
    }];
    return goal;
}

- (WYGoal *)fillGoal:(FMResultSet *)resultSet {
    WYGoal *goal = [[WYGoal alloc] init];
    goal.goalID = [resultSet stringForColumn:@"goalID"];
    goal.action = [resultSet stringForColumn:@"action"];
    goal.startTime = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"startTime"]];
    goal.endTime = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"endTime"]];
    goal.achiveTime = [NSDate dateWithTimeIntervalSince1970:[resultSet intForColumn:@"achiveTime"]];
    goal.interval = [resultSet intForColumn:@"interval"];
    return goal;
}

@end
