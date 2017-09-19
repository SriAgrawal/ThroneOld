//
//  TAshippingMethodTVC.m
//  Throne
//
//  Created by Priya Sharma on 10/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAshippingMethodTVC.h"

@implementation TAshippingMethodTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:@"1645 VINE ST. #808 LOS ANGELES, CA 90028 USA" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"SofiaProLight" size:14], NSForegroundColorAttributeName: [UIColor blackColor]}];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, [attributedText length])];
    _addressLabel.attributedText = attributedText;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (IBAction)checkMarkButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
@end
