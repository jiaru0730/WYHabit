//
//  WYTableHandler.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDatabaseQueue.h>

@interface WYTableHandler : NSObject

- (id)initWithDatabaseQueue:(FMDatabaseQueue *)databaseQueue;
- (BOOL)createTables;

@end
