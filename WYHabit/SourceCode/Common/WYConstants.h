//
//  WYConstants.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DECLARE_SHARED_INSTANCE(className)  \
    + (className *)sharedInstance;

#define IMPLEMENT_SHARED_INSTANCE(className)  \
    + (className *)sharedInstance \
    { \
        static dispatch_once_t onceToken; \
        static className *sharedInstance = nil; \
        dispatch_once(&onceToken, ^{ \
            sharedInstance = [[self alloc] init]; \
        }); \
        return sharedInstance; \
    }