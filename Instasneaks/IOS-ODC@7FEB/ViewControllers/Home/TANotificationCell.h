//
//  TANotificationCell.h
//  Throne
//
//  Created by Anil Kumar on 04/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TANotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLblBottmConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLblTopConstraint;
@end
