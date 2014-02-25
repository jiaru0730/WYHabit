//
//  WYLiveGoalManager.h
//  WYHabit
//
//  Created by Jia Ru on 2/25/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYConstants.h"

@interface WYLiveGoalManager : NSObject

DECLARE_SHARED_INSTANCE(WYLiveGoalManager)

- (void)loadData;

@end
