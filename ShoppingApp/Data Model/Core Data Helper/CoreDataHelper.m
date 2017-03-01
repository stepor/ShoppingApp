//
//  CoreDataHelper.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2017/1/20.
//  Copyright © 2017年 黄文鸿. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

static CoreDataHelper *instanc = nil;

#pragma mark - FILES
NSString *storeFileName = @"ShoppingApp.sqlite";

#pragma mark - PATHS
- (NSString *)documentDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
}

- (NSURL *)applicationStoreDirectory {
    NSURL *storeUrl = [[NSURL fileURLWithPath:[self documentDirectory]] URLByAppendingPathComponent:@"Stores"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:storeUrl.path]) {
        NSError *error = nil;
        if(![fileManager createDirectoryAtURL:storeUrl withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"Fail to create store directory: %@", error);
        }
    }
    
    return storeUrl;
}

- (NSURL *)storeUrl {
    return [[self applicationStoreDirectory] URLByAppendingPathComponent:storeFileName];
}


#pragma mark - SETUP
- (instancetype)initPrivate {
    self = [super init];
    if(self) {
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _context.persistentStoreCoordinator = _storeCoordinator;
        
    }
    return self;
}

- (void)loadStore {
    if(_store) {
        return;
    }
    
    NSError *error = nil;
    //NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES, NSInferMappingModelAutomaticallyOption : @NO};
    _store = [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self storeUrl] options:nil error:&error];
    if(!_store) {
        NSLog(@"Failed to addStore : %@", error);
        abort();
    }
}

- (void)setUpCoreData {
    [self loadStore];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanc = [[self alloc] initPrivate];
        [instanc setUpCoreData];
    });
    return instanc;
}

#pragma mark - SAVING
- (void)saveContext {
    if([_context hasChanges]) {
        NSError *error = nil;
        if([_context save:&error]) {
            NSLog(@"Context saves change successfully!");
        } else {
            NSLog(@"Failed to save change : %@", error);
        }
    } else {
        NSLog(@"Context has no change");
    }
}

#pragma mark - Singleton Operation
- (instancetype)init {
    return instanc;
}

- (instancetype)copy {
    return instanc;
}

@end
