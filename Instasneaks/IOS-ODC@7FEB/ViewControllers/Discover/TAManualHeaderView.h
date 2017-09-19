//
//  TAProfileHeaderView.h
//  Throne
//
//  Created by Suresh patel on 02/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAManualHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton           * cancelButton;
@property (weak, nonatomic) IBOutlet UIButton           * categoryButton;
@property (weak, nonatomic) IBOutlet UIButton           * shareButton;
@property (weak, nonatomic) IBOutlet UIButton           * homeButton;
@property (weak, nonatomic) IBOutlet UITextField        * serachTextField;
@property (weak, nonatomic) IBOutlet UIView *manualView;
@property (weak, nonatomic) IBOutlet UIButton *manualBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIView *searchHeaderView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchLeftConstraints;
@property (weak, nonatomic) IBOutlet UILabel *manualDiscriptionLbl;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manualViewBottomViewConstraints;
+ (instancetype)instantiateFromNib;

@end
