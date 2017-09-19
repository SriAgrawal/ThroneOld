//
//  MDBackgroundImageView.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "MDBackgroundImageView.h"

@implementation MDBackgroundImageView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setClipsToBounds:YES];
    [self setImage:[UIImage imageNamed:@"background"]];
}

@end
