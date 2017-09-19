//
//  TAServiceDeliveryCell.h
//  Throne
//
//  Created by Anil Kumar on 06/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAServiceDeliveryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *remoteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *onLocationImageView;
@property (weak, nonatomic) IBOutlet UIView *txtFieldImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *remoteBtn;
@property (weak, nonatomic) IBOutlet UIButton *onLocationBtn;
@property (weak, nonatomic) IBOutlet UILabel *seperatorLabel;

@end
