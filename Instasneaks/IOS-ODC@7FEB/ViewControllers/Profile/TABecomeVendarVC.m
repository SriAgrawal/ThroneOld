//
//  TABecomeVendarVC.m
//  Throne
//
//  Created by Suresh patel on 17/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TABecomeVendarVC.h"
#import "TAWhatDoYouSellPopUpVC.h"

@interface TABecomeVendarVC ()<UITextFieldDelegate>{
    TARequestCategoryInfo* userInfo;
    NSMutableArray *placeHolderArray,*itemArray;
    NSInteger errorTag;
}
@property (weak, nonatomic) IBOutlet UILabel *applyLbl;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *signUpTableView;
@property (weak, nonatomic) IBOutlet UILabel *staticHeraderLbl;

@end

@implementation TABecomeVendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [[TARequestCategoryInfo alloc] init];
    
    NSString *applyString = @"APPLY TO SELL ON THRONE";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:applyString];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentLeft;
    [pStyle setLineSpacing:1];
    
    [string addAttribute:NSFontAttributeName value:[AppUtility sofiaProBoldFontWithSize:25] range:NSMakeRange(0, [applyString length])];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [applyString length])];
    [_applyLbl setAttributedText:string];
    //////// Array initialization.
    self.staticHeraderLbl.attributedText = [AppUtility customAttributeString:@"WE PROVIDE ACCEPTED SELLERS WITH THE FOUNDATION, TOOLS, ACCESS, AND RESOURCES TO TAKE THEIR BUSINESS TO THE NEXT LEVEL." withAlignment:NSTextAlignmentLeft] ;
    placeHolderArray = [[NSMutableArray alloc] initWithObjects:@"FIRST NAME*",@"LAST NAME*",@" WHAT'S YOUR STORE OR BRAND NAME?*",@"EMAIL*",@"PHONE*",@"WHAT DO YOU SELL?*",@"WHERE DO YOU CURRENTLY SELL",@"IF ONLINE, PLEASE ADD SITE URL",@"STREET*",@"CITY*",@"STATE*",@"COUNTRY*",@"POSTAL CODE*",@"SOCIAL MEDIA URL",@"APPLICATION CODE", nil];
    itemArray = [[NSMutableArray alloc] initWithObjects:@"ORIGNAL APPAREL",@"SNEAKER RESELL",@"THRIFTED",@"CUSTOM SNEAKERS",@"ACCESSORIES",@"ART",@"OTHERS", nil];

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //clear Text Fields
    userInfo.storeName = @"";
    userInfo.website = @"";
    errorTag = 0;
    [self.signUpTableView reloadData];
    
}


#pragma mark - UITableView Delegate and Datasource Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return placeHolderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAAuthTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAAuthTableCell" forIndexPath:indexPath];
    [cell.tableTextField  placeHolderText:[placeHolderArray objectAtIndex:indexPath.row]];
    [cell.tableTextField setKeyboardType:UIKeyboardTypeDefault];
    
    if (errorTag == indexPath.row+100) {
        cell.tableTextField.backgroundColor = RGBCOLOR(254,228,228,1.0);
        cell.tableTextField.textColor = [UIColor redColor];
        cell.tableTextField.borderColor = [UIColor redColor];
    } else {
        cell.tableTextField.backgroundColor = [UIColor whiteColor];
        cell.tableTextField.textColor = [UIColor blackColor];
        cell.tableTextField.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    cell.tableTextField.hidden = NO;
    cell.dropDownTextField.hidden = YES;
    cell.cellButton.hidden = YES;
    cell.tableTextField.tag = indexPath.row + 100;
    cell.tableTextField.returnKeyType = UIReturnKeyNext;
    cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // if UI contains other
    if ([placeHolderArray containsObject:@"OTHERS"]) {
        switch (indexPath.row) {
            case 0: {
                cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
                cell.tableTextField.text = userInfo.firstName;
                break;
            }
            case 1: {
                cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
                cell.tableTextField.text = userInfo.lastName;
            }
                break;
            case 2:
                cell.tableTextField.text = userInfo.brandName;
                break;
            case 3: {
                cell.tableTextField.keyboardType = UIKeyboardTypeEmailAddress;
                cell.tableTextField.text = userInfo.email;
            }
                break;
            case 4:{
                cell.tableTextField.keyboardType = UIKeyboardTypePhonePad;
                cell.tableTextField.text = userInfo.phoneNumber;
            }
                break;
            case 5:{
                cell.cellButton.hidden = NO;
                cell.tableTextField.hidden = YES;
                cell.dropDownTextField.hidden = NO;
                [cell.cellButton addTarget:self action:@selector(itemToSell:) forControlEvents:UIControlEventTouchUpInside];
                cell.dropDownTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.tableTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkTextColor]}];
                cell.dropDownTextField.text = userInfo.toSell;
            }
                break;
            case 6:
            {
                cell.tableTextField.text = userInfo.other;
                break;
            }
            case 7:
            {
                cell.tableTextField.text = userInfo.currentSell;
                break;
            }
            case 8:{
                cell.tableTextField.keyboardType = UIKeyboardTypeURL;
                cell.tableTextField.text = userInfo.siteURL;
            }
                break;
            case 9:
                cell.tableTextField.text = userInfo.street;
                break;
            case 10:
                cell.tableTextField.text = userInfo.city;
                break;
            case 11:
                cell.tableTextField.text = userInfo.state;
                break;
            case 12:
                cell.tableTextField.text = userInfo.country;
                break;
            case 13:{
                cell.tableTextField.text = userInfo.postalCode;
            }
                break;
            case 14: {
                cell.tableTextField.keyboardType = UIKeyboardTypeURL;
                cell.tableTextField.text = userInfo.socialURL;
            }
                break;
            case 15:{
                cell.tableTextField.returnKeyType = UIReturnKeyDone;
                cell.tableTextField.text = userInfo.applicationCode;
            }
                break;
            case 16:{
                cell.tableTextField.returnKeyType = UIReturnKeyDone;
                cell.tableTextField.text = userInfo.applicationCode;
            }
                break;
            default:
                break;
        }

    }else{
        switch (indexPath.row) {
            case 0: {
                cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
                cell.tableTextField.text = userInfo.firstName;
                break;
            }
            case 1: {
                cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
                cell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
                cell.tableTextField.text = userInfo.lastName;
            }
                break;
            case 2:
                cell.tableTextField.text = userInfo.brandName;
                break;
            case 3: {
                cell.tableTextField.keyboardType = UIKeyboardTypeEmailAddress;
                cell.tableTextField.text = userInfo.email;
            }
                break;
            case 4:{
                cell.tableTextField.keyboardType = UIKeyboardTypePhonePad;
                cell.tableTextField.text = userInfo.phoneNumber;
            }
                break;
            case 5:{
                cell.cellButton.hidden = NO;
                cell.tableTextField.hidden = YES;
                cell.dropDownTextField.hidden = NO;
                [cell.cellButton addTarget:self action:@selector(itemToSell:) forControlEvents:UIControlEventTouchUpInside];
                cell.dropDownTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:cell.tableTextField.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkTextColor]}];
                cell.dropDownTextField.text = userInfo.toSell;
            }
                break;
            case 6:
            {
                cell.tableTextField.text = userInfo.currentSell;
                break;
            }
            case 7:{
                cell.tableTextField.keyboardType = UIKeyboardTypeURL;
                cell.tableTextField.text = userInfo.siteURL;
            }
                break;
            case 8:
                cell.tableTextField.text = userInfo.street;
                break;
            case 9:
                cell.tableTextField.text = userInfo.city;
                break;
            case 10:
                cell.tableTextField.text = userInfo.state;
                break;
            case 11:
                cell.tableTextField.text = userInfo.country;
                break;
            case 12:{
                cell.tableTextField.text = userInfo.postalCode;
            }
                break;
            case 13: {
                cell.tableTextField.keyboardType = UIKeyboardTypeURL;
                cell.tableTextField.text = userInfo.socialURL;
            }
                break;
            case 14:{
                cell.tableTextField.returnKeyType = UIReturnKeyDone;
                cell.tableTextField.text = userInfo.applicationCode;
            }
                break;
            default:
                break;
        }
 
    }
        return  cell;
}

#pragma mark - UITextField Delegate Method

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField layoutIfNeeded];     // for avoiding the bouncing of text inside textfield
    if ([placeHolderArray containsObject:@"OTHERS"]) {
        switch (textField.tag) {
            case 100:
                userInfo.firstName = TRIM_SPACE(textField.text);
                break;
            case 101:
                userInfo.lastName = TRIM_SPACE(textField.text);
                break;
            case 102:
                userInfo.brandName = textField.text;
                break;
            case 103:
                userInfo.email = TRIM_SPACE(textField.text);
                break;
            case 104:
                userInfo.phoneNumber = TRIM_SPACE(textField.text);
                break;
            case 105:
                userInfo.toSell = textField.text;
                break;
            case 106:
                userInfo.other = textField.text;
                break;
            case 107:
                userInfo.currentSell = textField.text;
                break;
            case 108:
                userInfo.siteURL = TRIM_SPACE(textField.text);
                break;
            case 109:
                userInfo.street = textField.text;
                break;
            case 110:
                userInfo.city = textField.text;
                break;
            case 111:
                userInfo.state = textField.text;
                break;
            case 112:
                userInfo.country = textField.text;
                break;
                
            case 113:
                userInfo.postalCode = textField.text ;
                break;
            case 114:
                userInfo.socialURL = textField.text;
                break;
            case 115:
                userInfo.applicationCode = textField.text;
                break;
            default:
                break;
        }
    }else{
        switch (textField.tag) {
            case 100:
                userInfo.firstName = TRIM_SPACE(textField.text);
                break;
            case 101:
                userInfo.lastName = TRIM_SPACE(textField.text);
                break;
            case 102:
                userInfo.brandName = textField.text;
                break;
            case 103:
                userInfo.email = TRIM_SPACE(textField.text);
                break;
            case 104:
                userInfo.phoneNumber = TRIM_SPACE(textField.text);
                break;
            case 105:
                userInfo.toSell = textField.text;
                break;
            case 106:
                userInfo.currentSell = textField.text;
                break;
            case 107:
                userInfo.siteURL = TRIM_SPACE(textField.text);
                break;
            case 108:
                userInfo.street = textField.text;
                break;
            case 109:
                userInfo.city = textField.text;
                break;
            case 110:
                userInfo.state = textField.text;
                break;
            case 111:
                userInfo.country = textField.text;
                break;
                
            case 112:
                userInfo.postalCode = textField.text ;
                break;
            case 113:
                userInfo.socialURL = textField.text;
                break;
            case 114:
                userInfo.applicationCode = textField.text;
                break;
            default:
                break;
        }
    }

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    TextField *txtField = (TextField *)textField;
    if (txtField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    }
    else {
        [KTextField(textField.tag+1) becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    [[TWMessageBarManager sharedInstance] hideAll];
    if (errorTag == textField.tag) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor blackColor];
        textField.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    if(range.location == 0) {
        if ([string hasPrefix:@" "]) {
            return NO;
        }
    }
    if ([placeHolderArray containsObject:@"OTHERS"]) {
        switch (textField.tag) {
            case 100: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 101: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 102: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=60;
                
            }
                break;
            case 103: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=256;
            }
                break;
                
            case 104: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=14;
            }
                break;
            case 105: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=256;
            }
                break;
                
            case 109: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 110: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
                
            case 111: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 112: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
                
            case 113: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            default:
                break;
        }
    }else{
        switch (textField.tag) {
            case 100: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 101: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 102: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=60;
                
            }
                break;
            case 103: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=256;
            }
                break;
                
            case 104: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=14;
            }
                break;
            case 105: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=256;
            }
                break;
                
            case 108: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 109: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
                
            case 110: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            case 111: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
                
            case 112: {
                if (range.length + range.location>textField.text.length) {
                    return NO;
                }
                NSUInteger newLength=[textField.text length]+[string length]-range.length;
                return newLength<=30;
            }
                break;
            default:
                break;
        }
    }

    return YES;
}

#pragma mark- UIButton Action Method
- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([self validateAndEnableSignupButton]) {
        //[self makeApiCallToRegisterVender];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)itemToSell:(UIButton *)sender {
    [self.view endEditing:YES];
   TAWhatDoYouSellPopUpVC *customAlertVC = [[TAWhatDoYouSellPopUpVC alloc] initWithNibName:@"TAWhatDoYouSellPopUpVC" bundle:nil];
    customAlertVC.delegate = self;
    if (userInfo.toSell) {
        customAlertVC.selectedString = userInfo.toSell;
    }
    customAlertVC.dataType = @"1";
    customAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:customAlertVC animated:NO completion:nil];
}

#pragma mark - Helper methods.
// handle delegate
-(void)dismissView{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)dismissViewWithData:(NSMutableArray *)selectedObj dataType:(NSString *)type{
    [self dismissViewControllerAnimated:NO completion:nil];
    NSString * selectedArrayString = [selectedObj componentsJoinedByString:@","];
    userInfo.toSell = selectedArrayString;
    NSLog(@"Selected obj ----%@",userInfo.toSell);
    if ([selectedArrayString containsString:@"OTHERS"]) {
        if ([placeHolderArray containsObject:@"OTHERS"]) {
        }else{
            [placeHolderArray insertObject:@"OTHERS" atIndex:6];
        }
    }else{
        if ([placeHolderArray containsObject:@"OTHERS"]) {
            [placeHolderArray removeObject:@"OTHERS"];
            userInfo.other = @"";
        }
    }

    [self.signUpTableView reloadData];
}
#pragma mark - Validations.
- (BOOL)validateAndEnableSignupButton {
    
    if (![(userInfo.firstName) length]) {
        errorTag = 100;
        [AlertController customAlertMessage:@BLANK_FirstNAME];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
     else if ([(userInfo.firstName) length] < 2) {
            errorTag = 100;
            [AlertController customAlertMessage:@Mini_FirstNAME];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else if (![userInfo.firstName isValidName]) {
            errorTag = 1;
            [AlertController customAlertMessage:@VALID_FirstNAME];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
    else  if (![(userInfo.lastName) length]) {
        errorTag = 101;
        [AlertController customAlertMessage:@BLANK_LastNAME];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
     else   if ([(userInfo.lastName) length] < 2) {
            errorTag = 101;
            [AlertController customAlertMessage:@Mini_LastNAME];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else if (![userInfo.lastName isValidName]) {
            errorTag = 101;
            [AlertController customAlertMessage:@VALID_LastNAME];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        } else   if (![TRIM_SPACE(userInfo.brandName) length]) {
            errorTag = 102;
            [AlertController customAlertMessage:@BLANK_STORENAME];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else if (![(userInfo.email) length]) {
        
        errorTag = 103;
        [AlertController customAlertMessage:@BLANK_EMAIL];
        [self.signUpTableView reloadData];
        
        return NO;
    } else if (![(userInfo.email)  isValidEmail]) {
        
        errorTag = 103;
        [AlertController customAlertMessage:@VALID_EMAIL];
        [self.signUpTableView reloadData];
        
        return NO;
    } else if (![(userInfo.phoneNumber) length]) {
        errorTag = 104;
        [AlertController customAlertMessage:@BLANK_PHONE];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    } else if ([(userInfo.phoneNumber) length] < 10) {
            errorTag = 104;
            [AlertController customAlertMessage:@"Mobile number must be at least 10 characters."];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else  if ([(userInfo.phoneNumber)  isValidPhoneNumber]) {
            
            errorTag = 104;
            [AlertController customAlertMessage:@VALID_PHONE];
            [self.signUpTableView reloadData];
            
            return NO;
        }   else if (![TRIM_SPACE(userInfo.toSell) length]) {
            errorTag = 105;
            [AlertController customAlertMessage:@"Please enter what you want to sell."];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
    }
        else if (![TRIM_SPACE(userInfo.street) length]) {
            errorTag = 108;
            [AlertController customAlertMessage:@"Please enter what you want to sell."];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }

        else if (![TRIM_SPACE(userInfo.city) length]) {
            errorTag = 109;
            [AlertController customAlertMessage:@BLANK_CITY];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }

        else if (![TRIM_SPACE(userInfo.state) length]) {
            errorTag = 110;
            [AlertController customAlertMessage:@BLANK_STATE];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }

        else if (![TRIM_SPACE(userInfo.country) length]) {
            errorTag = 111;
            [AlertController customAlertMessage:@BLANK_COUNTRY];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else if (![TRIM_SPACE(userInfo.postalCode) length]) {
            errorTag = 111;
            [AlertController customAlertMessage:@BLANK_ZIP];
            [self.signUpTableView reloadData];
            [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }

        else {
        return YES;
        }
    return NO;
}

#pragma mark - Web Service Method To Register Vender

-(void)makeApiCallToRegisterVender{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.storeName forKey:pName];
    [param setValue:userInfo.website forKey:pWebSite];
    [param setValue:userInfo.facebook forKey:pFacebook];
    [param setValue:userInfo.twitter forKey:pTwitter];
    [param setValue:userInfo.instagram forKey:pInstagram];
    [param setValue:userInfo.other forKey:pPaymentEmail];
    [param setValue:@"Okhla Phaese 1" forKey:pAddressOne];
    [param setValue:@"Industrial Area" forKey:pAddressTwo];
    [param setValue:@"New Delhi" forKey:pCity];
    [param setValue:@"91" forKey:pCountryId];
    [param setValue:@"DL" forKey:pStateId];
    [param setValue:@"110020" forKey:pZipCode];

    NSMutableDictionary * userDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:param, pVendorForm, nil];
    
    [[ServiceHelper helper] request:userDict apiName:kVendors_Apply withToken:YES method:PATCH onViewController:self completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
#pragma mark - Memory Handling
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
