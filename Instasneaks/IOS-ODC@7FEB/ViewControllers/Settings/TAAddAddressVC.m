//
//  TAAddAddressVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 08/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAAddAddressVC.h"
#import "Macro.h"

@interface TAAddAddressVC ()<UITextFieldDelegate>
{
    NSInteger errorTag;
    
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *headerLbl;
- (IBAction)continueButtonAction:(UIButton *)sender;
@property (strong, nonatomic) UserInfo *userDetails;
- (IBAction)collapseButtonAction:(UIButton *)sender;
@end

@implementation TAAddAddressVC
#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma mark - Initial Setup

- (void)initialSetup{
    _userDetails = [[UserInfo alloc]init];
    
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
    return  5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TASingleTextFieldTVC *singlecell = (TASingleTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TASingleTextFieldTVC"];
    TATwoTextFieldTVC *doublecell = (TATwoTextFieldTVC *)[tableView dequeueReusableCellWithIdentifier:@"TATwoTextFieldTVC"];
    
    doublecell.firstTextField.delegate = self;
    doublecell.secondTextField.delegate = self;
    singlecell.singleTextField.delegate = self;
    
    [doublecell.firstTextField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [doublecell.secondTextField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
    [singlecell.singleTextField setValue:[UIColor blackColor] forKeyPath:@"_placeholderLabel.textColor"];
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
            singlecell.singleTextField.placeholder = @"STREET*";
            singlecell.singleTextField.text = _userDetails.streetString;
            singlecell.singleTextField.returnKeyType = UIReturnKeyNext;
            singlecell.singleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            return singlecell;
        }
            break;
            
        case 2:
        {
            singlecell.singleTextField.tag = 103;
            singlecell.singleTextField.placeholder = @"STREET ADDRESS 2";
            singlecell.singleTextField.text = _userDetails.streetAddress2String;
            singlecell.singleTextField.returnKeyType = UIReturnKeyNext;
            singlecell.singleTextField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
            return singlecell;
        }
            break;
            
        case 3:
        {
            doublecell.firstTextField.tag = 104;
            doublecell.secondTextField.tag = 105;
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
            
        case 4:
        {
            doublecell.firstTextField.tag = 106;
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
        [self.tableView reloadData];
        return NO;
    }
    else if ([TRIM_SPACE(_userDetails.firstNameString) length] < 2) {
        errorTag = 200;
        [AlertController customAlertMessage:@Mini_FirstNAME];
        [self.tableView reloadData];
        return NO;
    }
    else if (![_userDetails.firstNameString isValidName]) {
        errorTag = 201;
        [AlertController customAlertMessage:@VALID_FirstNAME];
        [self.tableView reloadData];
        return NO;
    }else if (![TRIM_SPACE(_userDetails.lastNameString) length]) {
        errorTag = 201;
        [AlertController customAlertMessage:@BLANK_LastNAME];
        [self.tableView reloadData];
        return NO;
    }else if ([TRIM_SPACE(_userDetails.lastNameString) length] < 2) {
        errorTag = 201;
        [AlertController customAlertMessage:@Mini_LastNAME];
        [self.tableView reloadData];
        return NO;
    }else if (![_userDetails.lastNameString isValidName]) {
        errorTag = 201;
        [AlertController customAlertMessage:@VALID_LastNAME];
        [self.tableView reloadData];
        return NO;
    }
    else if (!([TRIM_SPACE(_userDetails.streetString) length] )) {
        errorTag = 202;
        [AlertController customAlertMessage:@STREET_ADDRESS];
        [self.tableView reloadData];
        return NO;
    } else if (!([TRIM_SPACE(_userDetails.cityString) length] )) {
        errorTag = 204;
        [AlertController customAlertMessage:@BLANK_CITY];
        [self.tableView reloadData];
        return NO;
    }else if (!([TRIM_SPACE(_userDetails.stateString) length] )) {
        errorTag = 205;
        [AlertController customAlertMessage:@BLANK_STATE];
        [self.tableView reloadData];
        return NO;
    }else if (!([TRIM_SPACE(_userDetails.zipCodeString) length] )) {
        errorTag = 206;
        [AlertController customAlertMessage:@BLANK_ZIP];
        [self.tableView reloadData];
        return NO;
    }
    else if (([TRIM_SPACE(_userDetails.zipCodeString) length] ) < 5) {
        errorTag = 206;
        [AlertController customAlertMessage:@Valid_ZIP];
        [self.tableView reloadData];
        return NO;
    }
    else {
        return YES;
    }
}


-(NSMutableAttributedString *)UnderLineTextString:(NSString *)str
                                        withStart:(NSUInteger)start andWithEnd:(NSUInteger)end{
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [titleString addAttribute:NSFontAttributeName value:[AppUtility sofiaProLightFontWithSize:14] range:NSMakeRange(start, end)];// set your text lenght..
    
    return titleString;
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
            _userDetails.streetString = TRIM_SPACE(textField.text);
            break;
        case 103:
            _userDetails.streetAddress2String = TRIM_SPACE(textField.text);
            break;
        case 104:
            _userDetails.cityString = TRIM_SPACE(textField.text);
            break;
        case 105:
            _userDetails.stateString = TRIM_SPACE(textField.text);
            break;
        case 106:
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
        return ([textField.text length] > 30 && range.length == 0)? NO : YES;
    else if (textField.tag == 101)
        return ([textField.text length] > 30 && range.length == 0)? NO : YES;
    else if (textField.tag == 102)
        return ([textField.text length] > 70 && range.length == 0)? NO : YES;
    else if (textField.tag == 103)
        return ([textField.text length] > 40 && range.length == 0)? NO : YES;
    else if (textField.tag == 104)
        return ([textField.text length] > 20 && range.length == 0)? NO : YES;
    else if (textField.tag == 105)
        return ([textField.text length] > 20 && range.length == 0)? NO : YES;
    else if (textField.tag == 106)
        return ([textField.text length] > 10 && range.length == 0)? NO : YES;
    else
        return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 106) {
        [textField setInputAccessoryView:toolBarForNumberPad(self,@"Done")];
    }else {
        [textField setInputAccessoryView:nil];
    }
}

-(void)doneWithNumberPad:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    
}

#pragma mark - UIButton Action

- (IBAction)continueButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([self validateAndEnableLoginButton]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        for (int tag = 100; tag <= 106; tag++) {
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


- (IBAction)collapseButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
