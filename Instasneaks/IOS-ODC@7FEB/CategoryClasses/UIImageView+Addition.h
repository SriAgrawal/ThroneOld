//
//  UIImageView+Addition.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Addition)

@property (assign, nonatomic) IBInspectable UIColor *iconColor;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize )size;
+ (UIImage*)imagewithScreenShotOfView:(UIView*)view;

- (void)color:(UIColor *)color;

@end
