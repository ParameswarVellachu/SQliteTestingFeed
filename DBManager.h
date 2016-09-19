//
//  DBManager.h
//  SQliteTestingFeed
//
//  Created by MTCHNDT on 13/09/16.
//  Copyright © 2016 MTPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
    sqlite3 *contactDB;
    
    NSArray *arrFieldList;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
      department:(NSString*)department year:(NSString*)year;
-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;

-(void)InsertRecords:(NSMutableDictionary *)dict;
@end