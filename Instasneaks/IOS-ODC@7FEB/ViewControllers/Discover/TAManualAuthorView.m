//
//  TAManualAuthorView.m
//  Throne
//
//  Created by Shridhar Agarwal on 24/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAManualAuthorView.h"

@implementation TAManualAuthorView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

@end
