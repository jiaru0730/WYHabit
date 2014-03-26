//
//  FMDatabase+Addition.m
//  YNote
//
//  Created by Liu Deqing on 13-11-11.
//  Copyright (c) 2013年 Youdao. All rights reserved.
//

#import "FMDatabase+Addition.h"

@implementation FMDatabase (Addition)

- (BOOL)updateTable:(NSString *)tableName withParameterDictionary:(NSDictionary *)arguments
{
    NSArray *keys = [arguments allKeys];
    NSString *sub1 = [keys componentsJoinedByString:@", "];
    NSString *sub2 = [keys componentsJoinedByString:@", :"];
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@(%@) VALUES(:%@)", tableName, sub1, sub2];
    BOOL result = [self executeUpdate:sql withParameterDictionary:arguments];
    return result;
}

@end
