//
//  DBManager.m
//  SQliteTestingFeed
//
//  Created by MTCHNDT on 13/09/16.
//  Copyright © 2016 MTPL. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;
@implementation DBManager

+(DBManager*)getSharedInstance
{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    arrFieldList = [[NSArray alloc]initWithObjects:@"Ahmadabad",@"அகமதாபாத்",@"Humidity: 75 %",@"Cloudy",@"26",@"http://imgmobile.dinamalar.com/weatherIcon/64/26.png",@"26",@"31", nil];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"test.sqlite"]];
    
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            /*
             
             cityname: "Ahmadabad",
             citynameta: "அகமதாபாத்",
             weathertype: "Humidity: 75 %",
             status: "Cloudy",
             imagenumber: "26",
             imagename: "http://imgmobile.dinamalar.com/weatherIcon/64/26.png",
             mintemp: "26",
             mintemp: "31"

             
             */
            
            
            
            char *errMsg;
            const char *sql_stmt ="create table if not exists feedDetail (cityname text,citynameta text,weathertype text,status text,imagenumber text,imagename text,mintemp text,maxtemp text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

//- (BOOL) saveData:(NSString*)registerNumber name:(NSString*)name
//       department:(NSString*)department year:(NSString*)year;
//{
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        NSString *insertSQL = [NSString stringWithFormat:@"insert into                               feedDetail (regno,name, department, year) values (\"%ld\",\"%@\", \"%@\", \"%@\")",(long)[registerNumber integerValue],name, department, year];
//        const char *insert_stmt = [insertSQL UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//        sqlite3_reset(statement);
//    }
//    return NO;
//}

// Working Fine...
//-(void)InsertRecords:(NSMutableDictionary *)dict
//{
//    
//    NSMutableString *str = [NSMutableString stringWithFormat:@"Insert into feedDetail ("];
//    
//    for (int i = 0; i<[[dict allKeys] count]-1; i++)
//    {
//        if (i>0)
//        {
//            [str appendFormat:@"%@",[[dict allKeys] objectAtIndex:i]];
//        }
//        else
//        {
//            [str appendFormat:@"%@,",[[dict allKeys] objectAtIndex:i]];
//        }
//    }
//    [str appendFormat:@")values ("];
//    for (int i = 0; i<[[dict allKeys] count]-1; i++)
//    {
//        if (i>0)
//        {
//            [str appendFormat:@"\"%@\"",[dict valueForKey:[[dict allKeys] objectAtIndex:i]]];
//        }
//        else
//        {
//            [str appendFormat:@"\"%@\",",[dict valueForKey:[[dict allKeys] objectAtIndex:i]]];
//        }
//        
//    }
//    
//    [str appendFormat:@");"];
//    //    insert into feedDetail (title, social_link, items ) values("India1","google.co.in","chennai");
//    
//    NSLog(@"qry : %@",str);
//    
//    const char *dbpath = [databasePath UTF8String];
//    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
//    {
//        const char *insert_stmt = [str UTF8String];
//        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
//        if (sqlite3_step(statement) == SQLITE_DONE)
//        {
//            NSLog(@"Saved");
//        }
//        else
//        {
//            NSLog(@"is Not Save");
//        }
//        sqlite3_reset(statement);
//    }
//}

-(void)InsertRecords:(NSMutableDictionary *)dict
{
    NSDictionary *dictWeather = [dict valueForKey:@"weather"];
    
    NSArray *arrAllkeys = [dictWeather allKeys];
    
    
    for (int i=0; i<arrAllkeys.count; i++)
    {
        NSDictionary *dictSub1 = [dictWeather valueForKey:[NSString stringWithString:arrAllkeys[i]]];
        
        NSArray *arrSubItems = [dictSub1 valueForKey:@"item"];
        for (int j=0; j<arrSubItems.count; j++)
        {
             NSDictionary *dictInnerSub = arrSubItems[j];
            
            NSMutableString *str = [NSMutableString stringWithFormat:@"Insert into feedDetail ("];
            
            NSInteger nCount = [[dictInnerSub allKeys] count];
            
            for (int i = 0; i<nCount; i++)
            {
                if (i<nCount-1)
                {
                    [str appendFormat:@"%@,",[[dictInnerSub allKeys] objectAtIndex:i]];
                }
                else
                {
                    [str appendFormat:@"%@",[[dictInnerSub allKeys] objectAtIndex:i]];
                }
            }
            [str appendFormat:@")values ("];
            
            for (int i = 0; i<nCount; i++)
            {
                if (i<nCount-1)
                {
                    [str appendFormat:@"\"%@\",",[dictInnerSub valueForKey:[[dictInnerSub allKeys] objectAtIndex:i]]];
                }
                else
                {
                    [str appendFormat:@"\"%@\"",[dictInnerSub valueForKey:[[dictInnerSub allKeys] objectAtIndex:i]]];
                }
            }
            
            
            [str appendFormat:@");"];
            //    insert into feedDetail (title, social_link, items ) values("India1","google.co.in","chennai");
            
            NSLog(@"qry : %@",str);
            
            const char *dbpath = [databasePath UTF8String];
            if (sqlite3_open(dbpath, &database) == SQLITE_OK)
            {
                const char *insert_stmt = [str UTF8String];
                sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Saved");
                    NSLog(@"An error occurred: %s", sqlite3_errmsg(database));

                }
                else
                {
                    NSLog(@"An error occurred: %s", sqlite3_errmsg(database));
                    NSLog(@"is Not Save");
                }
                sqlite3_reset(statement);
            }
        }
    }
}



@end
