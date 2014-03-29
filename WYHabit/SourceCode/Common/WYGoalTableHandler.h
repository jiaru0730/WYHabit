//
//  WYGoalTableHandler.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabaseQueue.h>
#import "WYTableHandler.h"
#import "WYGoal.h"

@interface WYGoalTableHandler : WYTableHandler

- (BOOL)updateGoal:(WYGoal *)goal;
- (WYGoal *)getGoalByID:(NSString *)goalID;

- (NSArray *)getAllGoalList;
- (NSArray *)getLiveGoalList;

- (BOOL)deleteGoalByID:(NSString *)goalID;

@end
