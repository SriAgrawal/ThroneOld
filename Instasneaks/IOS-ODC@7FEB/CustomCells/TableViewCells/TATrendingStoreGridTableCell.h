//
//  TATrendingStoreGridTableCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 30/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIZSliderView.h"
@interface TATrendingStoreGridTableCell : UITableViewCell<BIZSliderViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *gridStoreCollectionView;
@property (weak, nonatomic) IBOutlet UIView * silderView;
@property (weak, nonatomic) IBOutlet UIButton * storeFollowBtn;

@end
