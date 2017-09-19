//
//  TATotalTVC.h
//  Throne
//
//  Created by Priya Sharma on 11/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TATotalTVC : UITableViewCell
@property (nonatomic,strong)IBOutlet UILabel    *discountAmtLbl;
@property (nonatomic,strong)IBOutlet UILabel    *totalAmtLbl;
@property (nonatomic,strong)IBOutlet UILabel    *subTotalAmtLbl;
@property (nonatomic,strong)IBOutlet UILabel    *taxAmtLbl;
@property (nonatomic,strong)IBOutlet UILabel    *shippingLbl;

@end
