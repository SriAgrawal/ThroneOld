//
//  TAshippingMethodTVC.h
//  Throne
//
//  Created by Priya Sharma on 10/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAshippingMethodTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *addNewAddressButton;
@property (strong, nonatomic) IBOutlet UIButton *shippingMethodOne;
- (IBAction)checkMarkButtonAction:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UIButton *editAddressButton;
@property (strong, nonatomic) IBOutlet UIButton *shippingMethodTwo;
@property (strong, nonatomic) IBOutlet UIButton *shippingMethodThree;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *editAddressView;
@property (strong, nonatomic) IBOutlet UIView *shippingMethodView;
@end
