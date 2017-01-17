//
//  CatalogItem.h
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/30.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

@interface CatalogItem : NSObject<MJKeyValue>

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *catalog;

@end
