//
//  WYDataManager.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYDataManager.h"
#import "WYConfigManager.h"
#import "WYGoalInMainViewModel.h"


@interface WYDataManager()

@end
@implementation WYDataManager

IMPLEMENT_SHARED_INSTANCE(WYDataManager)

- (void)initDatabase {
    self.database = [[WYDatabase alloc] init];
    [self.database openAndInitDatabase];
}

- (void)initManagers {
    WYGoal *goal = [[WYGoal alloc] init];
    goal.goalID = [[WYDataManager sharedInstance] generateUUID];
    goal.action = @"testAction";
    goal.startTime = [NSDate date];
    goal.endTime = [NSDate date];
    [[WYDataManager sharedInstance] updateGoal:goal];

    // WYConfigManager is not used by DataManager, previous lines are just test for DB operations.
    [[WYConfigManager sharedInstance] setConfigValue:goal.goalID forKey:kIDOfLiveGoalIndexKeyA];
    
    
}

- (NSString *)generateUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}


#pragma mark - Goals

- (WYGoal *)getGoalByID:(NSString *)goalID {
    return [self.database.goalTableHandler getGoalByID:goalID];
}

- (BOOL)updateGoal:(WYGoal *)goal {
    return [self.database.goalTableHandler updateGoal:goal];
}


#pragma mark - CommitLogs
- (WYCommitLog *)getCommitLogByGoalID:(NSString *)goalID year:(int)year month:(int)month day:(int)day {
    return [self.database.commitLogTableHandler getCommitLogBy:goalID year:year month:month day:day];
}

- (BOOL)updateCommitLog:(WYCommitLog *)commitLog {
    return [self.database.commitLogTableHandler updateCommitLog:commitLog];
}


#pragma mark - MainView
- (NSArray *)getMainViewLiveGoalViewModelList {
    NSMutableArray *liveGoalViewModelList = [NSMutableArray array];
    NSArray *liveGoalList = [self.database.goalTableHandler getLiveGoalList];
    for (WYGoal *eachLiveGoal in liveGoalList) {
        WYGoalInMainViewModel *goalInMainViewModel = [[WYGoalInMainViewModel alloc] init];
        goalInMainViewModel.goal = eachLiveGoal;
        goalInMainViewModel.commitLogIntValueSet = [self getCommitLogIntValueSetForGoal:eachLiveGoal.goalID];
        [liveGoalViewModelList addObject:goalInMainViewModel];
    }
    return liveGoalViewModelList;
}

- (NSSet *)getCommitLogIntValueSetForGoal:(NSString *)goalID {
    NSArray *commitLogList = [self.database.commitLogTableHandler getCommitLogListByGoalID:goalID];
    NSMutableSet *commitLogIntValueSet = [NSMutableSet set];
    for (WYCommitLog *eachCommitLog in commitLogList) {
        [commitLogIntValueSet addObject:@([eachCommitLog combinedIntValue])];
    }
    return commitLogIntValueSet;
}




@end
