//
//  TAInventoryCell.h
//  Throne
//
//  Created by Suresh patel on 06/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAInventoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * cellTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel * cellAmountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTitleLabelRightConstraint;

@end
