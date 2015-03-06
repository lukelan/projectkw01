//
//  RecruitRelativeNewsViewController.m
//  Giga
//
//  Created by Tai Truong on 12/15/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "RecruitRelativeNewsViewController.h"
#import "ArticleModel.h"
#import "CompanyModel.h"
#import "UIAlertView+Block.h"

#define DEFAULT_LIMIT                   20

@interface RecruitRelativeNewsViewController ()

@end

@implementation RecruitRelativeNewsViewController
@synthesize company = _company;

-(instancetype)init
{
    self = [[RecruitRelativeNewsViewController alloc] initWithNibName:@"RelativeNewsViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Subclass initWithNibName called");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//have to load data at viewWillAppear because coredata may be changed at others controllers
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.articleId) {
        [self loadData];
    }
}

- (void)setCompany:(CompanyModel *)company
{
    _company = company;
    self.lbCompanyName.text = company.companyName;
    
    self.lbCategory.text = company.market;
    
    if (company.categoryName) {
        self.lbIndustry.text = [NSString stringWithFormat:@"%@ %@", company.code, company.categoryName];
    }
    else {
        self.lbIndustry.text = company.code ? company.code : @"";
    }
}

-(void)loadData
{
    if (!tableData) {
        tableData = [NSMutableArray array];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.articleId forKey:@"article_id"];
    [params setObject:@(offset) forKey:@"offset"];
    [params setObject:@(DEFAULT_LIMIT) forKey:@"limit"];
    [SharedAPIRequestManager operationWithType:ENUM_API_REQUEST_TYPE_GET_RECRUIT_RELATIVE_NEWS andPostMethodKind:YES andParams:params inView:self.view shouldCancelAllCurrentRequest:NO completeBlock:^(id responseObject) {
        if (offset == 0) {
            [tableData removeAllObjects];
        }
        NSMutableArray *result = [NSMutableArray array];
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *companyDic = [[responseObject objectForKey:@"company"] firstObject];
            if (companyDic) {
                CompanyModel *cp = [CompanyModel initWithJsonData:companyDic];
                [self setCompany:cp];
            }
            
            NSArray *arRecruits = responseObject[@"recruits"];
            NSArray *arNews = responseObject[@"news"];
            if (arNews) {
                [result addObjectsFromArray:arNews];
            }
            if (arRecruits) {
                [result addObjectsFromArray:arRecruits];
            }
            
        }
        NSMutableArray *tempArr = [NSMutableArray array];
        for (NSDictionary *dict in result) {
            ArticleModel *art =[ArticleModel insertArticleFromJsonData:dict isBookmark:NO jobType:(int)SharedUserData.curFilterJobType];
            [tempArr addObject:art];
        }

        if (offset == 0 && [tempArr count] == 0) {
            //data not found
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:localizedString(@"Data not found") cancelButtonTitle:localizedString(@"Back")];
            [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
             [self mergeArticle:tempArr];
            [self.tbArticles reloadData];
            [self doneLoadMoreData];
        }
        
    } failureBlock:^(NSError *error) {
        [self doneLoadMoreData];
    }];
}

- (void)mergeArticle:(NSMutableArray*)ar
{
    NSMutableArray *arArticleItems = [NSMutableArray new];
    NSMutableArray *arRecruitItems = [NSMutableArray new];
    
    for (int i = 0; i < ar.count; i++) {
        ArticleModel *article = ar[i];
        switch (article.news_type.integerValue) {
            case 1:
                [arArticleItems addObject:article];
                break;
            case 2:
                [arRecruitItems addObject:article];
                break;
            default:
                break;
        }
    }
    
    [tableData removeAllObjects];
    
    NSInteger posRecruit = 0;
    NSInteger posArticle = 0;
    while (posRecruit < arRecruitItems.count || posArticle < arArticleItems.count)
    {
        //3 normal article
        if (posArticle < arArticleItems.count) {
            if (arArticleItems.count - posArticle < 3) {
                [tableData addObjectsFromArray:[arArticleItems subarrayWithRange:NSMakeRange(posArticle, arArticleItems.count  - posArticle)]];
            } else {
                [tableData addObjectsFromArray:[arArticleItems subarrayWithRange:NSMakeRange(posArticle, 3)]];
            }
        }
        
        //3 recruit article
        if (posRecruit < arRecruitItems.count) {
            if (arRecruitItems.count - posRecruit < 3) {
                [tableData addObjectsFromArray:[arRecruitItems subarrayWithRange:NSMakeRange(posRecruit, arRecruitItems.count  - posRecruit)]];
            } else {
                [tableData addObjectsFromArray:[arRecruitItems subarrayWithRange:NSMakeRange(posRecruit, 3)]];
            }
        }
        
        posRecruit += 3;
        posArticle += 3;
    }
    
}

@end
