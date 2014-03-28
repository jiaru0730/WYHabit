//
//  WYCommitLog.m
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYCommitLog.h"

@implementation WYCommitLog

- (id) init {
    self = [super init];
    if (self) {
        _date = [[WYDate alloc] init];
    }
    return self;
}

- (void)setWYDate:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    self.date.year = (int)dateComponents.year;
    self.date.month = (int)dateComponents.month;
    self.date.day = (int)dateComponents.day;
}

- (int)combinedIntValue {
    return self.date.year * 10000 + self.date.month * 100 + self.date.day;
}

@end
