//
//  TAPaymentMethodTVC.h
//  Throne
//
//  Created by Priya Sharma on 11/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAPaymentMethodTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *creditCardViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *creditCardButton;
@property (strong, nonatomic) IBOutlet UIButton *paypalButton;
@property (strong, nonatomic) IBOutlet UIView *creditCardView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *creditCardButtonTopConstraint;
@property (strong, nonatomic) IBOutlet UIButton *saveCardBtn
;
@end
