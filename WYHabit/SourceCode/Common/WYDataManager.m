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
#import "WYGoalInDetailViewModel.h"
#import "WYDate.h"

@interface WYDataManager()

@end
@implementation WYDataManager

IMPLEMENT_SHARED_INSTANCE(WYDataManager)

- (void)initDatabase {
    self.database = [[WYDatabase alloc] init];
    [self.database openAndInitDatabase];
}

- (void)initManagers {
}

- (NSString *)generateUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}


#pragma mark - Goals

- (WYGoal *)addGoalNamed:(NSString *)actionNameOfGoal {
    WYGoal *newGoal = [[WYGoal alloc] init];
    newGoal.goalID = [self generateUUID];
    newGoal.action = actionNameOfGoal;
    newGoal.startTime = [NSDate date];
    
    BOOL addGoalSucceed = [self.database.goalTableHandler updateGoal:newGoal];
    if (addGoalSucceed) {
        return newGoal;
    } else {
        return nil;
    }
}

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

- (BOOL)deleteCommitLog:(WYCommitLog *)commitLogToDelete {
    return [self.database.commitLogTableHandler deleteCommitLog:commitLogToDelete];
}

- (BOOL)hasGoalCommittedToday:(NSString *)goalID  {
    WYDate *wyDate = [[WYDataManager sharedInstance] convertDateToWYDate:[NSDate date]];
    return [self hasGoal:goalID CommitOnDate:wyDate];
}

- (BOOL)hasGoal:(NSString *)gaolID CommitOnDate:(WYDate *)date {
    WYCommitLog *commitLog = [self.database.commitLogTableHandler getCommitLogBy:gaolID year:date.year month:date.month day:date.day];
    return (commitLog != nil);
}

#pragma mark - MainView
- (NSArray *)getMainViewLiveGoalViewModelList {
    NSMutableArray *liveGoalViewModelList = [NSMutableArray array];
    NSArray *liveGoalList = [self.database.goalTableHandler getLiveGoalList];
    for (WYGoal *eachLiveGoal in liveGoalList) {
        WYGoalInMainViewModel *goalInMainViewModel = [[WYGoalInMainViewModel alloc] init];
        goalInMainViewModel.goal = eachLiveGoal;
        goalInMainViewModel.commitLogIntValueSet = [self getCommitLogIntValueSetForGoal:eachLiveGoal.goalID];
        goalInMainViewModel.hasCommitToday = [self hasGoalCommittedToday:eachLiveGoal.goalID];
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

#pragma mark - AllDetailView

- (NSArray *)getAllGoalDetailViewModelList {
    NSMutableArray *allGoalDetailViewModelList = [NSMutableArray array];
    NSArray *allGoalList = [self.database.goalTableHandler getAllGoalList];
    for (WYGoal *eachGoal in allGoalList) {
        WYGoalInDetailViewModel *goalInDetailViewModel = [[WYGoalInDetailViewModel alloc] init];
        goalInDetailViewModel.goal = eachGoal;
        [allGoalDetailViewModelList addObject:goalInDetailViewModel];
    }
    return allGoalDetailViewModelList;
}

#pragma mark - Utils

- (WYDate *)convertDateToWYDate:(NSDate *)date {
    WYDate *wyDate = [[WYDate alloc] init];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    wyDate.year = dateComponents.year;
    wyDate.month = dateComponents.month;
    wyDate.day = dateComponents.day;
    return wyDate;
}


@end
