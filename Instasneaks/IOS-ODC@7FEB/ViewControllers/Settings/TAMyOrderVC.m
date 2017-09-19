//
//  TAMyOrderVC.m
//  Throne
//
//  Created by Suresh patel on 09/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAMyOrderVC.h"
#import "Macro.h"

@interface TAMyOrderVC ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView        * purchagedItemTableView;

@property (strong, nonatomic) NSMutableArray            * productListArray;
@end

@implementation TAMyOrderVC

#pragma mark- Life Cycle of View Controller
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.productListArray = [[NSMutableArray alloc] init];
    [self makeApiCallToGetPurchaseList];
    
    [self.purchagedItemTableView setEmptyDataSetSource:self];
    [self.purchagedItemTableView setEmptyDataSetDelegate:self];
    }

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark - UITableView Delgate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.productListArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TAPurchagedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAPurchagedItemCell" forIndexPath:indexPath];
    
    TAProductInfo *productInfo = [self.productListArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = productInfo.productName;
    [cell.productImageView sd_setImageWithURL:[NSURL URLWithString:productInfo.productImage] placeholderImage:[UIImage imageNamed:@"product-1-big"] options:SDWebImageRefreshCached];
    cell.sizeLabel.text = productInfo.productSize;;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    TAOrderDetailsVC *productVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAOrderDetailsVC"];
     NSMutableDictionary *productDic = [self.productListArray objectAtIndex:indexPath.row];
    productVC.productDetailsDic = productDic;
    [self.navigationController pushViewController:productVC animated:YES];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"GET WORKING!\nYOU HAVE NOTHING TO SHOW HERE YET.";
    NSDictionary *attributes = @{NSFontAttributeName: [AppUtility sofiaProBoldFontWithSize:15], NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentCenter;
    [pStyle setLineSpacing:6];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [text length])];
    return string;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -160.0f;
}
#pragma mark- UIButton Action Method

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Web Service Method

-(void)makeApiCallToGetPurchaseList{
    [[ServiceHelper helper] request:nil apiName:kOrders_Mine withToken:YES method:GET onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.productListArray removeAllObjects];
            [self.productListArray addObjectsFromArray:[TAProductInfo parsePurchasedListData:[result objectForKeyNotNull:pOrders expectedObj:[NSArray array]]]];
            [self.purchagedItemTableView reloadData];
        });
    }];
}

@end
