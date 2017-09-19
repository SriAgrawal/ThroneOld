//
//  TANotificationCell.m
//  Throne
//
//  Created by Anil Kumar on 04/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TANotificationCell.h"
#import "Macro.h"

@implementation TANotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _switchBtn.transform = CGAffineTransformMakeScale(0.98, 0.98);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
