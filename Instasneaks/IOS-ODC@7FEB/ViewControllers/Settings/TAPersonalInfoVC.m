//
//  TAPersonalInfoVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 04/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAPersonalInfoVC.h"
#import "Macro.h"

@interface TAPersonalInfoVC (){
    NSInteger errorTag;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *sepratorLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *viewHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UIView                 *footerView;
@property (weak, nonatomic) IBOutlet UIView                 *tableFooterView;

@property (weak, nonatomic) IBOutlet UILabel                *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel                *navigationTitleLabel;

@property (strong, nonatomic) UserInfo                      *userDetails;

@property (strong, nonatomic) NSArray                       *textfieldPlaceholderArray;
@property (strong, nonatomic) NSMutableArray                *indexPathsArray;
@property (strong,nonatomic) NSMutableArray                 *countryCodeList;
@property (weak, nonatomic) IBOutlet UIButton *safeBtn;

@property (nonatomic) BOOL                                  iscodeSet;
@property (nonatomic) BOOL                                  isEmailSet;
@property (nonatomic) BOOL                                  isKeyboardOn;
@end

@implementation TAPersonalInfoVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countryCodeList = [[NSMutableArray alloc] init];
    [self fetchPlistCountryData];
    [self initialSetUp];
}

#pragma mark - Helper Methods

- (void)initialSetUp {
    
    self.tableView.alwaysBounceVertical = NO;
    
    self.isEmailSet = NO;
    self.iscodeSet = NO;
    
    self.userDetails = [UserInfo getDefaultInfo];
    self.indexPathsArray = [[NSMutableArray alloc] init];
    
    self.viewHeightConstraint.constant = 267.0;
    switch (self.personalType) {
        case 0:
        {
            self.textfieldPlaceholderArray = @[@"EMAIL"];
            self.navigationTitleLabel.text = @"EMAIL";
            [self.safeBtn setTitle:@"SAVE" forState:UIControlStateNormal];
        }
            break;
        case 1:
        {
           self.textfieldPlaceholderArray = @[@"WEBSITE"];
            self.navigationTitleLabel.text = @"WEBSITE";
            [self.safeBtn setTitle:@"COPY URL" forState:UIControlStateNormal];
        }
            break;
        case 2:
            self.textfieldPlaceholderArray = @[@"COUNTRY",@"STATE",@"CITY"];
            self.navigationTitleLabel.text = @"LOCATION";
            self.viewHeightConstraint.constant = 425.0;
            [self.safeBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            break;
        case 3:
            self.textfieldPlaceholderArray = @[@"PHONE"];
            self.navigationTitleLabel.text = @"PHONE";
            [self.safeBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            break;
        case 4:
            self.textfieldPlaceholderArray = @[@"OLD PASSWORD",@"NEW PASSWORD",@"CONFIRM PASSWORD"];
            self.navigationTitleLabel.text = @"PASSWORD";
            self.viewHeightConstraint.constant = 425.0;
            [self.safeBtn setTitle:@"UPDATE" forState:UIControlStateNormal];
            break;
        case 5:
            self.textfieldPlaceholderArray = @[@"OLD PASSWORD",@"NEW PASSWORD",@"CONFIRM PASSWORD"];
            self.navigationTitleLabel.text = @"SOCIAL MEDIA";
            self.viewHeightConstraint.constant = 425.0;
            [self.safeBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            break;
        case 6:
            self.textfieldPlaceholderArray = @[@"WHAT SHOULD THE WORLD KNOW ABOUT YOU?"];
            self.navigationTitleLabel.text = @"TAG LINE";
            [self.safeBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            self.characterLabel.text = @"45 CHARACTER LIMIT";
            self.viewHeightConstraint.constant = 300.0;
            self.tableView.tableFooterView = self.tableFooterView;
            break;
        case 7:
            self.textfieldPlaceholderArray = @[@"BIO"];
            self.navigationTitleLabel.text = @"BIO";
            [self.safeBtn setTitle:@"SAVE" forState:UIControlStateNormal];
            self.characterLabel.text = @"280 CHARACTER LIMIT";
            self.viewHeightConstraint.constant = 300.0;
            self.tableView.tableFooterView = self.tableFooterView;
            break;
        default:
            break;
    }
    [self tapGestureMethod];
    [self addingObserverMethod];
}

-(void)addingObserverMethod {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapGestureMethod {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    
    (_isKeyboardOn) ? [self.view endEditing:YES] : [self dismissViewControllerAnimated:YES completion:nil];
}

// Setting view bottom constraint when keyboard appears

- (void)keyboardDidShow:(NSNotification *)notification {
    
    self.viewBottomConstraint.constant = 216.0;
    [self.view setNeedsUpdateConstraints];
    _isKeyboardOn = YES;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)keyboardDidHide:(NSNotification *)notification {
    
    self.viewBottomConstraint.constant = 0.0;
    [self.view setNeedsUpdateConstraints];
    _isKeyboardOn = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

// ************* Validation method **************//

-(BOOL)validateEmailFeild {
    
    BOOL isAllValid = YES;
    
    if (![TRIM_SPACE(self.userDetails.emailString) length] || ![self.userDetails.emailString isValidEmail]) {
        
        isAllValid = NO;
        errorTag = 200;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage:![TRIM_SPACE(self.userDetails.emailString) length] ? @BLANK_EMAIL : @VALID_EMAIL];
    }

    return isAllValid;
}

-(BOOL)validatePasswordFeild {
    
    BOOL isAllValid = YES;
    
    if (![TRIM_SPACE(self.userDetails.oldPasswordString) length] || [TRIM_SPACE(self.userDetails.oldPasswordString) length] < 8 || [TRIM_SPACE(self.userDetails.oldPasswordString) length] > 30) {
        
        isAllValid = NO;
        errorTag = 200;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage: @"Please enter old password"];
    }
    else if (![TRIM_SPACE(self.userDetails.passwordString) length] || [TRIM_SPACE(self.userDetails.passwordString) length] < 8 || [TRIM_SPACE(self.userDetails.passwordString) length] > 30) {
        
        isAllValid = NO;
        errorTag = 201;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage: ![TRIM_SPACE(self.userDetails.firstTextfield) length] ? @BLANK_PASSWORD : @VALID_NEW_PASSWORD];
        
    } else if (![TRIM_SPACE(self.userDetails.confirmPasswordString) length] || ![self.userDetails.confirmPasswordString isEqualToString:self.userDetails.confirmPasswordString]) {
        isAllValid = NO;
        errorTag = 202;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage: ![TRIM_SPACE(self.userDetails.secondTextfield) length] ? @BLANK_CONFIRM_PASSWORD : @PASSWORD_CONFIRM_PASSWORD_NOT_MATCH];
    }
    return isAllValid;
}

#pragma mark- UIButton Action Method

- (IBAction)resetPasswordButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    
    if ([sender.titleLabel.text isEqualToString:@"SAVE"]) {
        
        switch (self.personalType) {
            case 0:
            {
                if ([self validateEmailFeild]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
                break;
            case 6:{
                if ([TRIM_SPACE(self.userDetails.tagLine) length]) {
                    [AlertController customAlertMessage:  @"Please enter any tag line."];
                    [self.tableView reloadData];
                }
                else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
                break;
            case 7:{
                if ([TRIM_SPACE(self.userDetails.bio) length]) {
                    [AlertController customAlertMessage:  @"Please enter any bio."];
                    [self.tableView reloadData];
                }
                else{
                [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }
                break;
            default:
                break;
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"COPY URL"]){
        if ([TRIM_SPACE(self.userDetails.webSite) length]) {
            [AlertController customAlertMessage:  @"Please enter any web site."];
            [self.tableView reloadData];
        }
        else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        
        if ([self validatePasswordFeild]){
            
            [[TWMessageBarManager sharedInstance] hideAll];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
}

- (IBAction)crossButtonAction:(id)sender {
    
    [[TWMessageBarManager sharedInstance] hideAll];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - UITableView Delegate and Datasource Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.textfieldPlaceholderArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TAAuthTableCell *forgotPasswordcell = (TAAuthTableCell *)[tableView dequeueReusableCellWithIdentifier:@"TAAuthTableCell" forIndexPath:indexPath];
    [forgotPasswordcell.tableTextField  placeHolderText:[self.textfieldPlaceholderArray objectAtIndex:indexPath.row]];
    switch (self.personalType) {
        case 0:{
            forgotPasswordcell.tableTextField.hidden = NO;
            forgotPasswordcell.phoneTextField.hidden = YES;
            forgotPasswordcell.dropDownTextField.hidden = YES;
            forgotPasswordcell.tableTextField.keyboardType = UIKeyboardTypeEmailAddress;
            forgotPasswordcell.tableTextField.text = self.userDetails.emailString;
            forgotPasswordcell.tableTextField.tag = 3000 + self.personalType;
            forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyDone;
        }
            break;
        case 1:{
            forgotPasswordcell.tableTextField.hidden = NO;
            forgotPasswordcell.phoneTextField.hidden = YES;
            forgotPasswordcell.dropDownTextField.hidden = YES;
            forgotPasswordcell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
            forgotPasswordcell.tableTextField.text = self.userDetails.webSite;
            forgotPasswordcell.tableTextField.tag = 3000 + self.personalType;
            forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyDone;
        }
            break;
        case 6:{
            forgotPasswordcell.tableTextField.hidden = NO;
            forgotPasswordcell.phoneTextField.hidden = YES;
            forgotPasswordcell.dropDownTextField.hidden = YES;
            forgotPasswordcell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
            forgotPasswordcell.tableTextField.text = self.userDetails.tagLine;
            forgotPasswordcell.tableTextField.tag = 3000 + self.personalType;
            forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyDone;
        }
            break;
        case 7:{
            forgotPasswordcell.tableTextField.hidden = NO;
            forgotPasswordcell.phoneTextField.hidden = YES;
            forgotPasswordcell.dropDownTextField.hidden = YES;
            forgotPasswordcell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
            forgotPasswordcell.tableTextField.text = self.userDetails.bio;
            forgotPasswordcell.tableTextField.tag = 3000 + self.personalType;
            forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyDone;
        }
            break;
        case 2:{
            
            forgotPasswordcell.tableTextField.hidden = YES;
            forgotPasswordcell.phoneTextField.hidden = YES;
            forgotPasswordcell.dropDownTextField.hidden = NO;
            [forgotPasswordcell.dropDownTextField  placeHolderText:[self.textfieldPlaceholderArray objectAtIndex:indexPath.row]];
            forgotPasswordcell.dropDownTextField.tag = 9000 + indexPath.row;
            forgotPasswordcell.dropDownImage.hidden = (indexPath.row == 2) ? YES : NO;
            forgotPasswordcell.dropDownTextField.returnKeyType = UIReturnKeyDone;
            if (indexPath.row == 0)
                forgotPasswordcell.dropDownTextField.text =  self.userDetails.countryString;
            else if (indexPath.row == 1)
                forgotPasswordcell.dropDownTextField.text =  self.userDetails.stateString;
            else
                forgotPasswordcell.dropDownTextField.text =  self.userDetails.cityString;
        }
            break;
        case 3:{
            
            forgotPasswordcell.tableTextField.hidden = YES;
            forgotPasswordcell.phoneTextField.hidden = NO;
            forgotPasswordcell.dropDownTextField.hidden = YES;
            [forgotPasswordcell.phoneTextField  placeHolderText:[self.textfieldPlaceholderArray objectAtIndex:indexPath.row]];
            [forgotPasswordcell.phoneTextField setFormat:@"XXX-XXX-XXXX"];
            [forgotPasswordcell.phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
            [forgotPasswordcell.phoneTextField setInputAccessoryView:toolBarForNumberPad(self,@"Done")];
            forgotPasswordcell.phoneTextField.text = self.userDetails.phoneString;
            forgotPasswordcell.phoneTextField.tag = 300;
        }
            break;
        case 4:{
            
            forgotPasswordcell.tableTextField.hidden = NO;
            forgotPasswordcell.phoneTextField.hidden = YES;
            forgotPasswordcell.dropDownTextField.hidden = YES;
            [forgotPasswordcell.tableTextField setKeyboardType:UIKeyboardTypeASCIICapable];
            forgotPasswordcell.tableTextField.secureTextEntry = YES;
            if (indexPath.row == 0) {
                forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyNext;
                forgotPasswordcell.tableTextField.text = self.userDetails.oldPasswordString;
                forgotPasswordcell.tableTextField.tag = 100;
            }
            else if (indexPath.row == 1) {
                forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyNext;
                forgotPasswordcell.tableTextField.tag = 101;
                forgotPasswordcell.tableTextField.text = self.userDetails.passwordString;
            } else {
                forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyDone;
                forgotPasswordcell.tableTextField.tag = 102;
                forgotPasswordcell.tableTextField.text = self.userDetails.confirmPasswordString;
            }
        }
            break;
            
        default:
            break;
    }
    
    if (errorTag == indexPath.row + 200) {
        forgotPasswordcell.tableTextField.backgroundColor = RGBCOLOR(254,228,228,1.0);
        forgotPasswordcell.tableTextField.textColor = [UIColor redColor];
        forgotPasswordcell.tableTextField.borderColor = [UIColor redColor];
        
    } else {
        forgotPasswordcell.tableTextField.backgroundColor = [UIColor whiteColor];
        forgotPasswordcell.tableTextField.textColor = [UIColor blackColor];
        forgotPasswordcell.tableTextField.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    
    return forgotPasswordcell;
    
}
-(void)doneWithNumberPad:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
}

#pragma mark - UITextField Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    switch (self.personalType) {
        case 2:{
            if (textField.tag == 9002)
                return YES;
            else if(textField.tag == 9001){
                [self.view endEditing:YES];
                [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:self.countryCodeList completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
                    self.userDetails.stateString = [selectedValues firstObject];
                    [self.tableView reloadData];
                }];
                return NO;
            }
            else{
                [self.view endEditing:YES];
                [[OptionPickerManager pickerManagerManager] showOptionPicker:self withData:self.countryCodeList completionBlock:^(NSArray *selectedIndexes, NSArray *selectedValues) {
                    self.userDetails.countryString = [selectedValues firstObject];
                    [self.tableView reloadData];
                }];
                return NO;
            }
        }break;
        default:
            break;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
            
        case 3000:
            self.userDetails.emailString = TRIM_SPACE(textField.text);
            break;
        case 3001:
            self.userDetails.webSite = TRIM_SPACE(textField.text);
            break;
        case 3006:
            self.userDetails.tagLine = TRIM_SPACE(textField.text);
            break;
        case 3007:
            self.userDetails.bio = TRIM_SPACE(textField.text);
            break;
        case 9002:
            self.userDetails.cityString = TRIM_SPACE(textField.text);
            break;
        case 300:
            self.userDetails.phoneString = TRIM_SPACE(textField.text);
            break;
        case 100:
            self.userDetails.oldPasswordString = TRIM_SPACE(textField.text);
            break;
        case 101:
            self.userDetails.passwordString = TRIM_SPACE(textField.text);
            break;
        case 102:
            self.userDetails.confirmPasswordString = TRIM_SPACE(textField.text);
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.view endEditing:YES];
    
    TextField *txtField = (TextField *)textField;
    
    if (txtField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    } else {
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:txtField.indexPath.row + 1];
        TAAuthTableCell *nextCell = (TAAuthTableCell *)[self.tableView cellForRowAtIndexPath:nextIndexPath];
        if (nextCell) {
            [nextCell.tableTextField becomeFirstResponder];
        }
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    [[TWMessageBarManager sharedInstance] hideAll];
    TextField *txtField = (TextField *)textField;
    if (errorTag == txtField.indexPath.row+200) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor blackColor];
        textField.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    switch (textField.tag){
        case 3000:
            return ([textField.text length] > 80 && range.length == 0)? NO : YES;
        break;
        case 3006:
                return ([textField.text length] > 45 && range.length == 0)? NO : YES;
            break;
        case 3007:
            return ([textField.text length] > 250 && range.length == 0)? NO : YES;
        break;
        case 100:
            return ([textField.text length] > 25 && range.length == 0)? NO : YES;
            break;
        case 101:
            return ([textField.text length] > 25 && range.length == 0)? NO : YES;
            break;
        case 102:
        return ([textField.text length] > 25 && range.length == 0)? NO : YES;
        break;
        default:
            return YES;
            break;
    }
    return YES;
}

-(void)fetchPlistCountryData{

    NSString *path = [[NSBundle mainBundle] pathForResource: @"BDVCountryNameAndCode" ofType: @"plist"];
    NSArray *messages = [NSArray arrayWithContentsOfFile:path];
    // Now a loop through Array to fetch single Item from catList which is Dictionary
    [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        // Fetch Single Item
        // Here obj will return a dictionary
        [self.countryCodeList addObject:[obj valueForKey:@"name"]];
    }];
}
@end
