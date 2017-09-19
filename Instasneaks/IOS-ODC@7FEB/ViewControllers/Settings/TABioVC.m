//
//  TAPersonalInfoVC.m
//  Throne
//
//  Created by Shridhar Agarwal on 04/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TABioVC.h"
#import "Macro.h"

@interface TABioVC (){
    NSInteger errorTag;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *viewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint     *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (weak, nonatomic) IBOutlet UILabel                *characterLabel;
@property (weak, nonatomic) IBOutlet UILabel                *navigationTitleLabel;
@property (strong, nonatomic) UserInfo                      *userDetails;

@property (nonatomic) BOOL                                  iscodeSet;
@property (nonatomic) BOOL                                  isEmailSet;
@property (nonatomic) BOOL                                  isKeyboardOn;

@end

@implementation TABioVC

#pragma mark- UIViewController Life Cycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
}

#pragma mark - Helper Methods
- (void)initialSetUp {
    
    self.navigationTitleLabel.text = (self.personalType == 6) ? @"TAGLINE" : @"BIO";
    self.characterLabel.text = (self.personalType == 6) ? @"48 CHARACTER LIMIT" : @"280 CHARACTER LIMIT";
    self.tableView.alwaysBounceVertical = NO;
    self.isEmailSet = NO;
    self.iscodeSet = NO;
    self.userDetails = [UserInfo getDefaultInfo];
    self.viewHeightConstraint.constant = 267.0;
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
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TABioCell *cell = (TABioCell *)[tableView dequeueReusableCellWithIdentifier:@"TABioCell" forIndexPath:indexPath];
    
    [cell.descriptonTextView setPlaceholderText: (self.personalType == 6) ? @"WHAT SHOULD THE WORLD KNOW ABOUT YOU?" : @"CHECK BACK SOON FAM: I'M BUILDING MY THRONE!"];
    if ([_userDetails.bio length]) {
         cell.descriptonTextView.attributedText = [NSString customAttributeString:_userDetails.bio withAlignment:NSTextAlignmentLeft withLineSpacing:4 withFont:[AppUtility sofiaProLightFontWithSize:14]];
    }
    return cell;
}

#pragma mark- Text View Delegate Method
- (void)textViewDidBeginEditing:(UITextView *)textView{

}
- (void)textViewDidEndEditing:(UITextView *)textView{
    _userDetails.bio  = textView.text;
    [self.tableView reloadData];
}
@end
