//
//  TAForgotPasswordVC.m
//  Throne
//
//  Created by Krati Agarwal on 04/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAForgotPasswordVC.h"
#import "Macro.h"

@interface TAForgotPasswordVC ()<UITableViewDataSource,UITableViewDelegate> {
    NSInteger errorTag;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *sepratorLabelTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *viewHeightConstraint;

@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UIView                 *footerView;

@property (weak, nonatomic) IBOutlet UILabel                *label;
@property (weak, nonatomic) IBOutlet UILabel                *navigationTitleLabel;

@property (strong, nonatomic) UserInfo                      *userDetails;

@property (strong, nonatomic) NSArray                       *textfieldPlaceholderArray;
@property (strong, nonatomic) NSMutableArray                *indexPathsArray;

@property (nonatomic) BOOL                                  iscodeSet;
@property (nonatomic) BOOL                                  isEmailSet;
@property (nonatomic) BOOL                                  isKeyboardOn;

@end

@implementation TAForgotPasswordVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Helper Methods

- (void)initialSetUp {
    
    self.tableView.alwaysBounceVertical = NO;
    
    self.isEmailSet = NO;
    self.iscodeSet = NO;
    
    self.userDetails = [UserInfo getDefaultInfo];
    self.indexPathsArray = [[NSMutableArray alloc] init];

    self.textfieldPlaceholderArray = @[@"EMAIL"];
    self.viewHeightConstraint.constant = 330.0;
    [self tapGestureMethod];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"WE WILL SEND YOU AN EMAIL WITH A UNIQUE CODE TO RESET YOUR PASSWORD"];
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    pStyle.alignment = NSTextAlignmentLeft;
    [pStyle setLineSpacing:8];
    [string addAttribute:NSFontAttributeName value:[AppUtility sofiaProLightFontWithSize:12] range:NSMakeRange(0, [@"WE WILL SEND YOU AN EMAIL WITH A UNIQUE CODE TO RESET YOUR PASSWORD" length])];
    [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [@"WE WILL SEND YOU AN EMAIL WITH A UNIQUE CODE TO RESET YOUR PASSWORD" length])];
    self.label.attributedText =  string;
 
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
    (_isKeyboardOn) ? [self.view endEditing:YES] :  [self dismissViewControllerAnimated:YES completion:nil];
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
    
    if (![TRIM_SPACE(self.userDetails.firstTextfield) length] || ![self.userDetails.firstTextfield isValidEmail]) {
        
        isAllValid = NO;
        errorTag = 200;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage:![TRIM_SPACE(self.userDetails.firstTextfield) length] ? @BLANK_EMAIL : @VALID_EMAIL];
    }
    return isAllValid;
    
}

-(BOOL)validatePasswordFeild {
    
    BOOL isAllValid = YES;
    
    
    if (![TRIM_SPACE(self.userDetails.accessCodeString) length]) {
        
        isAllValid = NO;
        errorTag = 200;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage: @"Please enter code."];
    }
   else if (![TRIM_SPACE(self.userDetails.firstTextfield) length] || [TRIM_SPACE(self.userDetails.firstTextfield) length] < 8 || [TRIM_SPACE(self.userDetails.firstTextfield) length] > 30) {
        
        isAllValid = NO;
        errorTag = 201;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage: ![TRIM_SPACE(self.userDetails.firstTextfield) length] ? @BLANK_PASSWORD : @VALID_NEW_PASSWORD];
        
    } else if (![TRIM_SPACE(self.userDetails.secondTextfield) length] || ![self.userDetails.firstTextfield isEqualToString:self.userDetails.secondTextfield]) {
        
        isAllValid = NO;
        errorTag = 202;
        [self.tableView reloadData];
        
        [AlertController customAlertMessage: ![TRIM_SPACE(self.userDetails.secondTextfield) length] ? @BLANK_CONFIRM_PASSWORD : @PASSWORD_CONFIRM_PASSWORD_NOT_MATCH];
    }
    
    return isAllValid;
    
}

#pragma mark- UIButton Action Method

- (IBAction)resetPasswordButtonAction:(id)sender {
    
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    
    if (!self.isEmailSet) {
        
        if ([self validateEmailFeild]) {
            
            [self makeApiCallToForgotPassword];
        }
   }
        else {
        
        if ([self validatePasswordFeild]){
            
            [[TWMessageBarManager sharedInstance] hideAll];
            [self makeApiCallToResetPassword];
//            [self dismissViewControllerAnimated:YES completion:nil];
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
    return 64.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TAAuthTableCell *forgotPasswordcell = (TAAuthTableCell *)[tableView dequeueReusableCellWithIdentifier:@"TAAuthTableCell" forIndexPath:indexPath];
    
        [forgotPasswordcell.tableTextField  placeHolderText:[self.textfieldPlaceholderArray objectAtIndex:indexPath.row]];

        forgotPasswordcell.tableTextField.text = self.userDetails.firstTextfield;
    [forgotPasswordcell.tableTextField setIndexPath:indexPath];
    
    if (!self.isEmailSet) {
        
        forgotPasswordcell.tableTextField.keyboardType = UIKeyboardTypeEmailAddress;
        forgotPasswordcell.tableTextField.text = self.userDetails.firstTextfield;
        forgotPasswordcell.tableTextField.tag = 300;
        forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyDone;

    }
    else {
        
        [forgotPasswordcell.tableTextField setKeyboardType:UIKeyboardTypeASCIICapable];
        forgotPasswordcell.tableTextField.secureTextEntry = YES;
        
        if (indexPath.row == 0) {
            (forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyNext);
            forgotPasswordcell.tableTextField.secureTextEntry = NO;
            forgotPasswordcell.tableTextField.tag = 100;
            forgotPasswordcell.tableTextField.text = self.userDetails.accessCodeString;
            
        }
        else if (indexPath.row == 1) {
            (forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyNext);
            forgotPasswordcell.tableTextField.tag = 101;
            forgotPasswordcell.tableTextField.text = self.userDetails.firstTextfield;

        } else {
            (forgotPasswordcell.tableTextField.returnKeyType = UIReturnKeyDone);
            forgotPasswordcell.tableTextField.tag = 102;
            forgotPasswordcell.tableTextField.text = self.userDetails.secondTextfield;
        }
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

#pragma mark - UITextField Delegate Method



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
       return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    TextField *txtField = (TextField *)textField;
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (txtField.indexPath.row) {
            
        case 0:
            {
                if (textField.tag == 100)
                    self.userDetails.accessCodeString = TRIM_SPACE(textField.text);
                else
                    self.userDetails.firstTextfield = TRIM_SPACE(textField.text);
            }
            break;
        case 1:
            self.userDetails.firstTextfield = TRIM_SPACE(textField.text);
            break;
        case 2:
            self.userDetails.secondTextfield = TRIM_SPACE(textField.text);
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
    switch (txtField.indexPath.row) {
        case 0:
        {
            if (textField.tag == 100)
                return YES;
            else
                return ([textField.text length] > 80 && range.length == 0)? NO : YES;
        }
            break;
        case 1:
            return ([textField.text length] > 25 && range.length == 0)? NO : YES;
            break;
        case 2:
             return ([textField.text length] > 25 && range.length == 0)? NO : YES;
            break;
        default:
            return YES;
            break;
    }
}

#pragma mark - API methods

- (void)callApiForCodeCheck {
    
    self.navigationTitleLabel.text = @"NEW PASSWORD";
    self.viewHeightConstraint.constant = 450.0;
    [self.indexPathsArray removeAllObjects];
    [self.tableView beginUpdates];
    errorTag = 1000;

    [self.indexPathsArray addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:self.indexPathsArray withRowAnimation:UITableViewRowAnimationFade];

    for (int i = 0; i <= 2; i++)
        [self.indexPathsArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    
    self.textfieldPlaceholderArray = @[@"ENTER CODE",@"NEW PASSWORD",@"CONFIRM PASSWORD"];
    
    [self.tableView insertRowsAtIndexPaths:self.indexPathsArray withRowAnimation:(UITableViewRowAnimationFade)];

    self.userDetails = [UserInfo getDefaultInfo];

    [self.tableView endUpdates];
}

#pragma mark - Web Service Method To Reset Password

-(void)makeApiCallToForgotPassword{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:[NSDictionary dictionaryWithObjectsAndKeys:self.userDetails.firstTextfield, pEmail, nil] forKey:pUser];
    [[ServiceHelper helper] request:param apiName:kResetPasswordInstruction withToken:NO method:POST onViewController:self completionBlock:^(NSDictionary *resultDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            self.isEmailSet = YES;
            [[TWMessageBarManager sharedInstance] hideAll];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"ENTER THE UNIQUE CODE WE PROVIDED IN THE REST PASSWORD EMAIL YOU SHOULD HAVE RECIEVED"];
            NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
            pStyle.alignment = NSTextAlignmentLeft;
            [pStyle setLineSpacing:8];
            [string addAttribute:NSFontAttributeName value:[AppUtility sofiaProLightFontWithSize:12] range:NSMakeRange(0, [@"ENTER THE UNIQUE CODE WE PROVIDED IN THE REST PASSWORD EMAIL YOU SHOULD HAVE RECIEVED" length])];
            [string addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [@"ENTER THE UNIQUE CODE WE PROVIDED IN THE REST PASSWORD EMAIL YOU SHOULD HAVE RECIEVED" length])];
            self.label.attributedText =  string;
            [self callApiForCodeCheck];

            NSDictionary * dict = [resultDict objectForKeyNotNull:pUser expectedObj:[NSDictionary new]];
            [NSUSERDEFAULT setValue:[dict objectForKeyNotNull:pSpreeApiKey expectedObj:@""] forKey:pSpreeApiKey];
            [NSUSERDEFAULT synchronize];
            [AlertController message:@"The reset password instruction is sent to the given email address. Check your email now please." onViewController:self];
        });
    }];
}

-(void)makeApiCallToResetPassword{
    
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:self.userDetails.firstTextfield forKey:pPassword];
    [param setValue:self.userDetails.secondTextfield forKey:pPasswordConfirmation];
    [param setValue:self.userDetails.accessCodeString forKey:pResetPasswordToken];
    
    NSMutableDictionary * userParam = [[NSMutableDictionary alloc] init];
    [userParam setValue:param forKey:pUser];

    [[ServiceHelper helper] request:userParam apiName:kResetPassword withToken:NO method:PATCH onViewController:self completionBlock:^(NSDictionary *resultDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
