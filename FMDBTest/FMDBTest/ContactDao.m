//
//  ContactDao.m
//  FMDBTest
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ContactDao.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@implementation ContactDao

- (id)init{
    self = [super init];
    if (self) {
        if (![db tableExists:TABLE_NAME_PERSON]) {
            NSString *sql = [self SQL:@"CREATE TABLE IF NOT EXISTS '%@' ('index' INTEGER PRIMARY KEY AUTOINCREMENT, 'personid' INTEGER);" inTable:TABLE_NAME_PERSON];
            NSLog(@"%@",sql);
            BOOL result = [db executeUpdate:sql];
            if (result) {
                //NSString *SQL2 = [self SQL:@"CREATE UNIQUE INDEX IF NOT EXISTS 'userid_friend' on %@ ('userid', 'friendid')" inTable:TABLE_NAME_PERSON];
                //[db executeUpdate:SQL2];
                //NSString * SQL3 = [self SQL:@"CREATE INDEX IF NOT EXISTS 'lastintouchtime' on %@ ('lastintouchtime')" inTable:TABLE_NAME_PERSON];  
                //[db executeUpdate:SQL3];  
                NSLog(@"create success");
            }
        }
        NSLog(@"db exists!");
        [db close];
    }
    return self;
}
- (NSMutableArray *)findByCriteria:(NSString *)criteria{
    NSMutableArray *reslute = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSMutableString *sql = [NSMutableString stringWithString:[self SQL:@"SELECT * FROM %@" inTable:TABLE_NAME_PERSON]];
    if (criteria != nil) {
        [sql appendString:criteria];
    }
    [db open];
    FMResultSet *rs = [db executeQuery:sql];
    
    while ([rs next]) {
        Contact *ct = [[Contact alloc]init];
        ct.index = [rs intForColumn:@"index"];
        [reslute addObject:ct];
        [ct release];
    }
    [rs close];
    [db close];
    return reslute;
}
- (Contact *)findFirstByCriteria:(NSString *)criteria{
    NSMutableArray *result = [[[NSMutableArray alloc]initWithCapacity:0]autorelease];
    NSMutableString *sql = [NSMutableString stringWithString:[self SQL:@"SELECT * FROM %@" inTable:TABLE_NAME_PERSON]];
    if (criteria !=nil) {
        [sql appendString:criteria];
    }
    NSLog(@"sql %@",sql);
    [db open];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        Contact *ct = [[Contact alloc]init];
        ct.index = [rs intForColumnIndex:0];
        ct.person_id = [rs intForColumnIndex:1];
        [result addObject:ct];
        [ct release];
    }
    [rs close];
    [db close];
    if ([result count]>0) {
        return [result objectAtIndex:0];
    }else {
        return nil;
    }
}
- (NSInteger)countByCriteria:(NSString *)criteria{
    NSInteger count = 0;
    NSMutableString *sql = [NSMutableString stringWithString:[self SQL:@"SELECT COUNT(*) FROM %@ " inTable:TABLE_NAME_PERSON]];
    if (criteria != nil) {
        [sql appendString:criteria];
    }
     NSLog(@"sql %@",sql);
    [db open];
    FMResultSet *rs = [db executeQuery:sql];
    while ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    [rs close];
    [db close];
    return count;
}
- (void)saveContact:(Contact *)contact{
    NSInteger index = contact.index;
    if (index >= 0) {
        [self updateAtIndex:index withContact:contact];
    }else {
        NSNumber *personID = [[NSNumber alloc]initWithInt:contact.person_id];
        
        [db open];
        [db beginTransaction];
        NSString * insertSql = [self SQL:@"INSERT OR IGNORE INTO %@ ('personid') VALUES (?)" inTable:TABLE_NAME_PERSON];  
        [db executeUpdate:insertSql,personID];
        NSInteger lastInsertId = [db lastInsertRowId];
        NSString *updateSql = [self SQL:@"UPDATE %@ SET personid=? WHERE 'index'=?" inTable:TABLE_NAME_PERSON];
        [db executeUpdate:updateSql,personID,[NSNumber numberWithInt:lastInsertId]];
        [db commit];
        [db close];
        [personID release];
    }
}
- (void)saveContacts:(NSArray *)contacts{
    NSMutableArray *values = [[NSMutableArray alloc]init];
    for (Contact *contact in contacts) {
        NSNumber *personID = [[NSNumber alloc]initWithInt:contact.person_id];
        NSMutableString *value = [[NSMutableString alloc]initWithFormat:@"(%@)",personID];
        NSLog(@"%@",value);
        [values addObject:value];
        [value release];
        [personID release];
    }
    if ([values count]>0) {
        [db open];
        [db beginTransaction];
        NSString *insertSql = [self SQL:@"INSERT OR IGNORE INTO %@ ('personid') VALUES %@ " inTable:TABLE_NAME_PERSON];
        NSLog(@"%@",insertSql);
        NSString *compinentStr = [values componentsJoinedByString:@","];
        NSLog(@"%@",compinentStr);
        NSString *sqliteStr = [NSString stringWithFormat:@"%@%@",insertSql,[values componentsJoinedByString:@","]];
        NSLog(@"%@",sqliteStr);
        [db executeUpdate:sqliteStr];
        //[db executeUpdate:insertSql,[values componentsJoinedByString:@","]];
        [db commit];
        [db close];
    }
    [values release];
}
- (BOOL)updateAtIndex:(int)index withContact:(Contact *)contact{
    BOOL success = YES;
    
    NSNumber *indexID = [[NSNumber alloc]initWithInt:contact.index];
    NSNumber *personID = [[NSNumber alloc]initWithInt:contact.person_id];
    
    [db open];
    [db executeUpdate:[self SQL:@"UPDATE %@ SET personid = ? WHERE 'index' = ?" inTable:TABLE_NAME_PERSON],personID,indexID];
    [db close];
    [indexID release];
    [personID release];
    if ([db hadError]) {
        NSLog(@"Err %d: %@",[db lastErrorCode],[db lastErrorMessage]);
        success = NO;
    }
    return success;
    
}
- (BOOL)deleteAtIndex:(int)index{
    BOOL success = YES;
    [db open];
    [db executeUpdate:[self SQL:@"DELETE FROM %@ WHERE 'index' = ? " inTable:TABLE_NAME_PERSON],[NSNumber numberWithInt:index]];
    [db close];
    if ([db hadError]) {
        NSLog(@"Err %d: %@",[db lastErrorCode],[db lastErrorMessage]);
        success = NO;
    }else {
        [db clearCachedStatements];
    }
    return success;
}
- (void)dealloc{
    
    //[db close];
    [super dealloc];
}
@end
