//
//  TAManualAuthorView.h
//  Throne
//
//  Created by Shridhar Agarwal on 24/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAManualAuthorView : UIView



//Navigation bar property

@property (weak, nonatomic) IBOutlet UIButton           * categoryButton;
@property (weak, nonatomic) IBOutlet UIButton           * walletButton;
@property (weak, nonatomic) IBOutlet UIButton           * homeBtnAction;

//Search View Property
@property (weak, nonatomic) IBOutlet UIButton           * cancelButton;
@property (weak, nonatomic) IBOutlet UITextField        * serachTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchLeftConstraints;
@property (weak, nonatomic) IBOutlet UIView *searchHeaderView;

//manuanl Back property
@property (weak, nonatomic) IBOutlet UIButton *backBtnAction;

//Author profile property
@property (weak, nonatomic) IBOutlet UILabel            * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel            * memberLabel;
@property (weak, nonatomic) IBOutlet UILabel            * imageLabel;
@property (weak, nonatomic) IBOutlet UIImageView        * profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UIButton *instagramBtn;
@property (weak, nonatomic) IBOutlet UIButton *twitterBtn;
@property (weak, nonatomic) IBOutlet UIButton           * shareToThrone;

//Bio Hide View Property
@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptioViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *descriptionTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAndHideDescriptionBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;

+ (instancetype)instantiateFromNib;
@end
