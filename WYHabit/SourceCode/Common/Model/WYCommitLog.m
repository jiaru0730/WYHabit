//
//  WYCommitLog.m
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYCommitLog.h"

@implementation WYCommitLog

- (int)combinedIntValue {
    return self.year * 10000 + self.month * 100 + self.day;
}

@end
