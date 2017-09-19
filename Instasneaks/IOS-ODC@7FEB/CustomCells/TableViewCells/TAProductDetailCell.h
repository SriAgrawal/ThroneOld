//
//  TAProductDetailCell.h
//  Throne
//
//  Created by Suresh patel on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
@interface TAProductDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton * conditionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptonLabelTopContraints;
@property (weak, nonatomic) IBOutlet IndexPathButton *storeNameButton;

@end
