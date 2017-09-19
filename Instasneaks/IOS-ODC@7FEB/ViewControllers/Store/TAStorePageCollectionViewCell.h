//
//  TAStorePageCollectionViewCell.h
//  Throne
//
//  Created by Deepak Kumar on 1/13/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASJTagsView.h"


@interface TAStorePageCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *followingSuggestionImageView;

@property (strong, nonatomic) IBOutlet UILabel *followingSuggestionFollowLabel;
@property (strong, nonatomic) IBOutlet UILabel *followingSuggestionTitleLabel;

@property (strong, nonatomic) IBOutlet UIButton *followingSuggestionSubTitleButton;
@property (strong, nonatomic) IBOutlet UIButton *followingSuggestionFollowButton;

@property (weak, nonatomic) IBOutlet ASJTagsView *tagView;

@end
