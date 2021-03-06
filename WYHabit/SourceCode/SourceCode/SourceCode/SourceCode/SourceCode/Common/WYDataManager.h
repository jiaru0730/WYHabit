//  WYDataManager.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYConstants.h"
#import "WYDatabase.h"
#import "WYGoal.h"

@interface WYDataManager : NSObject

DECLARE_SHARED_INSTANCE(WYDataManager)

@property (strong, nonatomic) WYDatabase *database;

- (NSString *)generateUUID;
- (void)initDatabase;
- (void)initManagers;

#pragma mark - Goals

- (WYGoal *)getGoalByID:(NSString *)goalID;
- (BOOL)updateGoal:(WYGoal *)goal;

@end
