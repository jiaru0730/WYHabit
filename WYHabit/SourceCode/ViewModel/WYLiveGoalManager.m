//
//  WYLiveGoalManager.m
//  WYHabit
//
//  Created by Jia Ru on 2/25/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYLiveGoalManager.h"

#import "WYConfigManager.h"
#import "WYDataManager.h"

#define kMaxAmountOfLiveGoals   5

@interface WYLiveGoalManager()

@property (strong, nonatomic) NSArray *liveGoals;

@end

@implementation WYLiveGoalManager

IMPLEMENT_SHARED_INSTANCE(WYLiveGoalManager)

- (void)loadData {
    NSArray *goalIDConfigKeys = @[kIDOfLiveGoalIndexKeyA,
                                  kIDOfLiveGoalIndexKeyB,
                                  kIDOfLiveGoalIndexKeyC,
                                  kIDOfLiveGoalIndexKeyD,
                                  kIDOfLiveGoalIndexKeyE];
    NSMutableArray *mutableGoals = [NSMutableArray array];
    for (int i = 0; i < kMaxAmountOfLiveGoals; ++i) {
        NSString *goalID = [[WYConfigManager sharedInstance] configValueForKey:goalIDConfigKeys[i]];
        [mutableGoals addObject:[[WYDataManager sharedInstance] getGoalByID:goalID]];
    }
    _liveGoals = mutableGoals;
}

@end
