//
//  DataCenter.m
//  Giga
//
//  Created by CX MAC on 12/2/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "DataCenter.h"

#define kDATA_MODEL_NAME                @"GIGA"
#define kDATA_SQL_NAME                @"GIGA.sqlite"

@implementation DataCenter

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (DataCenter*)shared
{
    static DataCenter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataCenter alloc] init];
        [instance resetDatabaseIfNeed];
    });
    return instance;
}

- (void)resetDatabaseIfNeed
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *dbVersion = [user objectForKey:@"DBVERSION"];
    if (!dbVersion) {
        [self resetCoreData];
        [user setObject:DB_VERSION forKey:@"DBVERSION"];
        [user synchronize];
        [MagicalRecord setupCoreDataStackWithStoreNamed:kDATA_MODEL_NAME];
    }else{
        if (![dbVersion isEqualToString:DB_VERSION]) {//structure of core data changed
            [self resetCoreData];
            [user setObject:DB_VERSION forKey:@"DBVERSION"];
            [user synchronize];
            [MagicalRecord setupCoreDataStackWithStoreNamed:kDATA_MODEL_NAME];
        }
    }
}

- (void)resetCoreData
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [[self applicationDocumentsDirectory] path];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kDATA_MODEL_NAME]];
    BOOL dbexists = [fileManager fileExistsAtPath:writableDBPath];
    BOOL result = YES;
    if (!dbexists)
    {
        DLog(@"DB not exist");
        NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:kDATA_MODEL_NAME ofType:@"sqlite"];
        result = [fileManager removeItemAtPath:defaultDBPath error:nil];
        DLog(@"Default resetContent-%@", [NSNumber numberWithBool:result]);
    } else {
        result = [fileManager removeItemAtPath:writableDBPath error:nil];
        DLog(@"Writeable resetContent-%@", [NSNumber numberWithBool:result]);
    }
}

- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        if (contextDidSave) {
            DLog(@"You successfully saved your context.");
        } else if (error) {
            DLog(@"Error saving context: %@", error.description);
        }
    }];
}

//- (void)saveContext
//{
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            // Replace this implementation with code to handle the error appropriately.
//            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            //            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            //            abort();
//        }
//    }
//}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    return [NSManagedObjectContext MR_defaultContext];
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDATA_MODEL_NAME withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kDATA_SQL_NAME];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //        abort();
    }
    
    return _persistentStoreCoordinator;
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)applicationCacheDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}
@end
