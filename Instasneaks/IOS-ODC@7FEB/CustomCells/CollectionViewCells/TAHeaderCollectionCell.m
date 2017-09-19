//
//  TAHeaderCollectionCell.m
//  Throne
//
//  Created by Shridhar Agarwal on 26/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TAHeaderCollectionCell.h"

@implementation TAHeaderCollectionCell

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.selectedCatNameBtn.layer setBorderWidth:2.0f];
    [self.categoryImageView.layer setBorderWidth:2.0f];

}

@end
