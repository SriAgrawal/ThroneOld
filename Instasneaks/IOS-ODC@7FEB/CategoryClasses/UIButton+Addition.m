//
//  UIButton+Addition.m
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import "UIButton+Addition.h"
#import "Macro.h"

@implementation UIButton (Addition)

- (void)selection:(BOOL)status {
    
    if (status) {
        [self setBackgroundColor:AppColor];
    } else {
        [self setBackgroundColor:AppLightColor];
    }
}

@end
