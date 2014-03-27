//
//  WYGoalInMainViewModel.h
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYGoal.h"

@interface WYGoalInMainViewModel : NSObject

@property (strong, nonatomic) WYGoal *goal;

@property (strong, nonatomic) NSSet *commitLogIntValueSet;
@property (assign, nonatomic) BOOL hasCommitToday;


@end
