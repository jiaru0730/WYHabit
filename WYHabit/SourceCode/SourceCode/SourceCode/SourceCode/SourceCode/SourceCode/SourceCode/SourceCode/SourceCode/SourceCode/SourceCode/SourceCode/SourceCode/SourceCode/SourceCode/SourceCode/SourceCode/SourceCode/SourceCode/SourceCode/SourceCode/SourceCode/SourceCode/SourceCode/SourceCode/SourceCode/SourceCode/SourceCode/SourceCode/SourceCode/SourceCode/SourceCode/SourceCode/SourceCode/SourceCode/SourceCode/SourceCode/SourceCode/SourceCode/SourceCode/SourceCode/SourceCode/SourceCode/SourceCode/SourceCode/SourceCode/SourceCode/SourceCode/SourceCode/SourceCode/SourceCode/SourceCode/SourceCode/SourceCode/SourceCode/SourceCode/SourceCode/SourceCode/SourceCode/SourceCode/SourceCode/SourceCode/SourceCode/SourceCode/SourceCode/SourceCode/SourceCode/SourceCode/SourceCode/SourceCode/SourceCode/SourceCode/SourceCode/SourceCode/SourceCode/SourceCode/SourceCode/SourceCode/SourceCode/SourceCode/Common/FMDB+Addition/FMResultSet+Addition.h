//
//  FMResultSet+Addition.h
//  YNote
//
//  Created by Liu Deqing on 13-11-18.
//  Copyright (c) 2013年 Youdao. All rights reserved.
//

#import "FMResultSet.h"

@interface FMResultSet (Addition)

// 返回ms表示的时间
- (NSDate *)dateByMSForColumn:(NSString *)columnName;
- (NSDate *)dateByMSForColumnIndex:(int)columnIdx;

@end
