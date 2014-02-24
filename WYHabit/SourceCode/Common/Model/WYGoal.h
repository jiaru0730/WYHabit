//
//  WYGoal.h
//  WYHabit
//
//  Created by Jia Ru on 2/24/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYGoal : NSObject

@property (copy, nonatomic) NSString *goalID;
@property (copy, nonatomic) NSString *action;
@property (assign, nonatomic) NSDate *startTime;
@property (assign, nonatomic) NSDate *endTime;
@property (assign, nonatomic) NSDate *achiveTime;
@property (assign, nonatomic) NSDate *interval;

@end
