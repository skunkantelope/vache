//
//  CityUtility.h
//  City 311
//
//  Created by Qian Wang on 1/29/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

@interface CityUtility : NSObject

+ (NSMutableArray *)userRecords; // An array of dictionaries. One dictionary stores the information, sending success/failure status, and file location.
+ (BOOL)saveUserRecords:(NSArray *)records; // save user editing.
+ (BOOL)sendJSON:(NSData *)JSON andImage:(id)image;
+ (BOOL)saveRequest:(NSDictionary *)dictionary; 
+ (BOOL)saveJSON:(NSData *)JSON andImage:(id)image atFilePath:(NSString *)path;
+ (BOOL)loadFilesAtPath:(NSString *)path; // send again

@end
