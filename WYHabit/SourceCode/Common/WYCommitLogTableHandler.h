//
//  WYCommitLogTableHandler.h
//  WYHabit
//
//  Created by Jia Ru on 3/27/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYTableHandler.h"
#import "WYCommitLog.h"

@interface WYCommitLogTableHandler : WYTableHandler

- (WYCommitLog *)getCommitLogBy:(NSString *)goalID year:(int)year month:(int) month day:(int)day;
- (BOOL)updateCommitLog:(WYCommitLog *)commitLog;

- (NSArray *)getCommitLogListByGoalID:(NSString *)goalID;

@end
