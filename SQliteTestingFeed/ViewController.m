//
//  ViewController.m
//  SQliteTestingFeed
//
//  Created by MTCHNDT on 13/09/16.
//  Copyright © 2016 MTPL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    //Get file on a background thread to stop GUI locking up
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://rss.dinamalar.com/json/iphone2_1/Weather_cc.asp"]];    //Could obviously be a .json file too
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    });
    
}


//****************************************
//****************************************
//********** JSON FILE RECEIVED **********
//****************************************
//****************************************
- (void)fetchedData:(NSData *)responseData
{
    //Get the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
//    NSArray *arrItem = [json valueForKey:@"items"];

    [[DBManager getSharedInstance]InsertRecords:[json mutableCopy]];
    
   
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
