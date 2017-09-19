//
//  TAReferAFriendVC.m
//  Throne
//
//  Created by Priya Sharma on 19/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAReferAFriendVC.h"
#import "Macro.h"

@interface TAReferAFriendVC ()
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;
- (IBAction)crossButtonAction:(UIButton *)sender;
- (IBAction)commonButtonAction:(UIButton *)sender;

@end

@implementation TAReferAFriendVC

#pragma mark - UIView Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

#pragma mark - Initial Method

- (void)initialSetup{
    NSMutableAttributedString *moneyText = [[NSMutableAttributedString alloc] initWithString:@"DANNY LOWE JUST HOOKED YOU UP WITH $10 OFF OF YOUR FIRST ORDER." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
    NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:@"THIS CREDIT WILL EXPIRE SOON SO JOIN NOW TO REDEEM IT AND PICK UP SOME NEW GEAR!" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
      style.alignment = NSTextAlignmentCenter;
    [style setLineSpacing:7];
    [moneyText addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, [moneyText length])];
    [tagText addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, [tagText length])];
    _moneyDescLabel.attributedText = moneyText;
    _tagLabel.attributedText = tagText;
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.moneyLabel.text
                                                                                         attributes:@{NSFontAttributeName:[AppUtility sofiaProBoldFontWithSize:44]}];
    [attributedString setAttributes:@{NSFontAttributeName :[AppUtility sofiaProBoldFontWithSize:26]
                                      , NSBaselineOffsetAttributeName : @"15"} range:NSMakeRange(0, 1)];
    self.moneyLabel.attributedText = attributedString;
    
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIbutton Action

- (IBAction)crossButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)commonButtonAction:(UIButton *)sender {
    
    if (sender.tag == 10) {
        TASignUpVC *signUpVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TASignUpVC"];
        signUpVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:signUpVC animated:YES completion:nil];
        
    }else{
        TALoginVC *loginVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TALoginVC"];
        loginVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [loginVC setIsFromOnboard:YES];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
@end
