//
//  WYKeyValueTableHandler.h
//  WYHabit
//
//  Created by Jia Ru on 2/24/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYTableHandler.h"

@interface WYKeyValueTableHandler : WYTableHandler

- (BOOL)setConfigValue:(NSString *)value forKey:(NSString *)key;
- (NSString *)configValueForKey:(NSString *)key;

@end
