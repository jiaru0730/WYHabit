//
//  FMDatabase+Addition.h
//  YNote
//
//  Created by Liu Deqing on 13-11-11.
//  Copyright (c) 2013年 Youdao. All rights reserved.
//

#import "FMDatabase.h"

@interface FMDatabase (Addition)

// 更新数据表数据，自动拼接insert into tableName(col1, col2) values(:col1, :col2)
- (BOOL)updateTable:(NSString *)tableName withParameterDictionary:(NSDictionary *)arguments;

@end
