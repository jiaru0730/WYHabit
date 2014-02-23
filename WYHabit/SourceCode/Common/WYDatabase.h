//
//  WYDatabase.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WYGoalTableHandler.h"

@interface WYDatabase : NSObject

@property (nonatomic, assign, getter = isOpen, setter = setOpen:) BOOL open;

@property (nonatomic, strong) WYGoalTableHandler *goalTableHandler;

- (BOOL)openAndInitDatabase;

@end
