//
//  TASizeSelectionCell.h
//  Throne
//
//  Created by Priya Sharma on 09/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TASizeSelectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *sizeSelectionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@end
