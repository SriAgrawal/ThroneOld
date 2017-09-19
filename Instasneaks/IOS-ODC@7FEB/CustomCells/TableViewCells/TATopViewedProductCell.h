//
//  TATopViewedProductCell.h
//  Throne
//
//  Created by Suresh patel on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TATopViewedProductCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel        * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel        * sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel        * priceLabel;
@property (weak, nonatomic) IBOutlet UIButton       * likeButton;
@property (weak, nonatomic) IBOutlet UIButton       * buyButton;
@property (weak, nonatomic) IBOutlet UIImageView    * productImageView;

@end
