//
//  HomePageViewController.m
//  ShoppingApp
//
//  Created by 黄文鸿 on 2016/12/30.
//  Copyright © 2016年 黄文鸿. All rights reserved.
//

#import "HomePageViewController.h"
#import "HTTPSessionManager.h"
#import <MJExtension/MJExtension.h>
#import "CatalogItem.h"
#import "BookInfoViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface CatalogCell : UITableViewCell


@end

@implementation CatalogCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =  [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end


@interface HomePageViewController ()

@property (strong, nonatomic) NSArray *catalogs;

@end

@implementation HomePageViewController

static NSString *const catalogURLString = @"https://apis.juhe.cn/goodbook/catalog?key=9eeb46766040a6e04e7fc1b7e1ff1b3d&dtype=json";

static NSString *const reusedCatalogCellID = @"catalogCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"图书目录";
    [self setUpDropDownRefresh];
    [self setUpPullUpRefresh];
    [self.tableView registerClass:[CatalogCell class] forCellReuseIdentifier:reusedCatalogCellID];
    self.clearsSelectionOnViewWillAppear = YES;
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
    if(_catalogs != nil) {
        return _catalogs.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedCatalogCellID forIndexPath:indexPath];
    CatalogItem *item = _catalogs[indexPath.row];
    [cell.textLabel setText:item.catalog];
    return cell;
}

#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookInfoViewController *bookInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BookInfoViewController"];
    bookInfoVC.catalogItem = _catalogs[indexPath.row];
    [self.navigationController pushViewController:bookInfoVC animated:YES];
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
        [[HTTPSessionManager sharedInstance] GET:catalogURLString parameters:NULL progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
                NSError *error = NULL;
                NSDictionary *dicResponse = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
                if(error) {
                    NSLog(@"error: %@", error);
                }
                strongSelf.catalogs = [CatalogItem mj_objectArrayWithKeyValuesArray:dicResponse[@"result"]];
            [strongSelf.tableView reloadData];
            [strongSelf.tableView.mj_header endRefreshing];
            strongSelf.tableView.mj_footer.state = MJRefreshStateIdle;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"fail to requst catalog info: %@", error);
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
        [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

@end

