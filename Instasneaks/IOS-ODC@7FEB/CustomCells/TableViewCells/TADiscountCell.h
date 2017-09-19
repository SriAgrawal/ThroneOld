//
//  TADiscountCell.h
//  Throne
//
//  Created by Anil Kumar on 06/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TADiscountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *enterPromocodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UIButton *walletCreditBtn;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIView *textFieldView;

@end
