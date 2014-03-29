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

const int kSecondsPerDay = 86400;

@interface WYDataManager()

@end
@implementation WYDataManager

IMPLEMENT_SHARED_INSTANCE(WYDataManager)

- (void)initDatabase {
    self.database = [[WYDatabase alloc] init];
    [self.database openAndInitDatabase];
}

- (void)initManagers {
    WYGoal *testGoal = [[WYGoal alloc] init];
    testGoal.goalID = [self generateUUID];
    testGoal.action = @"testGoal";
    NSDate *currentTime = [NSDate date];
    NSDateComponents *startTimeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentTime];
    startTimeComponents.day = startTimeComponents.day - 5;
    NSDate *fakeStartTime = [[NSCalendar currentCalendar] dateFromComponents:startTimeComponents];
    testGoal.startTime = fakeStartTime;
    
    WYCommitLog *commitLog = [[WYCommitLog alloc] init];
    commitLog.date.year = 2014;
    commitLog.date.month = 3;
    commitLog.date.day = 25;
    commitLog.goalID = testGoal.goalID;
    
    for (int i = 0; i < 1; ++i) {
        testGoal.totalDays++;
        [self updateGoal:testGoal];
        commitLog.totalDaysUntilNow = testGoal.totalDays;
        [self updateCommitLog:commitLog];
        commitLog.date.day++;
    }
    
    commitLog.goalID = @"TEST";
    [self updateCommitLog:commitLog];
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

- (NSArray *)getAllCommitLogList {
    return [self.database.commitLogTableHandler getAllCommitLogList];
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

- (NSArray *)getCommitLogListForGoal:(NSString *)goalID {
    NSArray *commitLogList = [self.database.commitLogTableHandler getCommitLogListByGoalID:goalID];
    return commitLogList;
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

#pragma mark - Timeline

- (int)calculateContinueSequenceForGoal:(NSString *)goalID {
    NSArray *commitLogList = [self getCommitLogListForGoal:goalID];
    int maxContinueSequence = 1;
    int tempContinueSequence = 1;
    for (int i = 1; i < commitLogList.count; ++i) {
        WYCommitLog *previousCommitLog = commitLogList[i - 1];
        WYCommitLog *afterCommitLog = commitLogList[i];
        if ([self isDate:afterCommitLog.date theNextDayOfDate:previousCommitLog.date]) {
            ++tempContinueSequence;
        } else {
            maxContinueSequence = MAX(maxContinueSequence, tempContinueSequence);
            tempContinueSequence = 1;
        }
    }
    maxContinueSequence = MAX(maxContinueSequence, tempContinueSequence);
    return maxContinueSequence;
}

- (float)calculateCommitPercentageForGoal:(NSString *)goalID {
    float goalCommitCount = (float)[self getCommitLogListForGoal:goalID].count;
    float allGoalCommitCount = (float)[self getAllCommitLogList].count;
    return goalCommitCount / allGoalCommitCount;
}

- (int)calculateCommitRankingForGoal:(NSString *)goalID {
    NSArray *goalListOrderByTotalCommitsDESC = [self.database.goalTableHandler getALlGoalListOrderByTotalCommitsDESC];
    int commitRanking = 0;
    int goalCountOnCurrentRank = 1;
    int totalCommitOnCurrentRank = INT16_MAX;
    for (WYGoal *eachGoal in goalListOrderByTotalCommitsDESC) {
        ++commitRanking;
        if (eachGoal.totalDays < totalCommitOnCurrentRank) {
            totalCommitOnCurrentRank = eachGoal.totalDays;
            goalCountOnCurrentRank = 1;
        } else if (eachGoal.totalDays == totalCommitOnCurrentRank) {
            ++goalCountOnCurrentRank;
        }
        
        if ([goalID isEqualToString:eachGoal.goalID]) {
            break;
        }
    }
    return commitRanking - goalCountOnCurrentRank + 1;
}

#pragma mark - Utils

- (WYDate *)convertDateToWYDate:(NSDate *)date {
    WYDate *wyDate = [[WYDate alloc] init];
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    wyDate.year = (int)dateComponents.year;
    wyDate.month = (int)dateComponents.month;
    wyDate.day = (int)dateComponents.day;
    return wyDate;
}

- (BOOL)isDate:(WYDate *)dateAfter theNextDayOfDate:(WYDate *)dateBefore {
    NSDate *nsDateAfter = [self getRoughNSDateByWYDate:dateAfter];
    NSDate *nsDateBefore = [self getRoughNSDateByWYDate:dateBefore];
    NSTimeInterval timeInterval = [nsDateAfter timeIntervalSinceDate:nsDateBefore];
    
    return (timeInterval < 2 * kSecondsPerDay);
}

- (NSDate *)getRoughNSDateByWYDate:(WYDate *)wyDate {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = wyDate.year;
    dateComponents.month = wyDate.month;
    dateComponents.day = wyDate.day;
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}


@end
