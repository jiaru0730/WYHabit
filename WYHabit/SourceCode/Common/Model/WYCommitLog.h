//
//  WYCommitLog.h
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYDate.h"

@interface WYCommitLog : NSObject

@property (copy, nonatomic) NSString *goalID;
@property (strong, nonatomic) WYDate *date;

@property (assign, nonatomic) int duration;
@property (assign, nonatomic) int totalDaysUntilNow;
@property (assign, nonatomic) int totalHoursUntilNow;


- (int)combinedIntValue;

@end
