//
//  Book.h
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/31.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
#import "PurchasedBook+CoreDataClass.h"

@interface Book : NSObject<MJKeyValue>

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *catalog;
@property (copy, nonatomic) NSString *tags;
@property (copy, nonatomic) NSString *titleSummary;
@property (copy, nonatomic) NSString *contentSummary;
@property (copy, nonatomic) NSString *imgUrlString;
@property (copy, nonatomic) NSString *readingQuantity;
@property (copy, nonatomic) NSString *onlineShoppingAddress;
@property (copy, nonatomic) NSString *publishingTime;
@property (copy, nonatomic) NSString *price;


- (void)duplicateAllPropertyToPurchasedBook:(PurchasedBook *)pBook;

@end
