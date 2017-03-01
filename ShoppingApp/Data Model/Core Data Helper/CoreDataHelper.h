//
//  CoreDataHelper.h
//  ShoppingApp
//
//  Created by 黄文鸿 on 2017/1/20.
//  Copyright © 2017年 黄文鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject

@property (strong, nonatomic, readonly) NSPersistentStore *store;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *storeCoordinator;
@property (strong, nonatomic, readonly) NSManagedObjectModel *model;
@property (strong, nonatomic, readonly) NSManagedObjectContext *context;


//- (void)setUpCoreData;
- (void)saveContext;

+ (instancetype)sharedInstance;
@end
