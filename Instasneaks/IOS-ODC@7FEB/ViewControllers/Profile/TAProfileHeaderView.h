//
//  TAProfileHeaderView.h
//  Throne
//
//  Created by Suresh patel on 02/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAProfileHeaderView : UIView


@property (weak, nonatomic) IBOutlet UILabel            * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel            * memberLabel;
@property (weak, nonatomic) IBOutlet UILabel            * imageLabel;

@property (weak, nonatomic) IBOutlet UIButton           * settingButton;
@property (weak, nonatomic) IBOutlet UIButton           * walletButton;

@property (weak, nonatomic) IBOutlet UIImageView        * profileImageView;
@property (weak, nonatomic) IBOutlet UIButton           * shareToThrone;
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptioViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *showAndHideDescriptionBtn;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *sepratorLabel;
@property (weak, nonatomic) IBOutlet UIButton           * expandButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookBtn;
@property (weak, nonatomic) IBOutlet UIButton *instagramBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn;
+ (instancetype)instantiateFromNib;

@end
