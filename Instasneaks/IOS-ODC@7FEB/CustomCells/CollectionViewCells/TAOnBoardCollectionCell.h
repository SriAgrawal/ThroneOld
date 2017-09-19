//
//  TAOnBoardCollectionCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 16/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TAOnBoardCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *onBoardLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *onBoardTitleLbl;
@property (weak, nonatomic) IBOutlet UILabel *onBoardContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *onBoardMiddleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLblUpperConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLblHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *onBoardImageView;

@end
