//
//  CityUtility.m
//  City 311
//
//  Created by Qian Wang on 1/29/14.
//  Copyright (c) 2014 Kelly Kahuna Imagery. All rights reserved.
//

#import "CityUtility.h"
#import "CityFirstViewController.h"

@implementation CityUtility


+ (BOOL)sendJSON:(NSString *)string {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowStatusTab" object:nil];
    return true;
}

@end
