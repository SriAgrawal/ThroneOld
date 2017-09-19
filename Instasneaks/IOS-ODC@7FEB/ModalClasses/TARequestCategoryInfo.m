//
//  TARequestCategoryInfo.m
//  Throne
//
//  Created by Shridhar Agarwal on 31/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TARequestCategoryInfo.h"

@implementation TARequestCategoryInfo

+ (TARequestCategoryInfo *)getDefaultInfo {
    
    TARequestCategoryInfo *info = [[TARequestCategoryInfo alloc] init];
    info.twitter = @"";
    info.facebook = @"";
    info.other = @"";
     info.website = @"";
     info.storeName = @"";
     info.instagram = @"";
    return info;
}

@end
