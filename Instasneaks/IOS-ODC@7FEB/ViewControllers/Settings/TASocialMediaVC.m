//
//  TASocialMediaVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 08/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TASocialMediaVC.h"
#import "Macro.h"

@interface TASocialMediaVC (){
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
@property (weak, nonatomic) IBOutlet UILabel *socialHeaderLbl;

@property (nonatomic) BOOL                                  iscodeSet;
@property (nonatomic) BOOL                                  isEmailSet;
@property (nonatomic) BOOL                                  isKeyboardOn;

@end

@implementation TASocialMediaVC

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
    [self.socialHeaderLbl setAttributedText:[NSString customAttributeString:self.socialHeaderLbl.text withAlignment:NSTextAlignmentLeft withLineSpacing:6 withFont:[AppUtility sofiaProLightFontWithSize:12]]];
    self.viewHeightConstraint.constant = 400.0f;
    self.textfieldPlaceholderArray = @[@"WWW.FACEBOOK.COM/",@"WWW.INSTAGRAM.COM/",@"WWW.TWITTER.COM/"];
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
#pragma mark- UIButton Action Method

- (IBAction)resetPasswordButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    TASocialTableCell *socialTableCell = (TASocialTableCell *)[tableView dequeueReusableCellWithIdentifier:@"TASocialTableCell" forIndexPath:indexPath];
    [socialTableCell.socialLbl  setText:[self.textfieldPlaceholderArray objectAtIndex:indexPath.row]];
    [socialTableCell.socialTextFeilds placeHolderText:@"USERNAME"];
    [socialTableCell.socialTextFeilds setTag:indexPath.row + 100];
    socialTableCell.socialTextFeilds.returnKeyType = UIReturnKeyNext;
    switch (indexPath.row) {
        case 0:
            socialTableCell.socialTextFeilds.text = self.userDetails.fbUrl;
            break;
        case 1:
            socialTableCell.socialTextFeilds.text = self.userDetails.instagramUrl;
            break;
        case 2:
            socialTableCell.socialTextFeilds.returnKeyType = UIReturnKeyDone;
            socialTableCell.socialTextFeilds.text = self.userDetails.twitterUrl;
            break;
        default:
            break;
    }
    
    if (errorTag == indexPath.row + 200) {
        socialTableCell.socialTextFeilds.backgroundColor = RGBCOLOR(254,228,228,1.0);
        socialTableCell.socialTextFeilds.textColor = [UIColor redColor];
        socialTableCell.socialTextFeilds.borderColor = [UIColor redColor];
        
    } else {
        socialTableCell.socialTextFeilds.backgroundColor = [UIColor whiteColor];
        socialTableCell.socialTextFeilds.textColor = [UIColor blackColor];
        socialTableCell.socialTextFeilds.borderColor = RGBCOLOR(181,181,181,1.0);
    }
    return socialTableCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - UITextField Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [textField layoutIfNeeded]; // for avoiding the bouncing of text inside textfield
    
    switch (textField.tag) {
        case 100:
            self.userDetails.fbUrl = TRIM_SPACE(textField.text);
            break;
        case 101:
            self.userDetails.instagramUrl = TRIM_SPACE(textField.text);
            break;
        case 102:
            self.userDetails.twitterUrl = TRIM_SPACE(textField.text);
            break;
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    if (textField.returnKeyType == UIReturnKeyDone) {
        [textField resignFirstResponder];
    } else {
            [textField becomeFirstResponder];
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
@end
