//
//  TATrendingStoriesCollectionCell.h
//  Throne
//
//  Created by Shridhar Agarwal on 31/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TATrendingStoriesCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storiesImage;
@property (weak, nonatomic) IBOutlet UILabel *storiesTime;
@property (weak, nonatomic) IBOutlet UILabel *storiesTitle;

@end
