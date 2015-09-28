//
//  ContactDao.h
//  FMDBTest
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Database.h"
#import "AllInformation.h"

#define TABLE_NAME_PERSON @"PERSON"

@interface ContactDao : Database
{
    
}

// SELECT  
- (NSMutableArray *) findByCriteria:(NSString *)criteria;  
- (Contact *) findFirstByCriteria:(NSString *)criteria;  
- (NSInteger) countByCriteria:(NSString *)criteria;  

// INSERT  
- (void) saveContact:(Contact *)contact;  
- (void) saveContacts:(NSArray *)contacts;  

// UPDATE  
- (BOOL) updateAtIndex:(int)index withContact:(Contact *)contact;  

// DELETE  
- (BOOL) deleteAtIndex:(int)index;  
@end
