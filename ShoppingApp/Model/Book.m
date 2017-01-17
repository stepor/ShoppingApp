//
//  Book.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/31.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "Book.h"

@implementation Book

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"titleSummary" : @"sub1", @"contentSummary" : @"sub2", @"imgUrlString" : @"img", @"readingQuantity" : @"reading", @"onlineShoppingAddress" : @"online", @"publishingTime" : @"bytime"};
}

@end
