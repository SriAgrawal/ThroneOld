//
//  TAUpgradePopupVC.m
//  Throne
//
//  Created by Aman Goswami on 07/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAUpgradePopupVC.h"

@interface TAUpgradePopupVC ()
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;
@property (strong, nonatomic) IBOutlet UIButton *upgradeBtnOutlet;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation TAUpgradePopupVC

#pragma mark -View Life Cycle.

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableAttributedString *headerText,*bodyText;
     if ( self.isfrom == YES) {
       headerText = [[NSMutableAttributedString alloc] initWithString:@"APPLY TO SELL" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaPro-Bold" size:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
      bodyText = [[NSMutableAttributedString alloc] initWithString:@"PLEASE APPLY TO SELL IN ORDER TO ACCESS THIS FEATURE." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:10], NSForegroundColorAttributeName: [UIColor blackColor]}];
         [self.upgradeBtnOutlet setTitle:@"APPLY TO SELL"  forState:UIControlStateNormal];
         self.topConstraint.constant = 21.5;
     } else {
         headerText = [[NSMutableAttributedString alloc] initWithString:@"UPGRADE TO BUSINESS" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaPro-Bold" size:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
         bodyText = [[NSMutableAttributedString alloc] initWithString:@"PLEASE UPGRADE TO A BUSINESS PROFILE IN ORDER TO ACCESS THIS FEATURE." attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:10], NSForegroundColorAttributeName: [UIColor blackColor]}];
         [self.upgradeBtnOutlet setTitle:@"UPGRADE"  forState:UIControlStateNormal];
          self.topConstraint.constant = 24.5;
     }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    [style setLineSpacing:4];
    [headerText addAttribute:NSParagraphStyleAttributeName
                      value:style
                      range:NSMakeRange(0, [headerText length])];
    [bodyText addAttribute:NSParagraphStyleAttributeName
                    value:style
                    range:NSMakeRange(0, [bodyText length])];
    self.headerLabel.attributedText = headerText;
    self.bodyLabel.attributedText = bodyText;


}
#pragma mark - Memory Management.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Button Action.
- (IBAction)crossBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)upgradeBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        if ( self.isfrom == YES) {
            if (self && self.popUp && [self.popUp respondsToSelector:@selector(dismissPopUp)]) {
                [self.popUp dismissPopUp];
            }
        } else {
            if (self && self.popUp && [self.popUp respondsToSelector:@selector(dismisPopUp)]) {
                [self.popUp dismisPopUp];
            }
        }
        

    }];
}

@end
