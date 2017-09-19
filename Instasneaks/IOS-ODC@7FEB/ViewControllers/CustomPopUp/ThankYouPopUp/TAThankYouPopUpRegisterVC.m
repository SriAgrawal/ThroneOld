//
//  TAThankYouPopUpVC.m
//  Throne
//
//  Created by Priya Sharma on 07/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAThankYouPopUpRegisterVC.h"

@interface TAThankYouPopUpRegisterVC ()
- (IBAction)crossButtonAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation TAThankYouPopUpRegisterVC

#pragma mark - UIView Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"THANKS. GIVE US SOME TIME TO REVIEW THIS, AND WE’LL SEE WHAT WE CAN DO!" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4];
    style.alignment = NSTextAlignmentLeft;
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, [attributedText length])];
    _detailLabel.attributedText = attributedText;
}

#pragma mark - Memory Management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UIButton action

- (IBAction)crossButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegateForThankUPopUp)
        {
            [_delegateForThankUPopUp manageTheNavigation];
        }
    }];
}
@end
