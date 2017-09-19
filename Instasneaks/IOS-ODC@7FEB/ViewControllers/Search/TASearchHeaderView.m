//
//  TASearchHeaderView.m
//  Throne
//
//  Created by Suresh patel on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TASearchHeaderView.h"

@interface TASearchHeaderView ()

@end

@implementation TASearchHeaderView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
}

@end
