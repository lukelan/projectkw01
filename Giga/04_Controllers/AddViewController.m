//
//  AddViewController.m
//  Giga
//
//  Created by Le Trung Hai on 1/24/15.
//  Copyright (c) 2015 Hoang Ho. All rights reserved.
//

#import "AddViewController.h"


@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _tbvAdd.delegate =self;
    _tbvAdd.dataSource =self;
    [self.tbvAdd setContentInset:UIEdgeInsetsMake(0, 0, 50, 0)];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [_tbvAdd addGestureRecognizer:longPress];
    
   
    [self initData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initData
{
    if(_arrayItem == nil)
        _arrayItem = [NSMutableArray new];
//    if(_bNews)
//    {
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"Topic") newsID:@"1" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"Economy") newsID:@"2" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"社会") newsID:@"3" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"IT") newsID:@"4" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"Entertainment") newsID:@"5" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"Medical Care・Welfare・Care") newsID:@"6" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"フード・食") newsID:@"7"selected:YES ]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"HR・人事") newsID:@"8"selected:YES ]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"不動産") newsID:@"9"selected:YES ]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"Job") newsID:@"10" selected:YES]];
//    }
//    else
//    {
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"おすすめ求人") newsID:@"1" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"IT") newsID:@"2" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"福祉・介護") newsID:@"3" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"医療系") newsID:@"4" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"食・サービス") newsID:@"5" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"HR・人事") newsID:@"6" selected:YES]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"営業系") newsID:@"7"selected:YES ]];
//        [_arrayItem addObject:[NewsItem initWithNewsName:localizedString(@"その他") newsID:@"8"selected:YES ]];
//    }
    [_arrayItem removeAllObjects];
    
    for(int i= 0;i<_array.count;i++)
    {
        [_arrayItem addObject:[NewsItem initWithNewsName:[[_array objectAtIndex:i] objectForKey:@"name"] newsID:[[_array objectAtIndex:i] objectForKey:@"id"] selected:[[[_array objectAtIndex:i] objectForKey:@"select"] boolValue]]];
    }
    
}
#pragma mark - Table view Delegate
-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayItem.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIImageView *imageView = [[UIImageView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        UIImageView *accessoryImageView = [[UIImageView alloc] init];
        label.backgroundColor = [UIColor clearColor];
        imageView.tag = 100;
        label.textColor = [UIColor blackColor];
        
        [cell addSubview:imageView];
        label.tag = 101;
        [cell addSubview:label];
        
        accessoryImageView.tag = 102;
        [cell addSubview:accessoryImageView];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        UILabel *lblMenu = (UILabel *)[cell viewWithTag:101];
        UIImageView *imgMenu = (UIImageView *)[cell viewWithTag:100];
        UIImageView *accessoryImageView1 = (UIImageView *)[cell viewWithTag:102];
    
    
        NewsItem *obj = [_arrayItem objectAtIndex:indexPath.row];
        
        imgMenu.frame = CGRectMake(20, 12, 20, 20);
        lblMenu.frame = CGRectMake(imgMenu.frame.origin.x + imgMenu.frame.size.width + 10, 3, tableView.frame.size.width - (imgMenu.frame.origin.x + imgMenu.frame.size.width + 10) - 30, 44);
        lblMenu.text = obj.newsName;
        lblMenu.font = [UIFont systemFontOfSize:14];
        if(obj.selected)
            imgMenu.image = [UIImage imageNamed: @"bt_add_check"];
        else
            imgMenu.image = [UIImage imageNamed: @"bt_add_uncheck"];
        accessoryImageView1.frame = CGRectMake(tableView.frame.size.width - 25, 17, 15, 15);
        accessoryImageView1.hidden = NO;
        accessoryImageView1.image =[UIImage imageNamed:@"bt_add_menu"];
        
        
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     NewsItem *obj = [_arrayItem objectAtIndex:indexPath.row];
    obj.selected =!obj.selected;
    [_tbvAdd reloadData];
    if([_delegate respondsToSelector:@selector(addController:selectItemIndex:itemID:itemSelect:)])
        [_delegate addController:self selectItemIndex:indexPath.row itemID:obj.newsID itemSelect:obj.selected];
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_arrayItem removeObjectAtIndex:indexPath.row];
    [_tbvAdd deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)longPressGestureRecognized:(id)sender
{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:_tbvAdd];
    NSIndexPath *indexPath = [_tbvAdd indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state)
    {
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [_tbvAdd cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshoFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [_tbvAdd addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [_arrayItem exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                if([_delegate respondsToSelector:@selector(addController:moveFromIndex:toIndex:)])
                {
                    [_delegate addController:self moveFromIndex:indexPath.row toIndex:sourceIndexPath.row];
                }
                // ... move the rows.
                [_tbvAdd moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            if([_delegate respondsToSelector:@selector(addControllerFinish:)])
                [_delegate addControllerFinish:self];
            break;
        }
            
        default:
        {
            // Clean up.
            UITableViewCell *cell = [_tbvAdd cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            
            break;
        }
    }
}
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


@end

@implementation NewsItem
+ (instancetype)initWithNewsName:(NSString*)name newsID:(NSString*)newsID selected:(BOOL)select
{
    NewsItem *obj = [[NewsItem alloc] init];
    if (obj) {
        obj.newsName = name;
        obj.newsID = newsID;
        obj.selected = select;
    }
    return obj;
}


#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.newsName forKey:@"newsName"];
    [aCoder encodeObject:self.newsID forKey:@"newsID"];
    [aCoder encodeBool:self.selected forKey:@"selected"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.newsName = [aDecoder decodeObjectForKey:@"newsName"];
    self.newsID = [aDecoder decodeObjectForKey:@"newsID"];
    self.selected = [aDecoder decodeBoolForKey:@"selected"];
    return self;
}

@end