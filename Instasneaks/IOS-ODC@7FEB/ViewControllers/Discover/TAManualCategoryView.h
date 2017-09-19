//
//  TAManualCategoryView.h
//  Throne
//
//  Created by Shridhar Agarwal on 01/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAManualCategoryView : UIView

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



+ (instancetype)instantiateFromNib;
@end
