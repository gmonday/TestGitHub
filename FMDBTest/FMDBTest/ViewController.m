//
//  ViewController.m
//  FMDBTest
//
//  Created by  on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Database.h"
#import "ContactDao.h"
#import "AllInformation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(multiThread1:) userInfo:nil repeats:YES];  
//    [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(multiThread2:) userInfo:nil repeats:YES];  
//    [NSTimer scheduledTimerWithTimeInterval:0.17 target:self selector:@selector(didAction) userInfo:nil repeats:YES];
    [NSThread detachNewThreadSelector:@selector(multiThread1:) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(multiThread2:) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(multiThread3:) toTarget:self withObject:nil];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)didAction
{
    Contact *temp = [[Contact alloc]init];
    temp.index = -1;
    temp.person_id = 1234;
    ContactDao *tempContact = [[ContactDao alloc]init];
    [tempContact saveContact:temp];
    [temp release];
    
    Contact *findContact =  [tempContact findFirstByCriteria:@" where personid = 1234"];
    NSLog(@"%d",findContact.person_id);
    NSLog(@"%d",findContact.index);
    
    NSInteger count = [tempContact countByCriteria:@" where personid = 1234"];
    NSLog(@"%d",count);

}
- (void) multiThread1:(NSTimer *)timer  
{  
    BOOL running = YES;
    while (running) {
        Contact *temp = [[Contact alloc]init];
        temp.index = -1;
        temp.person_id = 1234;
        ContactDao *tempContact = [[ContactDao alloc]init];
        [tempContact saveContact:temp];
        [temp release];
        
        Contact *findContact =  [tempContact findFirstByCriteria:@" where personid = 1234"];
        NSLog(@"multiThread1 %d",findContact.person_id);
        NSLog(@"multiThread1 %d",findContact.index);
        
        NSInteger count = [tempContact countByCriteria:@" where personid = 1234"];
        NSLog(@"multiThread1 %d",count);
        
        NSArray *array = [tempContact findByCriteria:nil];
        NSLog(@" multiThread1 array count %d",[array count]);
        //usleep(1000);
    }

      
}  

- (void) multiThread2:(NSTimer *)timer  
{  
    BOOL running = YES;
    while (running) {
        Contact *temp = [[Contact alloc]init];
        temp.index = -1;
        temp.person_id = 1234;
        ContactDao *tempContact = [[ContactDao alloc]init];
        [tempContact saveContact:temp];
        [temp release];
        NSArray *array = [tempContact findByCriteria:nil];
        NSLog(@" multiThread2 array count %d",[array count]);
        Contact *findContact =  [tempContact findFirstByCriteria:@" where personid = 1234"];
        NSLog(@"multiThread2 %d",findContact.person_id);
        NSLog(@"multiThread2 %d",findContact.index);
        
        NSInteger count = [tempContact countByCriteria:@" where personid = 1234"];
        NSLog(@"multiThread2 %d",count);
        //usleep(1000);
    }
    

}  

- (void) multiThread3:(NSTimer *)timer  
{  
    BOOL running = YES;
    while (running) {
        Contact *temp = [[Contact alloc]init];
        temp.index = -1;
        temp.person_id = 1234;
        ContactDao *tempContact = [[ContactDao alloc]init];
        [tempContact saveContact:temp];
        [temp release];
        
        Contact *findContact =  [tempContact findFirstByCriteria:@" where personid = 1234"];
        NSLog(@"multiThread3 %d",findContact.person_id);
        NSLog(@"multiThread3 %d",findContact.index);
        NSArray *array = [tempContact findByCriteria:nil];
        NSLog(@" multiThread3 array count %d",[array count]);
        NSInteger count = [tempContact countByCriteria:@" where personid = 1234"];
        NSLog(@"multiThread3 %d",count);
        //usleep(1000);
    }
}  
 
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
