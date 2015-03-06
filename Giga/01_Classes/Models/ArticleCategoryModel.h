//
//  CategoryModel.h
//  Giga
//
//  Created by Hoang Ho on 11/25/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "BaseModel.h"

@interface ArticleCategoryModel : BaseModel
@property (copy, nonatomic) NSString *categoryID;
@property (copy, nonatomic) NSString *categoryTitle;
//@property (assign, nonatomic) int categoryType;
@end
