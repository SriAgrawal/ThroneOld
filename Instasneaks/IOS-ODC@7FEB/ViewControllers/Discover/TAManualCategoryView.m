//
//  TAManualCategoryView.m
//  Throne
//
//  Created by Shridhar Agarwal on 01/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAManualCategoryView.h"

@implementation TAManualCategoryView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

@end
