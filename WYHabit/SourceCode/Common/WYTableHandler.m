//
//  WYTableHandler.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYTableHandler.h"


@interface WYTableHandler()

@property FMDatabaseQueue* databaseQueue;

@end

@implementation WYTableHandler

- (id)initWithDatabaseQueue:(FMDatabaseQueue *)databaseQueue {
    self = [super init];
    if (self) {
        _databaseQueue = databaseQueue;
    }
    return self;
}

- (BOOL)createTables {
    // do nothing here, no table needs creating.
    return YES;
}

@end
