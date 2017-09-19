//
//  TAPriceCell.h
//  Throne
//
//  Created by Priya Sharma on 17/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TAPriceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *cnewButton;
@property (strong, nonatomic) IBOutlet UIButton *usedButton;
@property (weak, nonatomic) IBOutlet TTRangeSlider *rangeSlider;

@end
