//
//  FMResultSet+Addition.m
//  YNote
//
//  Created by Liu Deqing on 13-11-18.
//  Copyright (c) 2013年 Youdao. All rights reserved.
//

#import "FMResultSet+Addition.h"

@implementation FMResultSet (Addition)

- (NSDate *)dateByMSForColumn:(NSString *)columnName
{
    return [self dateByMSForColumnIndex:[self columnIndexForName:columnName]];
}

- (NSDate *)dateByMSForColumnIndex:(int)columnIdx
{
    double value = [self doubleForColumnIndex:columnIdx];
    return [NSDate dateWithTimeIntervalSince1970:value / 1000];
}

@end
