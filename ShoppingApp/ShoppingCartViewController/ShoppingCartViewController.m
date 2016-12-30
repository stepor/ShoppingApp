//
//  ShoppingCartViewController.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/14.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "CheckCycle.h"

@interface ShoppingCartViewController ()<CheckCycleDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;


//settle acount
@property (weak, nonatomic) IBOutlet CheckCycle *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *settleLabel;

@end

@implementation ShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectAllButton.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setTotalSumLabelText:50];
    [self setSettleLabelText:10];
}

#pragma mark - --- <UITableViewDataSource> ---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - --- <UITableViewDelegate> ---

#pragma mark - --- <CheckCycleDelegate> ---
- (void)checkCycle:(CheckCycle *)c wasClicked:(BOOL)selected {
    NSLog(@"selected: %i", selected);
}

#pragma mark - --- private methods ---
- (void)setTotalSumLabelText:(float)total {
    NSMutableString *str = [NSMutableString stringWithString:@"合计:￥"];
    [str appendString:[NSString stringWithFormat:@"%.1f", total]];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                          NSForegroundColorAttributeName:[UIColor darkGrayColor],
                          };
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    [attributedStr setAttributes:mutableDic range:NSMakeRange(0, 3)];
    
    mutableDic[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    mutableDic[NSForegroundColorAttributeName] = [UIColor redColor];
    [attributedStr setAttributes:mutableDic range:NSMakeRange(3, attributedStr.length - 3)];
    
    mutableDic[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [attributedStr setAttributes:mutableDic range:NSMakeRange(4, attributedStr.length - 6)];
    
    [self.totalSumLabel setAttributedText:attributedStr];
    
}

- (void)setSettleLabelText:(NSInteger)num {//显示结算商品数量
    self.settleLabel.text = [NSString stringWithFormat:@"结算(%ld)", num];
}


@end
