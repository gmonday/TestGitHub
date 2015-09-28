//
//  Database.h
//  FMDBTest
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DB_NAME @"hekun.sqlite"

@class FMDatabase;
@interface Database : NSObject
{
    FMDatabase *db;
}
//@property (nonatomic, retain) FMDatabase *db;

- (NSString *)SQL:(NSString *)sql inTable:(NSString *)table;
@end
