//
//  WYConfigManager.m
//  WYHabit
//
//  Created by Jia Ru on 2/24/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYConfigManager.h"

#import "WYDataManager.h"
#import "WYKeyValueTableHandler.h"

@interface WYConfigManager()

@property (strong, nonatomic) WYKeyValueTableHandler *keyValueTableHandler;

@end

@implementation WYConfigManager

IMPLEMENT_SHARED_INSTANCE(WYConfigManager)

- (BOOL)setConfigValue:(NSString *)value forKey:(NSString *)key {
    return [[self getKeyValueTableHandler] setConfigValue:value forKey:key];
}

- (NSString *)configValueForKey:(NSString *)key {
    return [[self getKeyValueTableHandler] configValueForKey:key];
}



- (WYKeyValueTableHandler *)getKeyValueTableHandler {
    if (nil == self.keyValueTableHandler) {
        self.keyValueTableHandler = [WYDataManager sharedInstance].database.keyValueTableHandler;
    }
    return self.keyValueTableHandler;
}

@end
