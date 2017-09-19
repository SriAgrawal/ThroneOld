//
//  TAFeatureCollectionCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAFeatureCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productAddressLbl;
@property (weak, nonatomic) IBOutlet UIButton *productLikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *productConditionBtn;
@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *productSizeLbl;
@property (weak, nonatomic) IBOutlet UIButton *productPriceBtn;
@property (weak, nonatomic) IBOutlet UIView *soldOutView;

@end
