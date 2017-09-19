//
//  GradientView.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "GradientView.h"
#import "Macro.h"

@implementation GradientView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self blackGradient];
}

- (void)blackGradient {
    // Create the colors
    UIColor *topColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    UIColor *bottomColor = [UIColor blackColor];
    // Create the gradient
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        theViewGradient.frame = self.bounds;
    });
    
    //Add gradient to view
    [self.layer insertSublayer:theViewGradient atIndex:0];
}

@end
