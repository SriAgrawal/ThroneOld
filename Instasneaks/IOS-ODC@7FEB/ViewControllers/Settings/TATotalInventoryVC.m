//
//  TATotalInventoryVC.m
//  Throne
//
//  Created by Suresh patel on 06/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TATotalInventoryVC.h"
#import "TAInventoryCell.h"
#import "TAInviteFriendInfo.h"

@interface TATotalInventoryVC ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UITableView *inventoryTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;

@property (strong, nonatomic) NSMutableArray        * titleArray;

@end

@implementation TATotalInventoryVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self tapGestureMethod];
}

#pragma mark - Helper Methods

- (void)initialSetUp {
    
    [self.viewHeightConstraint setConstant:143];
    self.titleArray = [[NSMutableArray alloc] init];

    TAInviteFriendInfo * info = [[TAInviteFriendInfo alloc] init];
    switch (self.salesType) {
        case inventory:
        {
            [info setFriendName:@"items remaining in inventory:"];
            [info setFriendContactNumber:@"48"];
            [self.inventoryTableView setTableFooterView:nil];
            [self.titlelabel setText:@"TOTAL INVENTORY"];
        }
            break;
            
        case profit:
        {
            [info setFriendName:@"amount made on throne:"];
            [info setFriendContactNumber:@"$248"];
            [self.inventoryTableView setTableFooterView:nil];
            [self.titlelabel setText:@"TOTAL PROFIT"];
        }
            break;
            
        case sales:
        {
            [info setFriendName:@"number of items sold:"];
            [info setFriendContactNumber:@"24"];
            [self.inventoryTableView setTableFooterView:nil];
            [self.titlelabel setText:@"TOTAL SALES"];
        }
            break;
            
        default:
            [info setFriendName:@"Upgrade to business to access even deeper analytics."];
            [info setFriendContactNumber:@""];
            [self.viewHeightConstraint setConstant:215];
            [self.titlelabel setText:@"ANALYTICS"];
            break;
    }
    
    [self.titleArray addObject:info];
}
- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - IBActions Method

-(IBAction)minusButtonAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)upgradeButtonAction:(id)sender{
    
}

#pragma mark - UITableView Delegate and Datasource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ((self.salesType == analytics) ? 84.0f : 74.0f);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TAInventoryCell *cell = (TAInventoryCell *)[tableView dequeueReusableCellWithIdentifier:@"TAInventoryCell" forIndexPath:indexPath];
    TAInviteFriendInfo * info = [self.titleArray objectAtIndex:indexPath.row];
    [cell.cellAmountLabel setHidden:(self.salesType == analytics)];
    [cell.cellTitleLabelRightConstraint setConstant:((self.salesType == analytics) ? 50.0f : 83.0f)];
    [cell.cellAmountLabel setText:info.friendContactNumber];
    [cell.cellTitleLabel setAttributedText:[NSString customAttributeString:[info.friendName uppercaseString] withAlignment:NSTextAlignmentLeft withLineSpacing:9 withFont:[AppUtility sofiaProLightFontWithSize:15]]];
    [cell.cellAmountLabel setTextColor:((self.salesType == profit) ? RGBCOLOR(0, 166, 81, 1.0f) : [UIColor blackColor])];

    return cell;
}

#pragma mark - Did Receive Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
