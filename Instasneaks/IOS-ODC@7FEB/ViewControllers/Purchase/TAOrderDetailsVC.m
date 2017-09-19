//
//  TAOrderDetailsVC.m
//  Throne
//
//  Created by Krati Agarwal on 03/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAOrderDetailsVC.h"
#import "Macro.h"
#import "TAFeedbackVC.h"

static NSString *sectionCellID = @"TAOrderDetailsSectionCell";
static NSString *orderDetailsCellID = @"TAOrderDetailsCell";
static NSString *shippedCellID = @"TAOrderDetailsShippedCell";
static NSString *billedCellID = @"TAOrderDetailsBilledCell";

@interface TAOrderDetailsVC () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;

@property (weak, nonatomic) IBOutlet UIImageView        *orderImageView;

@property (weak, nonatomic) IBOutlet UILabel            *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *orderStatusLabel;

@property (strong, nonatomic) NSArray                   *sectionTitleArray;
@property (strong, nonatomic) NSArray                   *orderDetailTitleArray;

// Dummy array
@property (strong, nonatomic) NSArray                   *orderDetailDummyArray;
@property (strong, nonatomic) NSArray                   *shippingaddressDummyArray;

@end

@implementation TAOrderDetailsVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Helper Methods

- (void)initialSetUp {

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.orderNameLabel.text = [[self.productDetailsDic objectForKey:pTitle] uppercaseString];
//    self.orderStatusLabel.text = [[self.productDetailsDic objectForKey:pStatus] uppercaseString];
//    self.orderImageView.image = [UIImage imageNamed:[self.productDetailsDic objectForKey:pTutorialImage]];
    self.sectionTitleArray = @[@"ORDER DETAILS", @"SHIPPED TO ME", @"BILLED TO"];
    self.orderDetailTitleArray = @[@"ORDER NUMBER", @"ORDER DATE", @"PRICE", @"SHIPPING", @"TAX", @"TOTAL"];
    
//  Dummy order detail label
    self.orderDetailDummyArray = @[@"1234567891011", @"3/22/2017", @"$475", @"$5", @"$10", @"$490"];
    self.shippingaddressDummyArray = @[@"DANIEL LOWE", @"1645 VINE ST. #808", @"LOS ANGLES, CA 90028"];
    
}

#pragma mark- UIButton Action Method

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)trackShippmentButtonAction:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    TAFeedbackVC *feedBackVC = (TAFeedbackVC *)[storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TAFeedbackVC"];
    [self.navigationController pushViewController:feedBackVC animated:YES];

}

#pragma mark - UITableView Delegate and Datasource Method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0: return [self.orderDetailTitleArray count];
            
            break;
            
        //case 1: return [self.shippingaddressDummyArray count];
            case 1: return 0;
            
            break;
            
        default: return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TAOrderDetailsTableCell *sectionHeaderCell = (TAOrderDetailsTableCell *)[tableView dequeueReusableCellWithIdentifier:sectionCellID];
    
    sectionHeaderCell.sectionNameLabel.text = [self.sectionTitleArray objectAtIndex:section];
        return sectionHeaderCell.contentView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TAOrderDetailsTableCell *cell = (TAOrderDetailsTableCell *)[tableView dequeueReusableCellWithIdentifier:[self cellIdentifierForIndexPath:indexPath] forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        cell.detailTitleLabel.text = [self.orderDetailTitleArray objectAtIndex:indexPath.row];
        cell.detailLabel.text = [self.orderDetailDummyArray objectAtIndex:indexPath.row];
        
    } else if (indexPath.section == 1) {
        
        cell.shippedDetailLabel.text = [self.shippingaddressDummyArray objectAtIndex:indexPath.row];
    } else {
        
        cell.cardNumberLabel.text = @"1234";
        cell.cardImageView.image = [UIImage imageNamed:@"amex-card"];
    }
    
    return cell;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0: return orderDetailsCellID;
        case 1: return shippedCellID;
            
        default: return billedCellID;
    }
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
