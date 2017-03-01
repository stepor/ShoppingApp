//
//  BookInfoViewController.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/31.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "BookInfoViewController.h"
#import "HTTPSessionManager.h"
#import "Book.h"
#import "ConstantHeader.h"
#import <SDWebImage/UIImageView+Webcache.h>
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "CoreDataHelper.h"

@interface BookInfoCell : UITableViewCell

@property (strong, nonatomic) UIImageView *bookImageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;

@end

@implementation BookInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        _bookImageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _subTitleLabel = [[UILabel alloc] init];
        _priceLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_bookImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_subTitleLabel];
        [self.contentView addSubview:_priceLabel];
    }
    return self;
}

#pragma mark - override
- (void)updateConstraints {
    [self.bookImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(3);
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
        make.right.equalTo(self.contentView.mas_right);
    }];
    
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

@end

@interface BookInfoViewController ()

@property (strong, nonatomic) NSMutableArray *books;
@property (assign, nonatomic) NSInteger bookNum;
@property (strong, nonatomic) CoreDataHelper *coreDataHelper;

@end

@implementation BookInfoViewController

static NSString *const reuseBookInfoCellID = @"bookInfoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _bookNum = -1;
    _books = [NSMutableArray array];
    self.navigationItem.title = _catalogItem.catalog;
    [self.tableView registerClass:[BookInfoCell class] forCellReuseIdentifier:reuseBookInfoCellID];
    [self setUpDropDownRefresh];
    [self setUpPullUpRefresh];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_books) {
        return _books.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseBookInfoCellID forIndexPath:indexPath];
    
    Book *book = _books[indexPath.row];
    cell.titleLabel.text = book.title;
    cell.subTitleLabel.text = book.titleSummary;
    cell.priceLabel.text = book.price;
    NSMutableString *urlStr = [NSMutableString stringWithString:book.imgUrlString];
    [urlStr replaceCharactersInRange:NSMakeRange(0, 4) withString:@"https"];
    [cell.bookImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"book"]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *buyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"加入购物车" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        typeof(weakSelf) strongSelf = weakSelf;
        if(strongSelf) {
            Book *aBook = strongSelf.books[indexPath.row];
            PurchasedBook *pBook = [NSEntityDescription insertNewObjectForEntityForName:EntityName_PurchasedBook inManagedObjectContext:strongSelf.coreDataHelper.context];
            [aBook duplicateAllPropertyToPurchasedBook:pBook];
        }
        
        NSLog(@"加入购物车");
    }];
    
    return @[buyAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - private methods

- (void)setUpDropDownRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) {
            return;
        }
        [[HTTPSessionManager sharedInstance] GET:[self BooksInfoURLStringInRange:NSMakeRange(0, 20)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSError *error = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if(error) {
                NSLog(@"error: %@", error);
            }
            
            NSArray *bookArr = [Book mj_objectArrayWithKeyValuesArray:responseDic[@"result"][@"data"]];
            for(Book *book in bookArr) {
                book.price = [strongSelf randomPrice];
            }
            [strongSelf.books removeAllObjects];//下啦刷新，清空已有book
            [strongSelf.books addObjectsFromArray:bookArr];
            NSString *numStr = responseDic[@"result"][@"totalNum"];
            strongSelf.bookNum = numStr.integerValue;
            NSLog(@"%@ book number: %ld", strongSelf.catalogItem.catalog, strongSelf.bookNum);
            [strongSelf.tableView reloadData];
            strongSelf.tableView.mj_footer.state = MJRefreshStateIdle;
            [strongSelf.tableView.mj_header endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"request failed: %@", error);
        }];
 
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setUpPullUpRefresh {
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        typeof(weakSelf) strongSelf = weakSelf;
        if(!strongSelf) {
            return;
        }
        
        NSInteger loc = strongSelf.books.count;
        if(loc >= strongSelf.bookNum) {
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }
        NSInteger length = 20;
        if((loc + length) > strongSelf.bookNum) {
            length = strongSelf.bookNum - loc;
        }
        
        [[HTTPSessionManager sharedInstance] GET:[strongSelf BooksInfoURLStringInRange:NSMakeRange(loc, length)] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSError *error = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
            if(error) {
                NSLog(@"error: %@", error);
            }
            
            NSArray *bookArr = [Book mj_objectArrayWithKeyValuesArray:responseDic[@"result"][@"data"]];
            for(Book *book in bookArr) {
                book.price = [strongSelf randomPrice];
            }
            [strongSelf.books addObjectsFromArray:bookArr];
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_footer endRefreshing];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSAssert(!error, @"%@", error);
        }];
    }];
}

- (NSString *)BooksInfoURLStringInRange:(NSRange)range {
    return [NSString stringWithFormat:@"https://apis.juhe.cn/goodbook/query?catalog_id=%@&pn=%ld&rn=%ld&dtype=json&key=9eeb46766040a6e04e7fc1b7e1ff1b3d",_catalogItem.ID ,range.location, range.length];
}

- (NSString *)randomPrice {
    NSInteger price = arc4random() %101;
    if(price < 20) {
        price += 20;
    }
    return [NSString stringWithFormat:@"¥%lu", price];
}

#pragma makr - LAZY LOAD
- (CoreDataHelper *)coreDataHelper {
    return [CoreDataHelper sharedInstance];
}

@end
