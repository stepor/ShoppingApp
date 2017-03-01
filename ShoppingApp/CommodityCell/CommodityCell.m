//
//  CommodityCell.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/14.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "CommodityCell.h"
#import <Masonry/Masonry.h>

@implementation CommodityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _bookImageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _subTitleLabel = [[UILabel alloc] init];
        _priceLabel = [[UILabel alloc] init];
        _checkCycle = [[CheckCycle alloc] init];
        //_checkCycle.delegate = self;
        _countLabel = [[UILabel alloc] init];
        
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = [UIColor redColor];
        _countLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_bookImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_subTitleLabel];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_checkCycle];
        [self.contentView addSubview:_countLabel];
    }
    return self;
}

#pragma mark - override
- (void)updateConstraints {
    [self.checkCycle mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(3);
        make.top.equalTo(self.contentView.mas_top).offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-3);
        make.width.equalTo(@20);
    }];
    
    [self.bookImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkCycle.mas_right).offset(3);
        make.top.equalTo(self.contentView.mas_top).offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-3);
        make.width.equalTo(self.bookImageView.mas_height);
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.equalTo(@30);
        make.height.height.equalTo(@20);
    }];
    
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookImageView.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.priceLabel.mas_left).offset(-8);
        make.height.mas_equalTo(self.subTitleLabel.mas_height).multipliedBy(2);
    }];
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.bookImageView.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.countLabel.mas_left).offset(-8);
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_right);
        make.centerY.equalTo(self.subTitleLabel.mas_centerY);
        make.left.equalTo(self.priceLabel.mas_left);
        make.height.equalTo(@20);
    }];
    
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - CheckCycleDelegate
- (void)checkCycle:(CheckCycle *)c wasClicked:(BOOL)selected {
    
}


@end
