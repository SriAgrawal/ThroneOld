//
//  TAPriceCell.m
//  Throne
//
//  Created by Priya Sharma on 17/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAPriceCell.h"

@implementation TAPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.rangeSlider.minValue = 0;
    self.rangeSlider.maxValue = 1000;
    self.rangeSlider.selectedMinimum = 0;
    self.rangeSlider.selectedMaximum = 1000;
    self.rangeSlider.handleDiameter = 30;
    self.rangeSlider.handleColor = [UIColor whiteColor];
    self.rangeSlider.selectedHandleDiameterMultiplier = 1.3;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.rangeSlider.numberFormatterOverride = formatter;}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
