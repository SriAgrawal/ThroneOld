//
//  TATrendingProductTableCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TATrendingProductTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end
