//
//  CityUtility.m
//  City 311
//
//  Created by Qian Wang on 1/29/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityUtility.h"

@interface CityUtility ()

+ (NSString *)createDirectory;
+ (BOOL)defaultDirecty;

@end

@implementation CityUtility

+ (BOOL)sendJSON:(NSData *)JSON andImage:(id)image {
    
    // if sending JSON fail, inform the user.
    BOOL success = FALSE;
    static int k = 1;
    if (k%3 == 0) {
        success = TRUE;
    }
    ++k;
    if (success) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Greetings from City Hall:" message:@"We've received your request. Our 311 team will resolve the issue as soon as we can." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alert show];
    } else {
        // save the data to phone. The directory shall match the key - value.
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Greetings from City Hall:" message:@"We didn't receive your request. It could be poor network connection. Please send it again soon!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes", nil];
        [alert show];
    }
   
    return success;
}

+ (BOOL)saveJSON:(NSData *)JSON andImage:(id)image atFilePath:(NSString *)path {
    NSString *currentDirectory;
    if (![CityUtility defaultDirecty]) {
        currentDirectory = [self createDirectory];
    } else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = paths[0];
        
        currentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    }
    
    currentDirectory = [currentDirectory stringByAppendingPathComponent:path];

    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:currentDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        NSLog(@"Not able to create city_311 sub directory: %@", [error localizedDescription]);
        return FALSE;
    }
    // transform JSON to Dictionary and save the dictionary.
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSON options:kNilOptions error:&error];
    if (error) {
        NSLog(@"Not able to transform JSON to foundation object %@", [error localizedDescription]);
        return FALSE;
    }
    
    [dictionary writeToFile:[currentDirectory stringByAppendingPathComponent:@"text"] atomically:YES];
    NSLog(@"dictionary %@", dictionary);
    if (image) {
        NSData *imageData = UIImagePNGRepresentation(image);
        [imageData writeToFile:[currentDirectory stringByAppendingPathComponent:@"image"] atomically:YES];
    }
    
    return YES;
}

+ (BOOL)loadFilesAtPath:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:path];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:[documentDirectory stringByAppendingPathComponent:@"text"]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [dictionary addEntriesFromDictionary:[userDefaults dictionaryRepresentation]];
    NSError *error;
    NSData *JSON = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&error];

    UIImage *image;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[documentDirectory stringByAppendingPathComponent:@"image"]]) {
        image = [UIImage imageWithContentsOfFile:[documentDirectory stringByAppendingPathComponent:@"image"]];
    }
    
    return [CityUtility sendJSON:JSON andImage:image];
}

+ (BOOL)saveRequest:(NSDictionary *)dictionary {
    NSString *currentDirectory;
    
    if (![CityUtility defaultDirecty]) {
        currentDirectory = [self createDirectory];
    } else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = paths[0];
        
        currentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    }
    NSMutableArray *array = [CityUtility userRecords];
    [array insertObject:dictionary atIndex:0];
    [array writeToFile:[currentDirectory stringByAppendingPathComponent:@"Record"] atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStatusTab" object:nil];
    return true;
}

+ (BOOL)saveUserRecords:(NSArray *)records {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"Record"];
    
    return [records writeToFile:documentDirectory atomically:YES];
}

+ (NSMutableArray *)userRecords {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
        
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"Record"];

    NSMutableArray *records;
    id object = [NSArray arrayWithContentsOfFile:documentDirectory];
    if (object) {
        records = [NSMutableArray arrayWithArray:(NSArray *)object];
    } else {
        records = [NSMutableArray array];
    }
    return records;
}
// check root directory
+ (BOOL)defaultDirecty {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:documentDirectory isDirectory:NULL];
}
// create root directory
+ (NSString *)createDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    
    NSError *error;
    [[NSFileManager defaultManager] createDirectoryAtPath:documentDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (error) {
        NSLog(@"Not able to create city_311 directory: %@", [error localizedDescription]);
    }
    
    return documentDirectory;
}

+ (BOOL)removeUserRequest:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = paths[0];
    
    documentDirectory = [documentDirectory stringByAppendingPathComponent:@"City_311"];
    documentDirectory = [documentDirectory stringByAppendingPathComponent:path];
    
    NSError *error;
    return [[NSFileManager defaultManager] removeItemAtPath:documentDirectory error:&error];
}
@end
