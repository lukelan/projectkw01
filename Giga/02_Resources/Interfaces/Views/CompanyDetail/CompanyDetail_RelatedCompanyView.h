//
//  CompanyDetail_RelatedCompanyView.h
//  Giga
//
//  Created by Hoang Ho on 12/3/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_BaseSubView.h"

@class CompanyModel;

@protocol CompanyDetail_RelatedCompanyViewDelegate <CompanyDetailSubViewDelegate>

- (void)RelatedCompanyViewDidSelectCompany:(id)sender;

@end

@interface CompanyDetail_RelatedCompanyView : CompanyDetail_BaseSubView<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) CompanyModel *company;
@property (weak, nonatomic) id<CompanyDetail_RelatedCompanyViewDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *tableData;

@property (weak, nonatomic) IBOutlet UITableView *tbCompanies;
@end


