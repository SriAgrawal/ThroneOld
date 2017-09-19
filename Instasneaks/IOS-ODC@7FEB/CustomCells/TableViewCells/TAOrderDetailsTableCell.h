//
//  TAOrderDetailsTableCell.h
//  Throne
//
//  Created by Krati Agarwal on 03/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAOrderDetailsTableCell : UITableViewCell

// Order Section
@property (weak, nonatomic) IBOutlet UILabel    *sectionNameLabel;

// Order Detail
@property (weak, nonatomic) IBOutlet UILabel    *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel    *detailLabel;

// Shipped Detail
@property (weak, nonatomic) IBOutlet UILabel    *shippedDetailLabel;

// Billed To
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@end
