//
//  TAStorePageCollectionViewCell.m
//  Throne
//
//  Created by Deepak Kumar on 1/13/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAStorePageCollectionViewCell.h"

@implementation TAStorePageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.followingSuggestionFollowButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.followingSuggestionFollowButton.layer.borderWidth = 1.0f;
    
    // Initialization code
}

@end
