//
//  WYDatabase.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYGoalTableHandler.h"
#import "WYKeyValueTableHandler.h"

@interface WYDatabase : NSObject

@property (assign, nonatomic, getter = isOpen, setter = setOpen:) BOOL open;

@property (strong, nonatomic) WYKeyValueTableHandler *keyValueTableHandler;
@property (strong, nonatomic) WYGoalTableHandler *goalTableHandler;


- (BOOL)openAndInitDatabase;

@end
