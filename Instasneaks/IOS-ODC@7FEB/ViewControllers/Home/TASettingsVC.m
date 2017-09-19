//
//  TASettingsVC.m
//  Throne
//
//  Created by Anil Kumar on 02/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TASettingsVC.h"
#import "TAExpandableCell.h"
#import "TASettingsInfo.h"
#import "TASettingsNameCell.h"
#import "Macro.h"

static NSString * cellIdentifier = @"TAExpandableCell";
static NSString * nameCellIdentifier = @"TASettingsNameCell";

@interface TASettingsVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    BOOL isExpanded;
    UserInfo * userInfo;
}

@property (weak, nonatomic) IBOutlet UIButton *profileNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *applyToSellBtn;
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (strong, nonatomic) NSMutableArray * arrayOfSelection;

@end

@implementation TASettingsVC

#pragma  mark - View Life Cycle Methods.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpInitialMethod];
}

#pragma  mark - Memory Management Methods.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - Helper Methods.
-(void)setUpInitialMethod{
    _profileNameBtn.layer.borderWidth = 2.0f;
    _applyToSellBtn.layer.borderWidth = 2.0f;

    userInfo = [UserInfo sharedManager];
    [self.profileNameBtn setTitle:[NSString stringWithFormat:@"%@%@",[[userInfo.firstNameString substringToIndex:1] uppercaseString], [[userInfo.lastNameString substringToIndex:1] uppercaseString]] forState:UIControlStateNormal];
    
    self.arrayOfSelection = [[NSMutableArray alloc] init];
    NSArray * sectionsTitle = [NSArray arrayWithObjects:@"PERSONAL INFORMATION", @"SIZE INFORMATION",@"ORDER INFORMATION",@"SALES",@"COMMUNITY FAVOR RANKINGS",@"EVENTS",@"THRONE DROPS",@"COMMUNITIES",@"PREMIUM",@"COMMUNICATION PREFERENCES",@"STAY CONNECTED",@"PRIVACY",@"SUPPORT", nil];
    
    for (int section = 0; section < sectionsTitle.count; section++) {
       TASettingsInfo * modelObj = [TASettingsInfo alloc];
        modelObj.sectionTitle = [sectionsTitle  objectAtIndex:section];
        switch (section) {
            case 0:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"FIRST NAME",@"LAST NAME",@"EMAIL",@"WEBSITE",@"LOCATION",@"PHONE",@"PASSWORD",@"SOCIAL MEDIA",@"TAGLINE",@"BIO",nil];
                break;
            case 1:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"GENDER",@"SHOE SIZE",@"TOP",@"BOTTOM",nil];
                break;
            case 2:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"ORDER HISTORY",@"PAYMENT",@"WALLET",@"SHIPPING",nil];
                break;
            case 3:
                modelObj.sectionsRowData =  [[NSMutableArray alloc] initWithObjects:@"TOTAL SALES",@"MY TOTAL PROFIT",@"INVENTORY LEVELS",@"UPLOAD NEW PRODUCTS",@"ANALYTICS",nil];
                break;
            case 4:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"TASTE LEVEL",@"WARDROBE WARS",@"EMPIRE",@"ARCHITECTS",@"FAMILIARITY",@"COME UP",@"TOTAL COMMUNITY FAVOR",nil];
                break;
            case 5:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"EVENTS CALENDAR",@"MY EVENTS",@"SUBMIT AN EVENT",nil];
                break;
            case 6:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"HAPPENING NOW",@"PAST DROPS",@"CREATE MY OWN DROP",nil];
                break;
            case 7:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"AMBASSADORS",@"ARCHITECTS",@"THRONE CERTIFIED",@"MENTOR",nil];
                break;
            case 8:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"VIP MEMBERSHIP",@"UPGRADE TO BUSINESS",nil];
                break;
            case 9:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"NOTIFICATIONS",@"EMAILS",nil];
                break;
            case 10:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"FOLLOW US ON FACEBOOK",@"FOLLOW US ON INSTAGRAM",@"FOLLOW US ON TWITTER",@"SUBSCRIBE TO OUR YOUTUBE CHANNEL",@"ADD US ON SNAPCHAT",nil];
                break;
            case 11:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"PUBLIC PROFILE ELEMENTS",@"TERMS & POLICY",nil];
                break;
            case 12:
                modelObj.sectionsRowData = [[NSMutableArray alloc] initWithObjects:@"FAQ",@"CONTACT",@"PROMOTE",@"LOGOUT",nil];
                break;
            default:
                break;
        }
        [self.arrayOfSelection addObject:modelObj];
    }
}

#pragma  mark - IBOutlet Button actions.
- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)walletBtnAction:(UIButton *)sender {
    TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
    walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
- (IBAction)applyToSellBtnAction:(UIButton *)sender {
    
    TABecomeVendarVC *requestVC = [storyboardForName(categoryStoryboardString) instantiateViewControllerWithIdentifier:@"TABecomeVendarVC"];
    requestVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:requestVC];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma  mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *textFieldString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UILabel * lbl = (UILabel *)[self.view viewWithTag:textField.tag +100];
    if ([textFieldString length] > 0) {
           [lbl setHidden:YES];
        return YES;
    }else{
        [lbl setHidden:NO];
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.returnKeyType == UIReturnKeyNext) {
        [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
        return NO;
    }
    else
        [textField resignFirstResponder];
    return YES;
}

#pragma  mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayOfSelection.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    TASettingsInfo * selectionObj = [self.arrayOfSelection objectAtIndex:section];
    UIView *backgroundSection ;
    UILabel *title ;
    UILabel *titleSeperator  ;
    UIButton * plusBtn ;
    UIImageView * plusImage ;
    UILabel *titleTopSeperator  ;

    if (section == 0) {
        backgroundSection = [[UIView alloc]initWithFrame:CGRectMake(0,0, windowWidth, 50)];
        title = [[UILabel alloc]initWithFrame:CGRectMake(15, 27, windowWidth-50, 14)];
        titleSeperator = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, windowWidth, 1)];
        plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 52)];
        plusImage = [[UIImageView alloc] initWithFrame:CGRectMake(windowWidth - 25, 27, 10 , 14)];
    }else{
        backgroundSection = [[UIView alloc]initWithFrame:CGRectMake(0,0, windowWidth, 82)];
        title = [[UILabel alloc]initWithFrame:CGRectMake(15, 58, windowWidth-50, 14)];
        titleSeperator = [[UILabel alloc]initWithFrame:CGRectMake(0, 81, windowWidth, 1)];
        plusBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, windowWidth, 82)];
        plusImage = [[UIImageView alloc] initWithFrame:CGRectMake(windowWidth - 25, 58, 10, 14)];
    }
    plusImage.contentMode = UIViewContentModeCenter;
    [plusImage  setImage:selectionObj.isSelected ? [UIImage imageNamed:@"minus"] : [UIImage imageNamed:@"plus"]];
    [titleTopSeperator  setBackgroundColor:selectionObj.isSelected ? [UIColor darkGrayColor]:[UIColor clearColor]];
    if (section == 0) {
        [titleTopSeperator setBackgroundColor:[UIColor clearColor]];
    }
    backgroundSection.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor blackColor];
    [title setFont:[AppUtility sofiaProBoldFontWithSize:10]];
    title.text = selectionObj.sectionTitle;
    if(section == 8){
        backgroundSection.backgroundColor = [UIColor blackColor];
        [plusImage  setImage:selectionObj.isSelected ? [UIImage imageNamed:@"minus_white"] : [UIImage imageNamed:@"follow-plus-white"]];
        title.textColor = [UIColor whiteColor];
    }
    titleSeperator.backgroundColor = [UIColor darkGrayColor];

    [plusBtn setTag:section + 1000];
    [plusBtn addTarget:self action:@selector(sectionTap:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundSection addSubview:title];
    [backgroundSection addSubview:titleSeperator];
    [backgroundSection addSubview:titleTopSeperator];
    [backgroundSection addSubview:plusBtn];
    [backgroundSection addSubview:plusImage];

    return backgroundSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 52.0f : 82.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    TASettingsInfo * selectionObj = [self.arrayOfSelection objectAtIndex:section];
    return selectionObj.isSelected ? selectionObj.sectionsRowData.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TASettingsInfo * selectionObj = [self.arrayOfSelection objectAtIndex:indexPath.section];
    TAExpandableCell *expandableCell = (TAExpandableCell *)[self.settingsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    expandableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    expandableCell.backgroundColor =  [UIColor whiteColor];
    expandableCell.lbl_title.textColor =  [UIColor blackColor];
    expandableCell.arrowImageView.image = [UIImage imageNamed:@"right-arrow-small"];
    [expandableCell.seperatorLabel setHidden:NO];
    switch (indexPath.section) {
        case 0:{
            if(indexPath.section == 0 && selectionObj.isSelected){
                TASettingsNameCell *nameCell = (TASettingsNameCell *)[self.settingsTableView dequeueReusableCellWithIdentifier:nameCellIdentifier];
                nameCell.nameTextField.delegate = self;
                expandableCell.selectionStyle = UITableViewCellSelectionStyleNone;
                switch (indexPath.row) {
                    case 0:{
                        nameCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                        nameCell.nameTextField.tag = 100;
                        nameCell.nameTextField.text = [userInfo.firstNameString uppercaseString];
                        return nameCell;
                    }
                        break;
                    case 1:{
                        nameCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                        nameCell.nameTextField.tag = 101;
                        nameCell.nameTextField.text = [userInfo.lastNameString uppercaseString];
                        return nameCell;
                    }
                        break;
                    case 2 ... 12:{
                        expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                        expandableCell.arrowImageView.image = [UIImage imageNamed:@"plus"];
                        return expandableCell;
                        
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case 1:{
            //Size information
            if(indexPath.section == 1 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                expandableCell.arrowImageView.image = [UIImage imageNamed:@"plus"];
                return expandableCell;
            }
        }
            break;
        case 2:{
            //order information
            if(indexPath.section == 2 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                
                expandableCell.arrowImageView.image = [UIImage imageNamed:@"plus"];
                if ((indexPath.row == 0) || (indexPath.row == 2)) {
                    expandableCell.arrowImageView.image = [UIImage imageNamed:@"right-arrow-small"];
                }
                
                return expandableCell;
            }
        }
            break;
        case 3:{
            //sales
            if(indexPath.section == 3 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                expandableCell.arrowImageView.image = [UIImage imageNamed:@"plus"];
                if (indexPath.row == 3) {
                    expandableCell.arrowImageView.image = [UIImage imageNamed:@"right-arrow-small"];
                }
                return expandableCell;
            }
        }
            break;
        case 4:{
            //Community favour ranking
            if(indexPath.section == 4 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                return expandableCell;
            }
        }
            break;
        case 5:{
            //Events
            if(indexPath.section == 5 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                return expandableCell;
            }
        }
            break;
        case 6:{
            //Thone drops
            if(indexPath.section == 6 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                return expandableCell;
            }
        }
            break;
        case 7:{
            //Community
            if(indexPath.section == 7 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                return expandableCell;
            }
        }
            break;
        case 8:{
            //premium
            if(indexPath.section == 8 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                expandableCell.backgroundColor = [UIColor blackColor];
                expandableCell.lbl_title.textColor = [UIColor whiteColor];
                expandableCell.arrowImageView.image = [UIImage imageNamed:@"right-arrow-small-white"];
                return expandableCell;
            }
        }
            break;
        case 9:{
            //community prefrence
                if(indexPath.section == 9 && selectionObj.isSelected){
                    expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                    return expandableCell;
                }
            }
            break;
        case 10:{
            //Stay Connected
            if(indexPath.section == 10 && selectionObj.isSelected){
                TAStayConnectCell *expandableCell = (TAStayConnectCell *)[self.settingsTableView dequeueReusableCellWithIdentifier:@"TAStayConnectCell"];
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                expandableCell.connectImageView.image = [UIImage imageNamed:[@[@"facebook",@"instagram-icon-small-black",@"twitter",@"youtube_alt",@"snapchat-2-xxl"] objectAtIndex:indexPath.row]];
                return expandableCell;
            }
        }
            break;
        case 11:{
            //Privacy policy
            if(indexPath.section == 11 && selectionObj.isSelected){
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                return expandableCell;
            }
        }
            break;
        case 12:{
            //Support
            if (indexPath.section == self.arrayOfSelection.count-1 && selectionObj.isSelected) {
                expandableCell.lbl_title.text = [selectionObj.sectionsRowData objectAtIndex:indexPath.row];
                if (indexPath.row == selectionObj.sectionsRowData.count-1 ) {
                    [expandableCell.seperatorLabel setHidden:YES];
                }
                return  expandableCell;
            }
        }
            break;
            
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:
                    break;
                case 1:
                    break;
                case 2:
                    [self presentPersonalInfoPageWithType:0];
                    break;
                case 3:
                    [self presentPersonalInfoPageWithType:1];
                    break;
                case 4:
                    [self presentPersonalInfoPageWithType:2];
                    break;
                case 5:
                    [self presentPersonalInfoPageWithType:3];
                    break;
                case 6:
                    [self presentPersonalInfoPageWithType:4];
                    break;
                case 7:
                    [self presentPersonalInfoPageWithType:5];
                    break;
                case 8:
                    [self presentPersonalInfoPageWithType:6];
                    break;
                case 9:
                    [self presentPersonalInfoPageWithType:7];
                    break;
                default:
                    break;
            }
        }
            break;
            
        case 1:{
            
            switch (indexPath.row) {
                case 0:{
                    [self presentSizeInformationPageWithType:gender];
                }
                    break;
                case 1:{
                    [self presentSizeInformationPageWithType:shoeSize];
                }
                    break;
                case 2:{
                    [self presentSizeInformationPageWithType:topSize];
                }
                    break;
                default:
                    [self presentSizeInformationPageWithType:bottomSize];
                    break;
            }
        }
            break;
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    [self presentOrderWithType:order];
                }
                    break;
                case 1:{
                    [self presentOrderWithType:payment];
                }
                    break;
                case 2:{
                    [self presentOrderWithType:wallet];
                }
                    break;
                case 3:{
                    [self presentOrderWithType:shipping];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:{
            
            switch (indexPath.row) {
                case 0:{
                    [self presentTotalSalesPageWithType:sales];
                }
                    break;
                case 1:{
                    [self presentTotalSalesPageWithType:profit];
                }
                    break;
                case 2:{
                    [self presentTotalSalesPageWithType:inventory];
                }
                    break;
                case 3:{
                }
                    break;
                default:
                    [self presentTotalSalesPageWithType:analytics];
                    break;
            }
            
        }
            break;
        case 4:{
          
        }
            break;
        case 5:{
        }
            break;
        case 6:{
        }
            break;
        case 7:{
        }
            break;
        case 8:{
        }
            break;
        case 9:{
            switch (indexPath.row) {
                case 0:{
                    TANotificationsVC *notificationVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TANotificationsVC"];
                    notificationVC.titleStr = @"NOTIFICATIONS" ;
                    [self.navigationController pushViewController:notificationVC animated:YES];
                }
                    break;
                case 1:{
                    TANotificationsVC *notificationVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TANotificationsVC"];
                    notificationVC.titleStr = @"EMAIL" ;
                    [self.navigationController pushViewController:notificationVC animated:YES];
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case 10:{
                [self followingSocial:indexPath.row];
        }break;
        case 11:{
            switch (indexPath.row) {
                case 0:{
                    TANotificationsVC *notificationVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TANotificationsVC"];
                    notificationVC.titleStr = @"PUBLIC PROFILE ELEMENTS" ;
                    [self.navigationController pushViewController:notificationVC animated:YES];
                }
                    break;
                case 1:{
                    TATermsAndCondContainerVC *termsContainerVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TATermsAndCondContainerVC"];
                    [termsContainerVC setIsForPrivacy:@"privecypolicy"];
                    [self presentViewController:termsContainerVC animated:YES completion:nil];
                }
                    break;
                    
                    
                default:
                    break;
                }
        } break;
        case 12:{
            switch (indexPath.row) {
                case 0:{
                    
                    ZDKHelpCenterOverviewContentModel *helpCenterContentModel = [ZDKHelpCenterOverviewContentModel defaultContent];
                    helpCenterContentModel.hideContactSupport = YES;
                    [ZDKHelpCenter presentHelpCenterOverview:self withContentModel:helpCenterContentModel];
                }
                    break;

                case 1:{
                    //contact us
                    [ZDKRequests presentRequestCreationWithViewController:self];
                }
                    break;

                case 3:{
                    
                    [AlertController title:@"Logout!" message:@"Are you sure you want to logout?" andButtonsWithTitle:@[@"YES",@"NO"] onViewController:self dismissedWith:
                     ^(NSInteger index, NSString *buttonTitle){
                         if ([buttonTitle isEqualToString:@"YES"]) {
                             [NSUSERDEFAULT removeObjectForKey:pSpreeApiKey];
                             [NSUSERDEFAULT synchronize];
                             [self dismissViewControllerAnimated:NO completion:^{
                                 if(_delegateForSetting && [_delegateForSetting respondsToSelector:@selector(manageTheNavigation)])
                                 {
                                     [_delegateForSetting manageTheNavigation];
                                 }
                             }];
                         }
                     }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }

}

#pragma  mark - Private Method For Naviagte Respective Screen

-(void)followingSocial:(long)socialType
{
    UIApplication *myApp = UIApplication.sharedApplication;
    switch (socialType) {
        case 0:
        {
            NSURL *facebookAppURL = [NSURL URLWithString:@"fb://"];
            if ([myApp canOpenURL:facebookAppURL])
                [myApp openURL:[NSURL URLWithString:@"fb://page/?id=437163259683795"]];
            else
                [myApp openURL:[NSURL URLWithString:@"https://m.facebook.com/THRONExyz/"]];
        }
            break;
        case 1:
        {
            NSURL *instragramAppURL = [NSURL URLWithString:@"https://www.instagram.com/throne.xyz/"];
            if ([myApp canOpenURL:instragramAppURL])
                [myApp openURL:[NSURL URLWithString:@"https://www.instagram.com/throne.xyz/"]];
            else
                [myApp openURL:[NSURL URLWithString:@"https://www.instagram.com/throne.xyz/"]];
        }
            break;
        case 2:
        {
            NSURL *twitterAppURL = [NSURL URLWithString:@"https://mobile.twitter.com/thronexyz"];
            if ([myApp canOpenURL:twitterAppURL])
                [myApp openURL:[NSURL URLWithString:@"https://mobile.twitter.com/thronexyz"]];
            else
                [myApp openURL:[NSURL URLWithString:@"https://mobile.twitter.com/thronexyz"]];
        }
            break;
        case 3:
            [myApp openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCbEBhpGma8luEM79-M2ek5Q"]];
            break;
        default:{
            NSURL *snapAppURL = [NSURL URLWithString:@"https://www.snapchat.com/add/thronexyz"];
            if ([myApp canOpenURL:snapAppURL])
                [myApp openURL:[NSURL URLWithString:@"https://www.snapchat.com/add/thronexyz"]];
            else
                [myApp openURL:[NSURL URLWithString:@"https://www.snapchat.com/add/thronexyz"]];
            }
            break;
    }
}

-(void)presentTotalSalesPageWithType:(salesType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        TATotalInventoryVC *inventoryVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TATotalInventoryVC"];
        [inventoryVC setSalesType:type];
        inventoryVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [inventoryVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:inventoryVC animated:YES completion:nil];
    });

}

-(void)presentSizeInformationPageWithType:(sizeType)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        TASizeInformationVC * sizeInformationVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TASizeInformationVC"];
        [sizeInformationVC setSizeType:type];
        sizeInformationVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [sizeInformationVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:sizeInformationVC animated:YES completion:nil];
    });
}

-(void)presentPersonalInfoPageWithType:(PersonalType)type{
    
    if (type == 5) {
        dispatch_async(dispatch_get_main_queue(), ^{
            TASocialMediaVC *inventoryVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TASocialMediaVC"];
            inventoryVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [inventoryVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:inventoryVC animated:YES completion:nil];
        });
    }
    else if (type == 7 || type == 6){
    dispatch_async(dispatch_get_main_queue(), ^{
        TABioVC *obj = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TABioVC"];
        obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [obj setPersonalType:type];
        [self presentViewController:obj animated:YES completion:nil];
    });
    }
    else{
            dispatch_async(dispatch_get_main_queue(), ^{
            TAPersonalInfoVC *inventoryVC = [storyboardForName(settingStoryboardString)     instantiateViewControllerWithIdentifier:@"TAPersonalInfoVC"];
            [inventoryVC setPersonalType:type];
            inventoryVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [inventoryVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [self presentViewController:inventoryVC animated:YES completion:nil];
        });
    }
}

-(void)presentOrderWithType:(orderType)type{
    
    switch (type) {
        case 0:{
            dispatch_async(dispatch_get_main_queue(), ^{
                TAMyOrderVC *notificationVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyOrderVC"];
                [self.navigationController pushViewController:notificationVC animated:YES];
            });
        
        }
            break;
        case 1:{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                TAPaymentVC *inventoryVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TAPaymentVC"];
                inventoryVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [inventoryVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:inventoryVC animated:YES completion:nil];
        
            });
        }
            break;
        case 2:{
            dispatch_async(dispatch_get_main_queue(), ^{
                TAMyWalletVC *walletVC = [storyboardForName(purchaseStoryboardString) instantiateViewControllerWithIdentifier:@"TAMyWalletVC"];
                walletVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:walletVC];
                nav.navigationBar.hidden = YES;
                [self presentViewController:nav animated:YES completion:nil];
            });
        }
            break;
        case 3:{
            dispatch_async(dispatch_get_main_queue(), ^{
                TAShippingVC *shippingVC = [storyboardForName(settingStoryboardString) instantiateViewControllerWithIdentifier:@"TAShippingVC"];
                shippingVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                [shippingVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
                [self presentViewController:shippingVC animated:YES completion:nil];
            });
        }
            break;
            
        default:
            break;
    }
    
}
-(void)sectionTap:(UIButton *)sender{
    
    NSInteger index = sender.tag%1000;
    [self closeOpendCellWithIndex:index];
    TASettingsInfo* selectionObj = [self.arrayOfSelection objectAtIndex:index];
    selectionObj.isSelected = !selectionObj.isSelected;
    NSMutableArray * indexPathArray = [NSMutableArray array];
    for (int i = 0; i < selectionObj.sectionsRowData.count; i++) {
        [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:index]];
    }
    [self.settingsTableView beginUpdates];
    if (selectionObj.isSelected) {
        [self.settingsTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    else{
        [self.settingsTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.settingsTableView endUpdates];
    
    [self.settingsTableView reloadData];
    [self.settingsTableView scrollToRowAtIndexPath: (selectionObj.isSelected ? [NSIndexPath indexPathForRow:0 inSection:index] : nil) atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)closeOpendCellWithIndex:(NSInteger)index{
    
    for (TASettingsInfo* selectionObj in self.arrayOfSelection) {
        
        if (selectionObj.isSelected && ([self.arrayOfSelection indexOfObject:selectionObj] != index)) {
            
            selectionObj.isSelected = NO;
            NSMutableArray * indexPathArray = [NSMutableArray array];
            for (int i = 0; i < selectionObj.sectionsRowData.count; i++) {
                [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:[self.arrayOfSelection indexOfObject:selectionObj]]];
            }
            [self.settingsTableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}

@end
