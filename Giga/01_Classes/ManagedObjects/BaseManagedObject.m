//
//  BaseManagedObject.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseManagedObject.h"
#import "NSManagedObject+MagicalRecord.h"

@implementation BaseManagedObject

- (NSString *)description
{
    return [Utils autoDescribe:self];
}

+ (id)insertNewObject
{
    return [self MR_createEntity];
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                         inManagedObjectContext:SharedDataCenter.managedObjectContext];
}

+ (id)insertFromJsonData:(NSDictionary*)jsonData jobType:(NSInteger)type
{
    //implement in subclass
    return nil;
}
+ (NSArray*)getItemsWithPredicate:(NSPredicate*)pre
                             sorts:(NSArray*)sorts
{
    return [self getItemsWithPredicate:pre sorts:sorts numberItem:0];
}

+ (NSArray*)getItemsWithPredicate:(NSPredicate*)pre
                            sorts:(NSArray*)sorts
                       numberItem:(NSInteger)numberItem
{
    NSManagedObjectContext *_managedObjectContext =  SharedDataCenter.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:pre];
    if (sorts) {
        fetchRequest.sortDescriptors = sorts;
    }
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    if (numberItem > 0) {
        fetchRequest.fetchLimit = numberItem;
    }
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return items;
}

+ (id)getOneItemWithPredicate:(NSPredicate*)pre

{
    return [self MR_findFirstWithPredicate:pre];
    
    NSManagedObjectContext *_managedObjectContext =  SharedDataCenter.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:pre];
    
    fetchRequest.fetchLimit = 1;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:self.entityName inManagedObjectContext:_managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return items.count > 0 ? items[0]: nil;
}

+ (NSString *)entityName
{
    return [[self class] description];
}


+ (NSMutableArray *)getAllObjects
{
    NSMutableArray *result = [NSMutableArray arrayWithArray:[self getItemsWithPredicate:nil sorts:nil]];
    return result;
}

+ (void)deleteAllObjects
{
    NSArray *items = [self getAllObjects];
    for (id obj in items) {
        [obj MR_deleteEntity];
//        [SharedDataCenter.managedObjectContext deleteObject:obj];
    }
    [SharedDataCenter saveContext];
}
@end
