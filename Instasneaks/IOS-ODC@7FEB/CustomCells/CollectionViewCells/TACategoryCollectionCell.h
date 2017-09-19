//
//  TACategoryCollectionCell.h
//  Throne
//
//  Created by Suresh patel on 27/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TACategoryCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView * categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel * titleLabel;
@property (weak, nonatomic) IBOutlet UILabel * descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftSeperatorLbl;

@end
