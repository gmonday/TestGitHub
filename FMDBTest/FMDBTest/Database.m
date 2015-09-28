//
//  Database.m
//  FMDBTest
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "FMDatabase.h"

@implementation Database
//@synthesize db;
- (id)init{
    self = [super init];
    if (self) {
        BOOL success;
        //NSError *error;
       // NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDirectory, YES);
        NSString *documentDirectory = [path objectAtIndex:0];
        NSString *DBPath = [documentDirectory stringByAppendingPathComponent:DB_NAME];
//        success = [fm fileExistsAtPath:DBPath];
//        if (!success) {
//            NSString *defaultDBPath = [[[NSBundle mainBundle]bundlePath]stringByAppendingPathComponent:DB_NAME];
//            NSLog(@"%@",defaultDBPath);
//            success = [fm createDirectoryAtPath:DBPath withIntermediateDirectories:YES attributes:nil error:&error];
//            if (!success) {
//                NSLog(@"error :%@",error);
//            }
//            success = YES;
//        }
       // if (success) {
           // db = [[FMDatabase alloc]init];
            db = [FMDatabase databaseWithPath:DBPath];
            if ([db open]) {
                [db setShouldCacheStatements:YES];
                NSLog(@"Open success db !");
            }else {
                NSLog(@"Failed to open db!");
                success = NO;
            }
     //   }
    }
        
    return self;
}
- (NSString *)SQL:(NSString *)sql inTable:(NSString *)table{
    return [NSString stringWithFormat:sql,table];
}
- (void)dealloc{
    //[db close];
    //[db release];
    [super dealloc];
}
@end
