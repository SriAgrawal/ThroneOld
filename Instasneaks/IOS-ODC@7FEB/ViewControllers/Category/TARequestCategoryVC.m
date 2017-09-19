//
//  TARequestCategoryVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 31/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TARequestCategoryVC.h"

@interface TARequestCategoryVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,navigationDelegateForThankUPopUP>{
    TARequestCategoryInfo* userInfo;
    NSInteger errorTag;
}
@property (weak, nonatomic) IBOutlet UILabel *applyLbl;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *staticHeraderLbl;

@end

@implementation TARequestCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [[TARequestCategoryInfo alloc] init];
    
    self.staticHeraderLbl.attributedText = [AppUtility customAttributeString:@"THRONE IS BUILT FOR YOU. SO FEEL FREE TO LET US KNOW WHICH OTHER TYPES OF ITEMS YOU WOULD LIKE TO EITHER BUY OR SELL ON THRONE." withAlignment:NSTextAlignmentLeft] ;
    
        NSString *applyString = @"DID WE FORGET SOMETHING?";
    
     self.applyLbl.attributedText = [NSString customAttributeString:applyString withAlignment:NSTextAlignmentLeft withLineSpacing:1 withFont:[AppUtility sofiaProBoldFontWithSize:25]];
    self.tableView.dataSource = self;
    self.tableView.delegate  = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //clear Text Fields
    userInfo.email = @"";
    userInfo.categorySuggestion = @"";
    errorTag = 0;
    [self.tableView reloadData];
    
}

#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegate and Datasource Method
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAAuthTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TAAuthTableCell" forIndexPath:indexPath];
    [cell.tableTextField  placeHolderText:[@[@"FIRST NAME",@"LAST NAME",@"EMAIL*",@"PHONE NUMBER",@"CATEGORY SUGGESTION*"] objectAtIndex:indexPath.row]];
    [cell.tableTextField setKeyboardType:UIKeyboardTypeDefault];
    cell.tableTextField.delegate = self;
    if (errorTag == indexPath.row+1) {
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
    cell.tableTextField.tag = indexPath.row + 100;
    cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.tableTextField.keyboardType = UIKeyboardTypeURL;
    switch (indexPath.row) {
        case 0:
        {
            cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
            cell.tableTextField.returnKeyType = UIReturnKeyNext;
            cell.tableTextField.text = userInfo.firstName;
            break;
        }
        case 1:
            cell.tableTextField.autocapitalizationType = UITextAutocapitalizationTypeWords;
            cell.tableTextField.keyboardType = UIKeyboardTypeASCIICapable;
            cell.tableTextField.returnKeyType = UIReturnKeyNext;
            cell.tableTextField.text = userInfo.lastName;
            break;
        case 2:
            cell.tableTextField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.tableTextField.returnKeyType = UIReturnKeyNext;
            cell.tableTextField.text = userInfo.email
            ;
            break;
        case 3:
            cell.tableTextField.keyboardType = UIKeyboardTypePhonePad;
            cell.tableTextField.inputAccessoryView = toolBarForNumberPad(self,@"NEXT");
            cell.tableTextField.text = userInfo.phoneNumber ;
            break;
        case 4:
            cell.tableTextField.keyboardType = UIKeyboardTypeDefault;
            cell.tableTextField.text = userInfo.categorySuggestion ;
            cell.tableTextField.returnKeyType = UIReturnKeyDone;
            break;
        default:
            break;
    }
    
    return  cell;
}
-(void)doneWithNumberPad:(UIBarButtonItem *)sender {
    if ([sender.title isEqualToString:@"NEXT"]) {
        UITextField *textField = [self.view viewWithTag:104];
        [textField becomeFirstResponder];
    }else
        [self.view endEditing:YES];
    
}
#pragma mark - UITextField Delegate Method


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
        case 100:
            userInfo.firstName = TRIM_SPACE(textField.text);
            break;
            
        case 101:
            userInfo.lastName = TRIM_SPACE(textField.text);
            break;
        case 102:
            userInfo.email= TRIM_SPACE(textField.text);
            break;
            
        case 103:
            userInfo.phoneNumber = TRIM_SPACE(textField.text);
            break;
        case 104:
            userInfo.categorySuggestion = TRIM_SPACE(textField.text);
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(range.location == 0) {
        if ([string hasPrefix:@" "]) {
            return NO;
        }
    }
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
            return newLength<=256;
        }
            break;
        case 103: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=14;
        }
            break;
            
        case 104: {
            if (range.length + range.location>textField.text.length) {
                return NO;
            }
            NSUInteger newLength=[textField.text length]+[string length]-range.length;
            return newLength<=256;
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark- UIButton Action Method
- (IBAction)submitBtnAction:(id)sender {
    [self.view endEditing:YES];
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([self validate]) {
        [self makeApiCallToRegisterTheCategory];
    }
}
- (IBAction)crossButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -  Validations.
- (BOOL)validate {
    
    [[TWMessageBarManager sharedInstance] hideAll];
    if ([(userInfo.firstName) length]) {
        if ([(userInfo.firstName) length] < 2) {
            errorTag = 1;
            [AlertController customAlertMessage:@Mini_FirstNAME];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else if (![userInfo.firstName isValidName]) {
            errorTag = 1;
            [AlertController customAlertMessage:@VALID_FirstNAME];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
    }  if ([(userInfo.lastName) length]) {
        if ([(userInfo.lastName) length] < 2) {
            errorTag = 2;
            [AlertController customAlertMessage:@Mini_LastNAME];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else if (![userInfo.lastName isValidName]) {
            errorTag = 2;
            [AlertController customAlertMessage:@VALID_LastNAME];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
    }
    
    if (![(userInfo.email) length]) {
        
        errorTag = 3;
        [AlertController customAlertMessage:@BLANK_EMAIL];
        [self.tableView reloadData];
        
        return NO;
    } else if (![(userInfo.email)  isValidEmail]) {
        
        errorTag = 3;
        [AlertController customAlertMessage:@VALID_EMAIL];
        [self.tableView reloadData];
        
        return NO;
    } if ([(userInfo.phoneNumber) length]) {
        if ([(userInfo.phoneNumber) length] < 10) {
            errorTag = 4;
            [AlertController customAlertMessage:@"Mobile number must be at least 10 characters."];
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            return NO;
        }
        else  if (![(userInfo.phoneNumber)  isValidPhoneNumber]) {
            errorTag = 4;
            [AlertController customAlertMessage:@VALID_PHONE];
            [self.tableView reloadData];
            
            return NO;
        }
    } if (![(userInfo.categorySuggestion) length]) {
        
        errorTag = 5;
        [AlertController customAlertMessage:@"Please enter category suggestion."];
        [self.tableView reloadData];
        
        return NO;
    }
    else {
        return YES;
    }
    return NO;
}
-(void)manageTheNavigation{
     [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Web Service Methods
-(void)makeApiCallToRegisterTheCategory{
    
    NSMutableDictionary * requestParam = [[NSMutableDictionary alloc] init];
    [requestParam setValue:userInfo.firstName forKey:pFirstName];
    [requestParam setValue:userInfo.lastName forKey:pLastName];
    [requestParam setValue:userInfo.phoneNumber forKey:pContactNumber];
    [requestParam setValue:userInfo.email forKey:pEmail];
    [requestParam setValue:userInfo.categorySuggestion forKey:@"suggestion"];
    NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
    [param setValue:requestParam forKey:@"request_category"];
    
    [[ServiceHelper helper] request:param apiName:@"category_requests" withToken:YES method:POST onViewController:self completionBlock:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UINavigationController *objNav = (UINavigationController *) [APPDELEGATE window].rootViewController;
            TAThankYouPopUpRegisterVC *obj = [[TAThankYouPopUpRegisterVC alloc]initWithNibName:@"TAThankYouPopUpRegisterVC" bundle:nil];
            obj.delegateForThankUPopUp = self;
            obj.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [obj setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
            [objNav.visibleViewController presentViewController:obj animated:YES completion:nil];
        });
    }];
}

@end
