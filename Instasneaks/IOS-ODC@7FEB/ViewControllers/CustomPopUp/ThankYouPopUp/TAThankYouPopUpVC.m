//
//  TAThankYouPopUpVC.m
//  Throne
//
//  Created by Priya Sharma on 07/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAThankYouPopUpVC.h"

@interface TAThankYouPopUpVC ()
- (IBAction)crossButtonAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation TAThankYouPopUpVC

#pragma mark - UIView Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"WE HAVE SENT YOU AN EMAIL WITH DETAILS FOR ORDER NO. TI00562626262." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    style.alignment = NSTextAlignmentCenter;
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
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)viewMyOrderAction:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
        if(_delegateForProduct)
        {
            [_delegateForProduct manageTheNavigation];
        }
    }];
}

@end
