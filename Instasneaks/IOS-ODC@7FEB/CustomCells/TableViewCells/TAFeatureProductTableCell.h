//
//  TAFeatureProductTableCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAFeatureProductTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *productSizeLbl;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *conditionBtn;
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
@property (weak, nonatomic) IBOutlet UILabel *storeAddressLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productImageBottomConstraints;
@property (weak, nonatomic) IBOutlet UIView *soldOutView;
@end
