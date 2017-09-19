//
//  TACreditCardVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 08/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TACreditCardVC.h"
#import "Macro.h"

@interface TACreditCardVC ()<UITextFieldDelegate>
{
    NSInteger errorTag;
}

@property (strong, nonatomic) UserInfo *userDetails;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)collapseButtonAction:(UIButton *)sender;
- (IBAction)continueButtonAction:(UIButton *)sender;
@end

@implementation TACreditCardVC


#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDetails = [[UserInfo alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TableView delegates and datsource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TASingleTextFieldTVC *singlecell = (TASingleTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASingleTextFieldTVC"];
    TATwoTextFieldTVC *doublecell = (TATwoTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TATwoTextFieldTVC"];
    
    doublecell.firstTextField.delegate = self;
    doublecell.secondTextField.delegate = self;
    singlecell.singleTextField.delegate = self;
    
    
    singlecell.singleTextField.paddingValue = 15;
    doublecell.firstTextField.paddingValue  = 15;
    doublecell.secondTextField.paddingValue = 15;
    
    switch (indexPath.row) {
        case 0:
        {
            doublecell.firstTextField.tag = 100;
            doublecell.secondTextField.tag = 101;
            doublecell.firstTextField.placeholder = @"FIRST NAME*";
            doublecell.secondTextField.placeholder = @"LAST NAME*";
            doublecell.firstTextField.text = _userDetails.firstNameString;
            doublecell.secondTextField.text = _userDetails.lastNameString;
            doublecell.firstTextField.returnKeyType = UIReturnKeyNext;
            doublecell.secondTextField.returnKeyType = UIReturnKeyNext;
            
            doublecell.firstTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            doublecell.secondTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            
            
            return doublecell;
        }
            break;
            
        case 1:
        {
            singlecell.singleTextField.tag = 102;
            singlecell.singleTextField.placeholder = @"CARD NUMBER*";
            singlecell.singleTextField.text = _userDetails.cardNumber;
            singlecell.singleTextField.returnKeyType = UIReturnKeyNext;
            singlecell.singleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            singlecell.singleTextField.keyboardType = UIKeyboardTypeNumberPad;
            return singlecell;
        }
            break;
            
        case 2:
        {
            doublecell.firstTextField.tag = 103;
            doublecell.secondTextField.tag = 104;
            doublecell.firstTextField.placeholder = @"EXPIRATION*";
            doublecell.secondTextField.placeholder = @"CVV*";
            doublecell.firstTextField.text = _userDetails.expiry;
            doublecell.secondTextField.text = _userDetails.CVV;
            doublecell.firstTextField.returnKeyType = UIReturnKeyNext;
            doublecell.secondTextField.returnKeyType = UIReturnKeyNext;
            
            doublecell.firstTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            doublecell.secondTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            doublecell.secondTextField.keyboardType = UIKeyboardTypeNumberPad;
            return doublecell;
        }
            break;
            
        case 3:
        {
            singlecell.singleTextField.tag = 105;
            singlecell.singleTextField.placeholder = @"STREET*";
            singlecell.singleTextField.text = _userDetails.streetString;
            singlecell.singleTextField.returnKeyType = UIReturnKeyNext;
            singlecell.singleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            return singlecell;
        }
            break;
            
            
        case 4:
        {
            singlecell.singleTextField.tag = 106;
            singlecell.singleTextField.placeholder = @"STREET 2";
            singlecell.singleTextField.text = _userDetails.streetAddress2String;
            singlecell.singleTextField.returnKeyType = UIReturnKeyNext;
            singlecell.singleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            return singlecell;
        }
            break;
            
        case 5:
        {
            doublecell.firstTextField.tag = 107;
            doublecell.secondTextField.tag = 108;
            doublecell.firstTextField.placeholder = @"CITY*";
            doublecell.secondTextField.placeholder = @"STATE*";
            
            doublecell.firstTextField.text = _userDetails.cityString;
            doublecell.secondTextField.text = _userDetails.stateString;
            
            doublecell.firstTextField.returnKeyType = UIReturnKeyNext;
            doublecell.secondTextField.returnKeyType = UIReturnKeyNext;
            
            doublecell.firstTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            doublecell.secondTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            return doublecell;
        }
            break;
            
        case 6:
        {
            doublecell.firstTextField.tag = 109;
            doublecell.firstTextField.placeholder = @"ZIP*";
            doublecell.firstTextField.text = _userDetails.zipCodeString;
            doublecell.firstTextField.returnKeyType = UIReturnKeyDone;
            
            doublecell.secondTextField.hidden = YES;
            doublecell.firstTextField.keyboardType = UIKeyboardTypeNumberPad;
            return doublecell;
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mrk - Helper Method

- (BOOL)validateAndEnableLoginButton {
    
    if (![TRIM_SPACE(_userDetails.firstNameString) length]) {
        errorTag = 200;
        [AlertController customAlertMessage:@BLANK_FirstNAME];
        return NO;
    }  else if (![TRIM_SPACE(_userDetails.lastNameString) length]) {
        errorTag = 201;
        [AlertController customAlertMessage:@BLANK_LastNAME];
        return NO;
    }else if (![TRIM_SPACE(_userDetails.cardNumber) length]) {
        errorTag = 202;
        [AlertController customAlertMessage:@BLANK_CARDNO];
        return NO;
    }else if (![TRIM_SPACE(_userDetails.expiry) length]) {
        errorTag = 203;
        [AlertController customAlertMessage:@BLANK_EXPIRY];
        return NO;
    }else if (!([TRIM_SPACE(_userDetails.CVV) length] )) {
        errorTag = 204;
        [AlertController customAlertMessage:@BLANK_CVV];
        return NO;
    } else if (!([TRIM_SPACE(_userDetails.streetString) length] )) {
        errorTag = 205;
        [AlertController customAlertMessage:@STREET_ADDRESS];
        return NO;
    } else if (!([TRIM_SPACE(_userDetails.cityString) length] )) {
        errorTag = 207;
        [AlertController customAlertMessage:@BLANK_CITY];
        return NO;
    }else if (!([TRIM_SPACE(_userDetails.stateString) length] )) {
        errorTag = 208;
        [AlertController customAlertMessage:@BLANK_STATE];
        return NO;
    }else if (!([TRIM_SPACE(_userDetails.zipCodeString) length] )) {
        errorTag = 209;
        [AlertController customAlertMessage:@BLANK_ZIP];
        return NO;
    }
    else {
        return YES;
    }
}


//Method for show date picker
- (void)showDatePickerView
{
    [self.view endEditing:YES];
    [[DatePickerManager dateManager] showDatePicker:self withBool:YES completionBlock:^(NSDate *date){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/yy"];
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        NSString *stringFromDate = [formatter stringFromDate:date];
        _userDetails.expiry = stringFromDate;
        [self.tableView reloadData];
    }];
}


#pragma mark - UITextField Delegate Methode

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
        case 100:
            _userDetails.firstNameString = TRIM_SPACE(textField.text);
            break;
        case 101:
            _userDetails.lastNameString = TRIM_SPACE(textField.text);
            break;
        case 102:
            _userDetails.cardNumber = TRIM_SPACE(textField.text);
            break;
        case 103:
            _userDetails.expiry = TRIM_SPACE(textField.text);
            break;
        case 104:
            _userDetails.CVV = TRIM_SPACE(textField.text);
            break;
        case 105:
            _userDetails.streetString = TRIM_SPACE(textField.text);
            break;
        case 106:
            _userDetails.streetAddress2String = TRIM_SPACE(textField.text);
            break;
        case 107:
            _userDetails.cityString = TRIM_SPACE(textField.text);
            break;
        case 108:
            _userDetails.stateString = TRIM_SPACE(textField.text);
            break;
        case 109:
            _userDetails.zipCodeString = TRIM_SPACE(textField.text);
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    TextField *txtField = (TextField *)textField;
    
    if (txtField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    } else {
        [KTextField(textField.tag+1) becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString* )string {
    if (textField.tag == 100)
        return ([textField.text length] > 20 && range.length == 0)? NO : YES;
    else if (textField.tag == 101)
        return ([textField.text length] > 20 && range.length == 0)? NO : YES;
    else if (textField.tag == 102)
        return ([textField.text length] > 18 && range.length == 0)? NO : YES;
    else if (textField.tag == 104)
        return ([textField.text length] > 3 && range.length == 0)? NO : YES;
    else if (textField.tag == 105)
        return ([textField.text length] > 20 && range.length == 0)? NO : YES;
    else if (textField.tag == 106)
        return ([textField.text length] > 40 && range.length == 0)? NO : YES;
    else if (textField.tag == 107)
        return ([textField.text length] > 15 && range.length == 0)? NO : YES;
    else if (textField.tag == 108)
        return ([textField.text length] > 15 && range.length == 0)? NO : YES;
    else if (textField.tag == 109)
        return ([textField.text length] > 15 && range.length == 0)? NO : YES;
    else
        return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 102) {
        [textField setInputAccessoryView:toolBarForNumberPad(self,@"Next")];
    }else if (textField.tag == 109) {
        [textField setInputAccessoryView:toolBarForNumberPad(self,@"Done")];
    }else {
        [textField setInputAccessoryView:nil];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 103){
        [self.view endEditing:YES];
        [self showDatePickerView];
        return NO;
    }
    return YES;
}

-(void)doneWithNumberPad:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"Next"]) {
        UITextField *textField = [self.view viewWithTag:103];
        [textField becomeFirstResponder];
    }else
        [self.view endEditing:YES];
}

#pragma mark - UIButton Action

- (IBAction)collapseButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)continueButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([self validateAndEnableLoginButton]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        for (int tag = 100; tag <= 109; tag++) {
            UITextField *text = (UITextField *)[self.view viewWithTag:tag];
            text.backgroundColor = [UIColor whiteColor];
            text.textColor = [UIColor blackColor];
            text.borderColor = RGBCOLOR(181,181,181,1.0);
        }
        if (errorTag) {
            UITextField *text = (UITextField *)[self.view viewWithTag:errorTag-100];
            text.backgroundColor = RGBCOLOR(254,228,228,1.0);
            text.textColor = [UIColor redColor];
            text.borderColor = [UIColor redColor];
        }
    }
}
@end
