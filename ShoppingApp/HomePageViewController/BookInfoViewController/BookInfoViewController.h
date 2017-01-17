//
//  BookInfoViewController.h
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/31.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogItem.h"

@interface BookInfoViewController : UITableViewController

@property (strong, nonatomic) CatalogItem *catalogItem;

@end
