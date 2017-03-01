//
//  CommodityCell.h
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/14.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckCycle.h"

@interface CommodityCell : UITableViewCell<CheckCycleDelegate>

@property (strong, nonatomic) UIImageView *bookImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) CheckCycle *checkCycle;
@property (strong, nonatomic) UILabel *countLabel;

@end
