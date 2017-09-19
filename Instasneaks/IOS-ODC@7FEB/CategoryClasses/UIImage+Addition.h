//
//  UIImage+Addition.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

- (NSString *)getBase64String;
- (NSString *)getBase64StringWithQuality:(CGFloat)value;

@end
