//
//  TANotificationsVC.m
//  Throne
//
//  Created by Anil Kumar on 04/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TANotificationsVC.h"
#import "TANotificationCell.h"
#import "Macro.h"
#import "TASettingsInfo.h"

static NSString * cellIdentifier = @"TANotificationCell";
@interface TANotificationsVC ()<UITableViewDelegate,UITableViewDataSource>
{
    TASettingsInfo * modelObj;
    NSMutableArray * arrayOfTitle;
    NSMutableArray * arrayOfDescription;
    NSMutableArray * arrayOfSelection;
}
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *notificationTabelView;

@end

@implementation TANotificationsVC

#pragma mark - View Life Cycle Methods.
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpInitial];
}

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Helper Methods.
-(void)setUpInitial{
    if ([_titleStr isEqualToString:@"NOTIFICATIONS"]) {
        arrayOfTitle = [[NSMutableArray alloc]initWithObjects:@"RECEIVE MARKETPLACE NOTIFICATIONS",@"RECEIVE THE MANUAL NOTIFICATIONS",@"RECEIVE SPECIAL SALES & ANNOUNCEMENTS NOTIFICATIONS",@"RECEIVE NOTIFICATIONS FROM STORES I FOLLOW",@"DROPS NOTIFICATIONS",@"RECEIVE EVENTS NOTIFICATIONS",nil];
        
        arrayOfDescription = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"THIS WAY YOU'LL NEVER MISS AN EXCLUSIVE RELEASE OR DRAWING FROM A STORE OR CREATOR YOU LOVE AGAIN.",@"WHEN A STORE YOU FOLLOW SCHEDULES A DROP, WE WILL AUTOMATICALLY ADD IT TO YOUR CALENDAR.",@"WHEN THERE'S AN EVENT IN YOUR AREA WE'LL MAKE SURE TO LET YOU KNOW.",nil];
    }else if ([_titleStr isEqualToString:@"EMAIL"]){
        _headerTitleLabel.text = @"EMAILS";
        arrayOfTitle = [[NSMutableArray alloc]initWithObjects:@"MARKETPLACE",@"SPECIAL EVENTS & DRAWINGS",@"THE MANUAL WEEKLY",@"GOOD LOOKS",@"CREATORS: ART",@"CREATORS: ACCESSORIES",@"CREATORS: APPAREL",@"CREATORS: SNEAKER DESIGN",@"CREATORS: SNEAKER DESIGN",@"RESELLERS: SNEAKER",@"RESELLERS: THRIFTED CLOTHING",nil];
        
        NSString * str = @"THIS WAY YOU'LL NEVER MISS AN EXCLUSIVE RELEASE OR DRAWING FROM A STORE OR CREATOR YOU LOVE AGAIN.";
        arrayOfDescription = [NSMutableArray new];
        for (int i = 0; i<arrayOfTitle.count; i++) {
            [arrayOfDescription addObject:str];
        }
    }else if ([_titleStr isEqualToString:@"PUBLIC PROFILE ELEMENTS"]){
        _headerTitleLabel.text = @"PUBLIC PROFILE ELEMENTS";
        arrayOfTitle = [[NSMutableArray alloc]initWithObjects:@"MY PORTFOLIO TAB",@"FOR SALE TAB",@"WORK WITH ME TAB",@"SOLD TAB",@"FAVORITES TAB",@"FOLLOWING TAB",@"PURCHASED TAB",@"TAGLINE",@"BIO",@"LOCATION",@"WEBSITE",@"HEAT INDEX",@"SOCIAL MEDIA",nil];
        
        NSString * str = @"";
        arrayOfDescription = [NSMutableArray new];
        for (int i = 0; i<arrayOfTitle.count; i++) {
            [arrayOfDescription addObject:str];
        }
    }

    arrayOfSelection = [NSMutableArray new];
    for (int i =0; i< arrayOfTitle.count; i++) {
        modelObj = [TASettingsInfo alloc];
        modelObj.isSelected = NO;
        [arrayOfSelection addObject:modelObj];
    }
    self.notificationTabelView.estimatedRowHeight = 20;
    self.notificationTabelView.rowHeight = UITableViewAutomaticDimension;

}
#pragma mark - IBOutlet Button Actions.
- (IBAction)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayOfTitle.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TANotificationCell * cell = (TANotificationCell *)[self.notificationTabelView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TASettingsInfo * selectionObj = [arrayOfSelection objectAtIndex:indexPath.row];
    [cell.switchBtn setOn:selectionObj.isSelected];

    cell.headerTitleLabel.text = [arrayOfTitle objectAtIndex:indexPath.row];
    cell.descriptionLabel.text = [arrayOfDescription objectAtIndex:indexPath.row];
    [cell.seperatorLabel setHidden:(indexPath.row == arrayOfTitle.count-1)?YES:NO];
    
    cell.headerTitleLabel.attributedText = [NSString customAttributeString:cell.headerTitleLabel.text withAlignment:NSTextAlignmentLeft withLineSpacing:5 withFont:[AppUtility sofiaProLightFontWithSize:12]];
    cell.descriptionLabel.attributedText = [NSString customAttributeString:cell.descriptionLabel.text withAlignment:NSTextAlignmentLeft withLineSpacing:3 withFont:[AppUtility sofiaProLightFontWithSize:10]];
    [cell.switchBtn setTag:indexPath.row + 100];
    [cell.switchBtn addTarget:self action:@selector(switchStatusChanged:) forControlEvents:UIControlEventTouchUpInside];
    if ([[arrayOfDescription objectAtIndex:indexPath.row] isEqualToString:@""]) {
        cell.descriptionLblBottmConstraint.constant = 0.1f;
        cell.descriptionLblTopConstraint.constant = 0.1f;

    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return  [[arrayOfDescription objectAtIndex:indexPath.row] isEqualToString:@""]?70:UITableViewAutomaticDimension;
}
#pragma mark - Helper Methods.
// switch btn actions
- (void)switchStatusChanged: (UISwitch *)swichObj {
    TASettingsInfo * selectionObj = [arrayOfSelection objectAtIndex:swichObj.tag -100];
    selectionObj.isSelected = !selectionObj.isSelected;
    [self.notificationTabelView reloadData];
}

@end
