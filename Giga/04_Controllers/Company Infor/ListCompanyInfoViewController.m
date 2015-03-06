//
//  ListCompanyInfoViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/26/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "ListCompanyInfoViewController.h"
#import "ListCompanyCategoryViewController.h"
#import "BookmarkCompanyCell.h"
#import "CompanyInforModel.h"
#import "CompanyDetailViewController.h"
#import "CompanyModel.h"
#import "NormalArticleCell.h"
#import "ArticleModel.h"
#import "RecruitDetailViewController.h"

#define BookmarkCompanyCellID               @"BookmarkCompanyCell"
#define NormalArticleCellID                 @"NormalArticleCell"

@interface ListCompanyInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *tableData;
    
    NSInteger totalNews;
}
@end

@implementation ListCompanyInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(companyBookmarkChanged) name:PUSH_NOTIFICATION_COMPANY_BOOKMARK_CHANGE object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_NOTIFICATION_COMPANY_BOOKMARK_CHANGE object:nil];
}

- (void)loadInterface{
    self.lbSearchCompany.text = localizedString(@"Search Company");
    self.lbBookmarkCompanies.text = localizedString(@"Bookmark Companies");
    self.lbBookmarkCompanies.font = NORMAL_FONT_WITH_SIZE(14);
    self.lbSearchCompany.font = NORMAL_FONT_WITH_SIZE(14);
    
    [self.tbCompanyInfo registerNib:[UINib nibWithNibName:BookmarkCompanyCellID bundle:nil] forCellReuseIdentifier:BookmarkCompanyCellID];
    self.tbCompanyInfo.rowHeight = [BookmarkCompanyCell getCellHeight];
    self.tbCompanyInfo.backgroundColor = RGB(226, 231, 237);
    
    [self.tbCompanyInfo registerNib:[UINib nibWithNibName:NormalArticleCellID bundle:nil] forCellReuseIdentifier:NormalArticleCellID];
   
    [self.tbCompanyInfo setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
   
    
    UIView *searchView = self.btnSearch.superview;
    searchView.layer.cornerRadius = 5.0f;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData{
    
    
    if(!tableData) tableData = [NSMutableArray new];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_TOP_THREE_NEWS andPostMethodKind:YES andParams:[NSMutableDictionary new] inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        
        
        [tableData removeAllObjects];
        NSMutableArray *arNews = [NSMutableArray new];
        if([responseObject[@"news"] isKindOfClass:[NSArray class]])
            [arNews addObjectsFromArray:responseObject[@"news"]];
        for(int i=0;i<arNews.count;i++)
        {
            ArticleModel *item = [ArticleModel insertArticleFromJsonData:[arNews objectAtIndex:i] isBookmark:NO jobType:SharedUserData.curFilterJobType];
            [tableData addObject:item];
        }
        totalNews = arNews.count;
        if(totalNews ==0) totalNews=-1;
        
        [tableData addObject:@"bookmark"];
        
        [tableData addObjectsFromArray:[CompanyInforModel getAllObjects]];
        [self.tbCompanyInfo reloadData];
        
    } failureBlock:^(NSError *error) {
    }];
    
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_STOCK_YAHOO andPostMethodKind:YES andParams:[NSMutableDictionary new] inView:nil shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        
        NSDictionary *result = (NSDictionary *)responseObject;
        _current_time.text = result[@"current_time"];
        _stock.text = result[@"stock"];
        _stock1.text = result[@"stock1"];
        
    } failureBlock:^(NSError *error) {
    }];
}

-(void)companyBookmarkChanged
{
    [self loadData];
}

- (IBAction)btnSearchCompanyTouchUpInside:(id)sender {
    ListCompanyCategoryViewController *searchCompanyVC = [[ListCompanyCategoryViewController alloc] init];
    searchCompanyVC.title = localizedString(@"Company Search");
    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTabViewController)]) {
        [[self.delegate mainTabViewController].navigationController pushViewController:searchCompanyVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return tableData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < totalNews)
        return [NormalArticleCell getCellHeight];
    else if(indexPath.row == totalNews)
        return 40;
    else
        return [BookmarkCompanyCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <totalNews)
    {
        NormalArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalArticleCellID];
        [cell applyStyleIfNeed];
        ArticleModel *article = tableData[indexPath.row];
        ENUM_ARTICLE_CELL_TYPE cellType;
        cellType = ENUM_ARTICLE_CELL_TYPE_NORMAL;
        [cell setObject:article type:cellType];
        return cell;
    }
    else if(indexPath.row == totalNews)
     {
         UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellbookmark"];
         if(!cell)
         {
             cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellbookmark"];
             cell.textLabel.text =localizedString(@"Bookmark Companies");
             cell.textLabel.font =[UIFont systemFontOfSize:15];
             
             UIImageView *img =[[UIImageView alloc] initWithFrame:CGRectMake(-30, 40, 400, 1)];
             img.image =[UIImage imageNamed:@"line-1.png"];
             [cell addSubview:img];
         }
         
         return cell;
     }
    else
    {
        
        BookmarkCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:BookmarkCompanyCellID];
        [cell applyStyleIfNeed];
        
        
        CompanyInforModel *companyInfor = tableData[indexPath.row];
        [cell setObject:companyInfor];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row <totalNews)
    {
        ArticleModel *article = tableData[indexPath.row];
        
        RecruitDetailViewController *vc = [RecruitDetailViewController new];
        vc.recruitItem = article;
        [vc setUpdateCommentCount:^(int adding) {
            ArticleModel *article = tableData[indexPath.row];
            [article updateNumberComment:adding];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(mainTabViewController)]) {
            [[self.delegate mainTabViewController].navigationController pushViewController:vc animated:YES];
        }
    }
    else if(indexPath.row == totalNews)
    {}
    else
    {
        CompanyInforModel *companyInfor = tableData[indexPath.row];
        
        CompanyModel *company = [companyInfor toCompanyModel];
        
        //load basic info
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:company.code forKey:@"code"];
        [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_STOCK andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id stockData) {
            [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_COMPANY_INFO andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id companyInfoData) {
                if (stockData && companyInfoData) {
                    CompanyDetailViewController *viewController = [[CompanyDetailViewController alloc] init];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(mainTabViewController)]) {
                        viewController.company = company;
                        viewController.stockData = stockData;
                        viewController.infoData = companyInfoData;
                        [[self.delegate mainTabViewController].navigationController pushViewController:viewController animated:YES];
                    }
                    
                }
            } failureBlock:nil];
        } failureBlock:nil];
    }
    
}
@end
