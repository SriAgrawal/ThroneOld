//
//  TAOrderDetailsTableCell.m
//  Throne
//
//  Created by Krati Agarwal on 03/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAOrderDetailsTableCell.h"

@implementation TAOrderDetailsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cardImageView.layer.cornerRadius = 3.0f;
    self.cardImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
