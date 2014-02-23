//
//  WYDataManager.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WYConstants.h"

@interface WYDataManager : NSObject

DECLARE_SHARED_INSTANCE(WYDataManager)

- (NSString *)generateUUID;


@end
