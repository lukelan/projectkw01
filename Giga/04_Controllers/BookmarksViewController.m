//
//  BookmarksViewController.m
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BookmarksViewController.h"
#import "ArticleModel.h"
#import "NormalArticleCell.h"
#import "RecruitDetailViewController.h"
#import "RecruitArticleCell.h"

#define NormalArticleCellID                 @"NormalArticleCell"
#define RecruitArticleCellID                 @"RecruitArticleCell"

@interface BookmarksViewController ()
{
    NSMutableArray *tableData;
}
@end

@implementation BookmarksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadInterface];
}

- (void)loadInterface
{
    [self.tbBookmark setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    
    self.lbNoBookmark.text = localizedString(@"There is no acticle bookmark");
    self.lbNoBookmark.font = NORMAL_FONT_WITH_SIZE(14);
    
    [self.tbBookmark registerNib:[UINib nibWithNibName:NormalArticleCellID bundle:nil] forCellReuseIdentifier:NormalArticleCellID];
    [self.tbBookmark registerNib:[UINib nibWithNibName:RecruitArticleCellID bundle:nil] forCellReuseIdentifier:RecruitArticleCellID];
    
    self.tbBookmark.backgroundColor = RGB(226, 231, 237);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    
    //Hoang
//    [self syncData];
}

- (void)loadData
{
 //load local data
    tableData = [NSMutableArray arrayWithArray:[ArticleModel getBookmarkItems]];
    [self.tbBookmark reloadData];
}

- (void)syncData
{
    NSMutableArray *tempData = [NSMutableArray array];
    NSMutableArray *listIds = [NSMutableArray array];
    for (ArticleModel *art in tableData) {
        if (![listIds containsObject:art.articleID]) {
            [listIds addObject:art.articleID];
        }
    }
    NSMutableString *ids = [NSMutableString string];
    for (int i = 0; i < listIds.count; i++) {
        [ids appendString:listIds[i]];
        if (i  < listIds.count - 1) {
            [ids appendString:@","];
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:ids forKey:@"article_ids[]"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_ARTICLES_BY_IDS andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        NSArray *data = responseObject;
        if (data.count > 0) {
            for (NSDictionary *dict in data) {
                ArticleModel *article = [ArticleModel insertArticleFromJsonData:dict isBookmark:YES jobType:SharedUserData.curFilterJobType];
                [tempData addObject:article];
                
                //valid article
                [listIds removeObject:article.articleID];
            }
            //check invalid articles
            for (NSString *artID in listIds) {
                ArticleModel *art = [ArticleModel getArticleByID:artID];
                if(art){
                    [art MR_deleteEntity];
//                    [SharedDataCenter.managedObjectContext deleteObject:art];
                }
            }
            [SharedDataCenter saveContext];
            
            tableData = [NSMutableArray arrayWithArray:[ArticleModel getBookmarkItems]];
            [self.tbBookmark reloadData];
            
            [self.tbBookmark reloadData];
        }
    } failureBlock:nil];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *article = tableData[indexPath.row];
   
    if (article.news_type.intValue == 1) {
        return [NormalArticleCell getCellHeight];
    }else if (article.news_type.intValue == 2) {//recruit
        return [RecruitArticleCell getCellHeight];
    }
    return 0;//hidden cell
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableData.count == 0) {
        self.tbBookmark.hidden = YES;
        if (self.noBookmarkView.superview != self.view) {
            [self.view addSubview:self.noBookmarkView];
        }
    }else{
        self.tbBookmark.hidden = NO;
        if (self.noBookmarkView.superview == self.view) {
            [self.noBookmarkView removeFromSuperview];
        }
    }
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleModel *article = tableData[indexPath.row];
    
    if (article.news_type.intValue == 1) {
        NormalArticleCell *normalCell = [tableView dequeueReusableCellWithIdentifier:NormalArticleCellID];;

        [normalCell applyStyleIfNeed];
        
        [normalCell setObject:article];
        
        return normalCell;
    }else if (article.news_type.intValue == 2) {
        RecruitArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:RecruitArticleCellID];
        [cell applyStyleIfNeed];
        
        [cell setObject:article];
        
        return cell;
        
    }
    //this cell will be hidden automatically because of it's height is 0
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HIDDEN_CELL"];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecruitDetailViewController *vc = [RecruitDetailViewController new];
    ArticleModel *article = tableData[indexPath.row];
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

@end
