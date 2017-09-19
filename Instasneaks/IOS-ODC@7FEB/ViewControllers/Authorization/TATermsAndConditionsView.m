//
//  TATermsAndConditionsView.m
//  Throne
//
//  Created by Suresh patel on 04/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TATermsAndConditionsView.h"

@implementation TATermsAndConditionsView

+ (instancetype)instantiateFromNib {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil];
    return [views firstObject];
}

@end
