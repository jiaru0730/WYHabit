//
//  WYConfigManager.h
//  WYHabit
//
//  Created by Jia Ru on 2/24/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYConstants.h"

#define kIDOfLiveGoalIndexKeyA @"kIDOfLiveGoalIndexKeyA"
#define kIDOfLiveGoalIndexKeyB @"kIDOfLiveGoalIndexKeyB"
#define kIDOfLiveGoalIndexKeyC @"kIDOfLiveGoalIndexKeyC"
#define kIDOfLiveGoalIndexKeyD @"kIDOfLiveGoalIndexKeyD"
#define kIDOfLiveGoalIndexKeyE @"kIDOfLiveGoalIndexKeyE"

@interface WYConfigManager : NSObject

DECLARE_SHARED_INSTANCE(WYConfigManager)

- (BOOL)setConfigValue:(NSString *)value forKey:(NSString *)key;
- (NSString *)configValueForKey:(NSString *)key;

@end
