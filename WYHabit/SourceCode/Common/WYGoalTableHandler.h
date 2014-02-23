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

@interface WYGoalTableHandler : WYTableHandler

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@end
