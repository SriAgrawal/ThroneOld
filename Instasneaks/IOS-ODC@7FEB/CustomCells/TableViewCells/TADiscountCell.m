//
//  TADiscountCell.m
//  Throne
//
//  Created by Anil Kumar on 06/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TADiscountCell.h"

@implementation TADiscountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    _textFieldView.layer.borderWidth = 1.0f;
    _applyBtn.layer.borderWidth = 1.0f;
    _walletCreditBtn.layer.borderWidth = 1.0f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
