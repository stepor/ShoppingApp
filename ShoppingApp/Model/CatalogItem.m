//
//  CatalogItem.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/30.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "CatalogItem.h"

@implementation CatalogItem

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end
