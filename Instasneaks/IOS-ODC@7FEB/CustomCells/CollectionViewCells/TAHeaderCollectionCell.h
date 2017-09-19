//
//  TAHeaderCollectionCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 26/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAHeaderCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLbl;
@property (weak, nonatomic) IBOutlet UIButton * selectedCatNameBtn;

@end
