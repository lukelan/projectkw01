//
//  CompanyDetail_ChartCell.m
//  Giga
//
//  Created by Tai Truong on 12/15/14.
//  Copyright (c) 2014 Hoang Ho. All rights reserved.
//

#import "CompanyDetail_ChartCell.h"

@implementation CompanyDetail_ChartCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _chartImageView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 5, 310, 10)];
        _chartImageView.contentMode  = UIViewContentModeScaleAspectFit;
        [self addSubview:_chartImageView];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_spinner];
        _spinner.hidden = YES;
    }
    return self;
}

- (UIEdgeInsets)layoutMargins
{
    return UIEdgeInsetsZero;
}

+ (CGFloat)getCellHeight
{
    return 44;//for default
}

- (void)setObject:(id)obj
{
    [super setObject:obj];

    if (!obj)
    {
        self.spinner.hidden = NO;
        [self.spinner startAnimating];
    }
    else {
        self.spinner.hidden = YES;
        [self.spinner stopAnimating];
    }
}

- (void)applyStyleIfNeed{
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    UIImage *image = (id)model;
    if (image) {
        CGRect r = self.chartImageView.frame;
        CGFloat heightOfChart =  r.size.width * image.size.height / image.size.width;
        r.size.height = heightOfChart;
        self.chartImageView.frame = r;
    }
    
    if (!self.spinner.hidden) {
        self.spinner.center =  CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
    }
    
}
@end
