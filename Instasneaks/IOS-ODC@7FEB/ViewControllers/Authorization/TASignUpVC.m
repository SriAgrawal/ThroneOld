//
//  TASignUpVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 21/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TASignUpVC.h"


@interface TASignUpVC ()<UITextFieldDelegate,TTTAttributedLabelDelegate,navigationDelegateForLogin>{
    UserInfo* userInfo;
     NSInteger errorTag;
}

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *attributedLabel;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *signUpTableView;
@property (weak, nonatomic) IBOutlet UILabel *staticHeraderLbl;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
 @property (weak, nonatomic) IBOutlet UILabel *loginFacebookLbl;

@end

@implementation TASignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [[UserInfo alloc] init];
    self.staticHeraderLbl.attributedText = [AppUtility customAttributeString:self.staticHeraderLbl.text withAlignment:NSTextAlignmentLeft] ;
    
    [self setUpDefaults];
}

- (void)viewWillAppear:(BOOL)animated{
    
     [super viewWillAppear:animated];
    //clear Text Fields
    userInfo.emailString = @"";
    userInfo.passwordString = @"";
    userInfo.dateOfBirthString = @"";
    userInfo.confirmPasswordString = @"";
    userInfo.firstNameString = @"";
    userInfo.lastNameString = @"";
    userInfo.emailString = @"";
    errorTag = 0;
    [self.signUpTableView reloadData];
    
}

-(void)setUpDefaults{

   
    //Facebook button Lable Manage text
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"Login with Facebook"];
    
    [attStr addAttribute: NSFontAttributeName
                   value: [AppUtility sofiaProLightFontWithSize:17]
                   range: NSMakeRange(6,4)];
    self.loginFacebookLbl.attributedText = attStr;
    
    //Button Highlight
    [self.loginButton setBackgroundImage:[AppUtility imageFromColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [self.joinButton setBackgroundImage:[AppUtility imageFromColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    
    
    
    self.attributedLabel.delegate = self;
    UIFont *f = [AppUtility sofiaProLightFontWithSize:12];
    self.attributedLabel.font = f;
    self.attributedLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.attributedLabel.lineSpacing = 8;
    self.attributedLabel.maximumLineHeight = f.lineHeight;
    self.attributedLabel.minimumLineHeight = f.lineHeight;
    self.attributedLabel.numberOfLines = 0;
    self.attributedLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    self.attributedLabel.highlightedTextColor = [UIColor whiteColor];
    self.attributedLabel.shadowColor = [UIColor colorWithWhite:0.87f alpha:1.0f];
    self.attributedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.attributedLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    [self.attributedLabel setText:@"BY CREATING AN ACCOUNT, YOU AGREE TO THRONE'S PRIVACY POLICY AND TERMS OF USE" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        return mutableAttributedString;
    }];
    
    [self.attributedLabel addLinkToURL:[NSURL URLWithString:@"privecypolicy://"] withRange:NSMakeRange(46, 14)];
    [self.attributedLabel addLinkToURL:[NSURL URLWithString:@"termsofuse://"] withRange:NSMakeRange(65, 12)];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[TWMessageBarManager sharedInstance] hideAll];
    TATermsAndCondContainerVC *termsContainerVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TATermsAndCondContainerVC"];
    [termsContainerVC setIsForPrivacy:[url.scheme isEqualToString:@"privecypolicy"]];
    [self presentViewController:termsContainerVC animated:YES completion:nil];
}

#pragma mark - Memory Handling
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate and Datasource Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAAuthTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAAuthTableCell" forIndexPath:indexPath];
    [cell.tableTextField  placeHolderText:[@[@"FIRST NAME*",@"LAST NAME*",@"EMAIL*",@"PASSWORD*",@"CONFIRM PASSWORD*",@"DATE OF BIRTH"] objectAtIndex:indexPath.row]];
    [cell.tableTextField setKeyboardType:UIKeyboardTypeDefault];
  
    cell.tableTextField.tag = indexPath.row + 100;

    if (errorTag == indexPath.row+200) {
        //[cell.tableTextField becomeFirstResponder];
        cell.tableTextField.backgroundColor = RGBCOLOR(254,228,228,1.0);
        cell.tableTextField.textColor = [UIColor redColor];
        cell.tableTextField.borderColor = [UIColor redColor];
    }
    else
    {
        cell.tableTextField.backgroundColor = [UIColor whiteColor];
        cell.tableTextField.textColor = [UIColor blackColor];
        cell.tableTextField.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    switch (indexPath.row) {
        case 0:
        {
            cell.tableTextField.text = userInfo.firstNameString;
            cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }
            break;
        case 1:
        {
            cell.tableTextField.text = userInfo.lastNameString;
            cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }
            break;
        case 2:
            cell.tableTextField.text = userInfo.emailString;
            cell.tableTextField.keyboardType = UIKeyboardTypeEmailAddress;
            break;
        case 3:
        {
            cell.tableTextField.secureTextEntry = YES;
            cell.tableTextField.text = userInfo.passwordString;
        }
            break;
        case 4:
        {
            cell.tableTextField.secureTextEntry = YES;
            cell.tableTextField.text = userInfo.confirmPasswordString;
        }
            break;
        case 5:
            cell.tableTextField.text = userInfo.dateOfBirthString;
            break;
        default:
            break;
    }

    return  cell;
}
#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 105)
    { [self.view endEditing:YES];
        errorTag = 0;
        [self showDatePickerView];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
        case 100:
            userInfo.firstNameString = TRIM_SPACE(textField.text);
            break;
            
        case 101:
            userInfo.lastNameString = TRIM_SPACE(textField.text);
            break;
        case 102:
            userInfo.emailString = TRIM_SPACE(textField.text);
            break;
            
        case 103:
            userInfo.passwordString = TRIM_SPACE(textField.text);
            break;
        case 104:
            userInfo.confirmPasswordString = TRIM_SPACE(textField.text);
            break;
        case 105:
            userInfo.dateOfBirthString = TRIM_SPACE(textField.text);
            break;
        default:
            break;
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
    if (errorTag == (textField.tag+100)) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor blackColor];
        textField.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    
    if (textField.tag == 100)
        return ([textField.text length] > 30 && range.length == 0)? NO : YES;
    else if  (textField.tag == 101)
        return ([textField.text length] > 30 && range.length == 0)? NO : YES;
   else if (textField.tag == 102)
        return ([textField.text length] > 80 && range.length == 0)? NO : YES;
    else if  (textField.tag == 103)
        return ([textField.text length] > 25 && range.length == 0)? NO : YES;
    else if  (textField.tag == 104)
        return ([textField.text length] > 25 && range.length == 0)? NO : YES;
    else
        return YES;
}
//Method for show date picker
- (void)showDatePickerView
{
     [self.view endEditing:YES];
    [[DatePickerManager dateManager] showDatePicker:self withBool:NO completionBlock:^(NSDate *date){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                //Optionally for time zone conversions
                [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
                NSString *stringFromDate = [formatter stringFromDate:date];
                userInfo.dateOfBirthString = stringFromDate;
                [self.signUpTableView reloadData];
    }];
}

#pragma mark- UIButton Action Method
- (IBAction)loginBtnAction:(id)sender {
    
    if (self.isFromOnboard) {
        
        [[TWMessageBarManager sharedInstance] hideAll];
        TALoginVC *loginVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TALoginVC"];
        loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        loginVC.delegateForLogin = self;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    else{
        [[TWMessageBarManager sharedInstance] hideAll];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backButtonAction:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)joinBtnAction:(id)sender {
    [self.view endEditing:YES];
    if ([self validateAndEnableSignupButton]) {
        [[TWMessageBarManager sharedInstance] hideAll];
//        [self dismissViewControllerAnimated:NO completion:^{
//            if(_delegateForSignUp && [_delegateForSignUp respondsToSelector:@selector(manageTheNavigation:)])
//            {
//                [_delegateForSignUp manageTheNavigation:self];
//            }
//        }];
      [self makeApiCallToRegisterUser];
    }
}


- (void)manageTheNavigation:(UIViewController*)isFromViewController{
    
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegateForSignUp && [_delegateForSignUp respondsToSelector:@selector(manageTheNavigation:)])
        {
            [_delegateForSignUp manageTheNavigation:self];
        }
    }];
    
}
- (IBAction)genderBtnAction:(UIButton *)sender {
    for (int tag = 1000; tag < 1002; tag++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:tag];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setSelected:NO];
    }
    [sender setBackgroundColor:[UIColor blackColor]];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sender setSelected:YES];
}

- (IBAction)socialSignUpBtnAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email", @"public_profile", @"user_photos", @"user_location"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            [AlertController title:@"Success." onViewController:self];
            
        } else if (result.isCancelled) {
        } else {
            
            //Getting Basic data from facebook
            [FBSDKAccessToken setCurrentAccessToken:result.token];
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:[NSDictionary dictionaryWithObject:@"id,name,first_name,last_name,gender,email,birthday,picture.width(400).height(400)" forKey:@"fields"]]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     if (!error) {
                         
                         NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
                         //                         [param setValue:[result objectForKeyNotNull:pFirstName expectedObj:@""] forKey:pFirstName];
                         //                         [param setValue:[result objectForKeyNotNull:pLastName expectedObj:@""] forKey:pLastName];
                         //                         [param setValue:[result objectForKeyNotNull:pEmail expectedObj:@""] forKey:pEmail];
                         //                         [param setValue:[result objectForKeyNotNull:pId expectedObj:@""] forKey:pUId];
                         [param setValue:[[FBSDKAccessToken currentAccessToken] tokenString] forKey:pAccessToken];
                         [param setValue:@"facebook" forKey:pProvider];
                         
                         [self makeApiCallToLoginUserWithFacebookWithInfo:param];
                     }
                 }];
            }
        }
    }];
}

// Validation Methods
- (BOOL)validateAndEnableSignupButton {
    
    [[TWMessageBarManager sharedInstance] hideAll];
    if (![(userInfo.firstNameString) length]) {
        errorTag = 200;
        [AlertController customAlertMessage:@BLANK_FirstNAME];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    else if ([(userInfo.firstNameString) length] < 2) {
        errorTag = 200;
        [AlertController customAlertMessage:@Mini_FirstNAME];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    else if (![userInfo.firstNameString isValidName]) {
        errorTag = 200;
        [AlertController customAlertMessage:@VALID_FirstNAME];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
   else if (![(userInfo.lastNameString) length]) {
       errorTag = 201;
        [AlertController customAlertMessage:@BLANK_LastNAME];
       [self.signUpTableView reloadData];
       [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
   }
   else if ([(userInfo.lastNameString) length] < 2) {
       errorTag = 201;
       [AlertController customAlertMessage:@Mini_LastNAME];
       [self.signUpTableView reloadData];
       [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
       return NO;
   }
   else if (![userInfo.lastNameString isValidName]) {
       errorTag = 201;
       [AlertController customAlertMessage:@VALID_LastNAME];
       [self.signUpTableView reloadData];
       [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
       return NO;
   }
   else if (![TRIM_SPACE(userInfo.emailString) length]) {
       errorTag = 202;
       [AlertController customAlertMessage:@BLANK_EMAIL];
       [self.signUpTableView reloadData];
       [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
       return NO;
   }
   else if (![userInfo.emailString isValidEmail]) {
       errorTag = 202;
        [AlertController customAlertMessage:@VALID_EMAIL];
       [self.signUpTableView reloadData];
       [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    } else if (![TRIM_SPACE(userInfo.passwordString) length]) {
        errorTag = 203;
        [AlertController customAlertMessage:@BLANK_PASSWORD];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    } else if (([TRIM_SPACE(userInfo.passwordString) length] < 8)) {
        errorTag = 203;
        [AlertController customAlertMessage:@VALID_PASSWORD];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    else if (![TRIM_SPACE(userInfo.confirmPasswordString) length]) {
        errorTag = 204;
        [AlertController customAlertMessage:@BLANK_CONFIRM_PASSWORD];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    } else if (!([TRIM_SPACE(userInfo.passwordString) isEqualToString:userInfo.confirmPasswordString])) {
        errorTag = 204;
        [AlertController customAlertMessage:@PASSWORD_CONFIRM_PASSWORD_NOT_MATCH];
        [self.signUpTableView reloadData];
        [self.signUpTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - Web Service Method For Signup

-(void)makeApiCallToRegisterUser{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.firstNameString forKey:pFirstName];
    [param setValue:userInfo.lastNameString forKey:pLastName];
    [param setValue:userInfo.emailString forKey:pEmail];
    [param setValue:userInfo.emailString forKey:pLogin];
    [param setValue:userInfo.passwordString forKey:pPassword];
    [param setValue:userInfo.confirmPasswordString forKey:pPasswordConfirmation];
    [param setValue:userInfo.dateOfBirthString forKey:pDateOfBirth];
    [param setValue:[self getTextForGender] forKey:pGender];
    NSMutableDictionary * userDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:param, pUser, nil];

    [[ServiceHelper helper] request:userDict apiName:kApiUsers withToken:NO method:POST onViewController:self completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pSpreeApiKey expectedObj:@""] forKey:pSpreeApiKey];
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pEmail expectedObj:@""] forKey:pEmail];
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pId expectedObj:@""] forKey:pUserId];
            [NSUSERDEFAULT setBool:YES forKey:pIsLoggedIn];
            [NSUSERDEFAULT synchronize];
            [self dismissViewControllerAnimated:NO completion:^{
                if(_delegateForSignUp && [_delegateForSignUp respondsToSelector:@selector(manageTheNavigation:)])
                {
                    [NSUSERDEFAULT removeObjectForKey:pSkip];
                    [_delegateForSignUp manageTheNavigation:self];
                }
            }];
        });
    }];
}

-(void)makeApiCallToLoginUserWithFacebookWithInfo:(NSMutableDictionary *)params{
    
    
    [[ServiceHelper helper] request:params apiName:kProvidersAuth withToken:NO method:POST onViewController:self completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pSpreeApiKey expectedObj:@""] forKey:pSpreeApiKey];
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pEmail expectedObj:@""] forKey:pEmail];
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pId expectedObj:@""] forKey:pUserId];
            [NSUSERDEFAULT setBool:YES forKey:pIsLoggedIn];
            [NSUSERDEFAULT synchronize];
            [self dismissViewControllerAnimated:NO completion:^{
                if(_delegateForSignUp && [_delegateForSignUp respondsToSelector:@selector(manageTheNavigation:)])
                {
                    [NSUSERDEFAULT removeObjectForKey:pSkip];
                    [_delegateForSignUp manageTheNavigation:self];
                }
            }];
        });
    }];
}

-(NSString *)getTextForGender{
    
    UIButton * maleButton = (UIButton *)[self.view viewWithTag:1000];
    UIButton * femaleButton = (UIButton *)[self.view viewWithTag:1001];
    
    if ([maleButton isSelected])
        return @"male";
    else if ([femaleButton isSelected])
        return @"female";
    else
        return @"";
}

@end
