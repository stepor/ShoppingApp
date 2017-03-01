//
//  ShoppingCartViewController.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/14.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "CheckCycle.h"
#import "ConstantHeader.h"
#import "CoreDataHelper.h"
#import "CommodityCell.h"
#import "Book.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef struct _CountAndSum {
    NSInteger count;
    CGFloat sum;
} CountAndSum;

@interface CountStatus : NSObject

@property (assign, nonatomic) NSInteger count;
@property (assign, nonatomic) BOOL selected;

@end

@implementation CountStatus

- (instancetype)init {
    self = [super init];
    if(self) {
        _count = 0;
        _selected = false;
    }
    return self;
}

@end

@interface ShoppingCartViewController ()<CheckCycleDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *purchasedBooks;
@property (strong, nonatomic) NSMutableDictionary<NSString *, CountStatus *> *purchasedCountDic;

//settle acount
@property (weak, nonatomic) IBOutlet CheckCycle *selectAllButton;
@property (weak, nonatomic) IBOutlet UILabel *totalSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *settleLabel;


@end

@implementation ShoppingCartViewController

static NSString *const reuseCommodityCellID = @"CommodityCell";

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.selectAllButton.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setTotalSumLabelText:50];
    [self setSettleLabelText:10];
    
    [self.tableView registerClass:[CommodityCell class] forCellReuseIdentifier:reuseCommodityCellID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:EntityName_PurchasedBook];
    NSError *error = nil;
    NSArray *arr = [[CoreDataHelper sharedInstance].context executeFetchRequest:fetchRequest error:&error];
    self.purchasedBooks = [NSMutableArray arrayWithArray:arr];
    self.purchasedCountDic = [NSMutableDictionary dictionary];
    
    for(int i = 0; i < self.purchasedBooks.count; i++) {
        Book *book = self.purchasedBooks[i];
        if(self.purchasedCountDic[book.tags]) {
            CountStatus *cs = self.purchasedCountDic[book.tags];
            cs.count++;
            [self.purchasedBooks removeObjectAtIndex:i];
            i--;
        } else {
            CountStatus *cs = [CountStatus new];
            cs.count = 1;
            self.purchasedCountDic[book.tags] = cs;
        }
    }
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource> 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.purchasedBooks) {
        return self.purchasedBooks.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCommodityCellID forIndexPath:indexPath];
    if(cell.checkCycle.delegate != self) {
        cell.checkCycle.delegate = self;
    }
    
    PurchasedBook *book = self.purchasedBooks[indexPath.row];
    cell.titleLabel.text = book.title;
    cell.subTitleLabel.text = book.titleSummary;
    cell.priceLabel.text = book.price;
    CountStatus *cs = self.purchasedCountDic[book.tags];
    cell.countLabel.text = [NSString stringWithFormat:@"x%ld", cs.count];
    [cell.checkCycle setSelectedWithoutCallback:cs.selected];
    NSLog(@"cell:%d", cs.selected);
    NSMutableString *urlStr = [NSMutableString stringWithString:book.imgUrlString];
    [urlStr replaceCharactersInRange:NSMakeRange(0, 4) withString:@"https"];
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"book"]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    return cell;
}

#pragma mark - --- <UITableViewDelegate> ---
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - --- <CheckCycleDelegate> ---
- (void)checkCycle:(CheckCycle *)c wasClicked:(BOOL)selected {
    NSInteger totalCount = 0;
    CGFloat totalPrice = 0.0;
    if(c == self.selectAllButton) {
        NSArray *arr = [self.purchasedCountDic allValues];
        if(!selected) {
            for(CountStatus *cs in arr) {
                cs.selected = selected;
            }
        } else {
            for(PurchasedBook *book in self.purchasedBooks) {
                CountStatus *cs = self.purchasedCountDic[book.tags];
                NSInteger num = cs.count;
                cs.selected = selected;
                totalPrice += num * [book.price substringFromIndex:1].integerValue;
                totalCount += num;
            }
        }
    } else {
        CommodityCell *cell = (CommodityCell *)c.superview.superview;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        PurchasedBook *pBook = self.purchasedBooks[indexPath.row];
        CountStatus *cs = self.purchasedCountDic[pBook.tags];
        cs.selected = selected;
        [self.selectAllButton setSelectedWithoutCallback:true];
        for(PurchasedBook *book in self.purchasedBooks) {
            CountStatus *cs1 = self.purchasedCountDic[book.tags];
            if(cs1.selected) {
                totalCount += cs1.count;
                totalPrice += cs1.count * [book.price substringFromIndex:1].integerValue;
            } else {
                [self.selectAllButton setSelectedWithoutCallback:false];
            }
        }
    }
    
    [self.tableView reloadData];
    [self setTotalSumLabelText:totalPrice];
    [self setSettleLabelText:totalCount];
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

- (CountAndSum)currentCountAndSum {
    CGFloat totalPrice;
    NSInteger count;
    
    
    return (CountAndSum){count, totalPrice};
}

@end


