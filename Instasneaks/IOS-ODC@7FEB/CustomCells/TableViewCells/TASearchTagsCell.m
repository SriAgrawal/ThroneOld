//
//  TASearchTagsCell.m
//  Throne
//
//  Created by Suresh patel on 30/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TASearchTagsCell.h"

@implementation TASearchTagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTags:(NSArray *)tags {
    _tags = tags;
    
    self.tagListView.tags = [NSMutableArray arrayWithArray:tags];
}

@end
