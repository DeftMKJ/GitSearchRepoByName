//
//  GitSearchViewController.m
//  GitRepoSearch
//
//  Created by 宓珂璟 on 2017/1/3.
//  Copyright © 2017年 Deft_Mikejing_iOS_coder. All rights reserved.
//

#import "GitSearchViewController.h"
#import "CommonDefine.h"
#import "MKJRequestHelp.h"
#import "GitTableViewCell.h"
#import "GitSearchModel.h"
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "GitSearchDetailViewController.h"
@interface GitSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic,strong) UISearchController *searchController;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic,copy) NSString *tempKeywords;

@end

static NSString *reuseIdentifyID = @"GitTableViewCell";

@implementation GitSearchViewController

- (void)dealloc
{
    NSLog(@"dealloc--->%s",object_getClassName(self));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索repo";
    self.currentPage = 1;
    [self.view addSubview:self.tableView];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    self.searchController.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO; // 搜素时背景变成暗色
    self.searchController.hidesNavigationBarDuringPresentation = YES; //!< 影藏导航栏
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    self.tableView.mj_footer = footer;
    
}

- (void)requestData:(NSString *)keywords
{
    self.currentPage = 1;
    self.tableView.mj_footer.hidden = NO;
    __weak typeof(self)weakSelf = self;
    [[MKJRequestHelp shareRequestHelp] requestGitSearchListsWithKeywords:keywords page:self.currentPage count:30 completio:^(id obj, NSError *err) {
        weakSelf.searchResults = (NSMutableArray *)obj;
        [weakSelf.tableView reloadData];
        weakSelf.currentPage++;
        NSLog(@"%@",obj);
    }];
}

// 上拉加载更多
- (void)loadMoreData
{
    __weak __typeof(self) weakSelf = self;
    [[MKJRequestHelp shareRequestHelp] requestGitSearchListsWithKeywords:self.tempKeywords page:self.currentPage count:30 completio:^(id obj, NSError *err) {
        [weakSelf.tableView.mj_footer endRefreshing];
        NSMutableArray *detailLists = ((NSMutableArray *)obj);
        NSMutableArray * indexPaths = [NSMutableArray new];
        NSInteger lastIndex = [weakSelf.tableView numberOfRowsInSection:0];
        // 下拉有数据
        if (detailLists.count != 0)
        {
            for (GitRepoModel *repoModel in detailLists)
            {
                [weakSelf.searchResults addObject:repoModel];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastIndex inSection:0];
                lastIndex++;
                [indexPaths addObject:indexPath];
                
            }
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            weakSelf.tableView.mj_footer.hidden = NO;
        }
        else
        {
            weakSelf.tableView.mj_footer.hidden = YES;
            return;
        }
        weakSelf.currentPage++;
    }];
}

#pragma mark - 搜索实时更新代理方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    self.searchController.searchBar.delegate = self;
    NSString *searchWord = self.searchController.searchBar.text;
    self.tempKeywords = searchWord;
    if (self.tempKeywords == nil || [self.tempKeywords isEqualToString:@""]) {
        return;
    }
    NSLog(@"%@",searchWord);
    
    NSMutableArray *tasks = [[MKJRequestHelp shareRequestHelp] searchKeywordTasks];
    [tasks enumerateObjectsUsingBlock:^(NSURLSessionTask *task, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [task cancel];
    }];
    [tasks removeAllObjects];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(requestData:) object:self.tempKeywords];
    [self performSelector:@selector(requestData:) withObject:self.tempKeywords afterDelay:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifyID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell indexpath:indexPath];
    return cell;
}


- (void)configureCell:(GitTableViewCell *)cell indexpath:(NSIndexPath *)indexpath
{
    GitRepoModel *model = self.searchResults[indexpath.row];
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.owner.ownerAvatar] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image && cacheType == SDImageCacheTypeNone) {
            cell.avatarImageView.alpha = 0;
            [UIView animateWithDuration:.8 animations:^{
                cell.avatarImageView.alpha = 1.0f;
            }];
        }
        else
        {
            cell.avatarImageView.alpha = 1.0f;
        }
    }];
    cell.repoNameLabel.text = [NSString stringWithFormat:@"REPO:%@",model.repoShotName];
    cell.ownerNamelabel.text = [NSString stringWithFormat:@"OWNER:%@",model.owner.ownerName];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchController.searchBar resignFirstResponder];
    [self.searchController setActive:NO];
    GitRepoModel *model = self.searchResults[indexPath.row];
    GitSearchDetailViewController *detailVC = [[GitSearchDetailViewController alloc] init];
    detailVC.fullRepoName = model.repoFullName;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchController.searchBar resignFirstResponder];
}


- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:reuseIdentifyID bundle:nil] forCellReuseIdentifier:reuseIdentifyID];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)searchResults
{
    if (_searchResults == nil) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
