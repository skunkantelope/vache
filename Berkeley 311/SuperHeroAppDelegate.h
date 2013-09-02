//
//  SuperHeroAppDelegate.h
//  Berkeley 311
//
//  Created by Qian Wang on 9/2/13.
//  Copyright (c) 2013 Kelly Wang Imagery. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuperHeroAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
