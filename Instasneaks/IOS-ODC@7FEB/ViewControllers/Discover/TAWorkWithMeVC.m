//
//  TAWorkWithMeVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 03/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAWorkWithMeVC.h"
#import "Macro.h"

@interface TAWorkWithMeVC ()<DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView        * purchagedItemTableView;
@property (strong, nonatomic) NSMutableArray            * productListArray;
@end

@implementation TAWorkWithMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.productListArray = [[NSMutableArray alloc] init];
    //[self makeApiCallToGetPurchaseList];
    
    [self.purchagedItemTableView setEmptyDataSetSource:self];
    [self.purchagedItemTableView setEmptyDataSetDelegate:self];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

#pragma mark - UITableView Delgate and DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TAPurchagedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAPurchagedItemCell" forIndexPath:indexPath];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UINavigationController *navBar = (UINavigationController *) [APPDELEGATE window].rootViewController;
    TAProductDetailVC *productDetailVC = [storyboardForName(homeStoryboardString) instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
    productDetailVC.isCommingFromService = YES;
    [productDetailVC setProductId:@"24"];
    [productDetailVC setProductName:@""];
    [navBar pushViewController:productDetailVC animated:YES];
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
@end
