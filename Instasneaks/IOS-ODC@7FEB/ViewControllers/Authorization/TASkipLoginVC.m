//
//  TASkipLoginVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 17/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TASkipLoginVC.h"
#import "Macro.h"

@interface TASkipLoginVC ()<TTTAttributedLabelDelegate,navigationDelegateForSignUp>{
    UserInfo* userInfo;
    NSInteger errorTag;
}

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *attributedLabel;

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *loginTableView;
@property (weak, nonatomic) IBOutlet UILabel *loginFacebookLbl;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPassword;

@property (weak, nonatomic) IBOutlet UILabel *loginLbl;


@end

@implementation TASkipLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //Initialize the Modal User Info Class
    userInfo = [[UserInfo alloc] init];
    [self setupDefaults];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //clear Text Fields
    userInfo.emailString = @"";
    userInfo.passwordString = @"";
    errorTag = 0;
    [self.loginTableView reloadData];
    
}

-(void)setupDefaults{
    
    //Facebook button Lable Manage text
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"Login with Facebook"];
    
    [attStr addAttribute: NSFontAttributeName
                   value: [AppUtility sofiaProLightFontWithSize:17]
                   range: NSMakeRange(6,4)];
    
    self.loginFacebookLbl.attributedText = attStr;
    
    self.loginLbl.attributedText = [NSString customAttributeString:self.loginLbl.text withAlignment:NSTextAlignmentLeft withLineSpacing:4 withFont:[AppUtility sofiaProLightFontWithSize:14]];
    
    //Button Highlight
    [self.loginButton setBackgroundImage:[AppUtility imageFromColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    [self.joinButton setBackgroundImage:[AppUtility imageFromColor:[UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0]] forState:UIControlStateHighlighted];
    
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
    self.attributedLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
    
    [self.attributedLabel setText:@"BY LOGGING IN, YOU AGREE TO THRONE'S PRIVACY POLICY AND TERMS OF USE" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        
        return mutableAttributedString;
    }];
    
    [self.attributedLabel addLinkToURL:[NSURL URLWithString:@"privecypolicy://"] withRange:NSMakeRange(37, 14)];
    [self.attributedLabel addLinkToURL:[NSURL URLWithString:@"termsofuse://"] withRange:NSMakeRange(56, 12)];
    
    [self.forgotPassword.titleLabel setFont:[AppUtility sofiaProLightFontWithSize:12]];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [[TWMessageBarManager sharedInstance] hideAll];
    TATermsAndCondContainerVC *termsContainerVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TATermsAndCondContainerVC"];
    [termsContainerVC setIsForPrivacy:[url.scheme isEqualToString:@"privecypolicy"]];
    [self presentViewController:termsContainerVC animated:YES completion:nil];
}


#pragma mark - UITableView Delegate and Datasource Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAAuthTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAAuthTableCell" forIndexPath:indexPath];
    [cell.tableTextField  placeHolderText:[@[@"EMAIL",@"PASSWORD"] objectAtIndex:indexPath.row]];
    cell.tableTextField.tag = indexPath.row+100;
    cell.tableTextField.returnKeyType = UIReturnKeyNext;
    
    
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
    switch (indexPath.row) {
        case 0:{
            cell.tableTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.tableTextField.text = userInfo.emailString;
        }
            break;
        case 1:{
            cell.tableTextField.secureTextEntry = YES;
            cell.tableTextField.returnKeyType = UIReturnKeyDone;
            cell.tableTextField.text = userInfo.passwordString;
        }
            break;
        default:
            break;
    }
    return  cell;
}
#pragma mark - UITextField Delegate Methode

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
        case 100:
            userInfo.emailString = TRIM_SPACE(textField.text);
            break;
            
        case 101:
            userInfo.passwordString = TRIM_SPACE(textField.text);
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
    [[TWMessageBarManager sharedInstance] hideAll];
    if (errorTag == (textField.tag+100)) {
        textField.backgroundColor = [UIColor whiteColor];
        textField.textColor = [UIColor blackColor];
        textField.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    if (textField.tag == 100)
        return ([textField.text length] > 80 && range.length == 0)? NO : YES;
    else if (textField.tag == 101)
        return ([textField.text length] > 25 && range.length == 0)? NO : YES;
    else
        return YES;
}

#pragma mark- UIButton Action Method

- (IBAction)backBtnAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)loginBtnAction:(id)sender {
    
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([self validateAndEnableLoginButton]) {
        [self makeApiCallToLoginUser];
    }
}
- (IBAction)joinThroneBtnAction:(id)sender {
    
    [[TWMessageBarManager sharedInstance] hideAll];
        TASignUpVC *signUpVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TASignUpVC"];
        signUpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        signUpVC.delegateForSignUp = self;
        [self presentViewController:signUpVC animated:YES completion:nil];
}
- (void)manageTheNavigation:(UIViewController*)isFromViewController{
    
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegateForSkipLogin && [_delegateForSkipLogin respondsToSelector:@selector(manageTheNavigationForSkip:)])
        {
            [_delegateForSkipLogin manageTheNavigationForSkip:self];
        }
    }];
    
}

- (IBAction)privacyBtnAction:(id)sender {
    
}
- (IBAction)forgotPasswordButtonAction:(id)sender {
    
    [[TWMessageBarManager sharedInstance] hideAll];
    TAForgotPasswordVC *forgotPasswordVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TAForgotPasswordVC"];
    forgotPasswordVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [forgotPasswordVC setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:forgotPasswordVC animated:YES completion:nil];
    //        [self makeApiCallToRegisterUser];
}

- (IBAction)socialLoginButton:(UIButton *)sender {
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
- (BOOL)validateAndEnableLoginButton {
    
    if (![TRIM_SPACE(userInfo.emailString) length]) {
        errorTag = 200;
        [AlertController customAlertMessage:@BLANK_EMAIL];
        [self.loginTableView reloadData];
        return NO;
    } else if (![userInfo.emailString isValidEmail]) {
        errorTag = 200;
        [AlertController customAlertMessage:@VALID_EMAIL];
        [self.loginTableView reloadData];
        return NO;
    } else if (![TRIM_SPACE(userInfo.passwordString) length]) {
        errorTag = 201;
        [AlertController customAlertMessage:@BLANK_PASSWORD];
        [self.loginTableView reloadData];
        return NO;
    } else if (([TRIM_SPACE(userInfo.passwordString) length] < 6)) {
        errorTag = 201;
        [AlertController customAlertMessage:@VALID_PASSWORD];
        [self.loginTableView reloadData];
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark - Web Service Method For Login

-(void)makeApiCallToLoginUser{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:userInfo.emailString forKey:pLoginOrEmail];
    [param setValue:userInfo.passwordString forKey:pPassword];
    NSMutableDictionary * userDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:param, pUser, nil];
    
    [[ServiceHelper helper] request:userDict apiName:kApiLogin withToken:NO method:POST onViewController:self completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pSpreeApiKey expectedObj:@""] forKey:pSpreeApiKey];
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pEmail expectedObj:@""] forKey:pEmail];
            [NSUSERDEFAULT setValue:[resultDict objectForKeyNotNull:pId expectedObj:@""] forKey:pUserId];
            [NSUSERDEFAULT setBool:YES forKey:pIsLoggedIn];
            [NSUSERDEFAULT synchronize];
            [self dismissViewControllerAnimated:NO completion:^{
                if(_delegateForSkipLogin && [_delegateForSkipLogin respondsToSelector:@selector(manageTheNavigationForSkip:)])
                {[NSUSERDEFAULT removeObjectForKey:pSkip];
                    [_delegateForSkipLogin manageTheNavigationForSkip:self];
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
                if(_delegateForSkipLogin && [_delegateForSkipLogin respondsToSelector:@selector(manageTheNavigationForSkip:)])
                {
                    [NSUSERDEFAULT removeObjectForKey:pSkip];
                    [_delegateForSkipLogin manageTheNavigationForSkip:self];
                }
            }];
        });
    }];
}

#pragma mark - Memory Handling
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
