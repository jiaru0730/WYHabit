//
//  WYDataManager.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYDataManager.h"
#import "WYConfigManager.h"


@interface WYDataManager()

@end
@implementation WYDataManager

IMPLEMENT_SHARED_INSTANCE(WYDataManager)

- (void)initDatabase {
    self.database = [[WYDatabase alloc] init];
    [self.database openAndInitDatabase];
}

- (void)initManagers {
//    WYGoal *goal = [[WYGoal alloc] init];
//    goal.action = @"testAction";
//    goal.goalID = [[WYDataManager sharedInstance] generateUUID];
//    goal.startTime = [NSDate date];
//    goal.endTime = [NSDate date];
//    goal.interval = 1;
//    [[WYDataManager sharedInstance] updateGoal:goal];
//    
//    [[WYConfigManager sharedInstance] setConfigValue:goal.goalID forKey:kIDOfLiveGoalIndexKeyA];
    
}

- (NSString *)generateUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}

- (WYGoal *)getGoalByID:(NSString *)goalID {
    return [self.database.goalTableHandler getGoalByID:goalID];
}

- (BOOL)updateGoal:(WYGoal *)goal {
    return [self.database.goalTableHandler updateGoal:goal];
}

@end
