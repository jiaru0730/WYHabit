//
//  WYDatabase.m
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYDatabase.h"

#import <FMDatabaseQueue.h>
#import "WYTableHandler.h"

#define kDefaultDatabasePath    @"UserDatabase.sqlite"

@interface WYDatabase()

@property (nonatomic, strong) FMDatabaseQueue *databaseQueue;

@property (nonatomic, strong) NSArray *tableHandlers;

@end

@implementation WYDatabase

- (id)init {
    self = [super init];
    if (self) {
        _open = NO;
    }
    return self;
}

- (BOOL)openAndInitDatabase {
    [self initDatabaseQueue];
    [self initTableHandlers];
    [self configTableHandlers];
    
    return YES;
}

- (void)initDatabaseQueue {
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSString *databasePath = [docsDir stringByAppendingPathComponent:kDefaultDatabasePath];
    self.databaseQueue = [FMDatabaseQueue databaseQueueWithPath:databasePath];
}

- (void)initTableHandlers {
    self.goalTableHandler = [[WYGoalTableHandler alloc] init];
    self.tableHandlers = @[self.goalTableHandler];
}

- (void)configTableHandlers {
    for (WYTableHandler *eachTableHandler in self.tableHandlers) {
        eachTableHandler.databaseQueue = self.databaseQueue;
        [eachTableHandler createTables];
    }
}
@end