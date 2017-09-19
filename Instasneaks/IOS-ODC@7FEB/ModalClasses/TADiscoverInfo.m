//
//  TADiscoverInfo.m
//  Throne
//
//  Created by Shridhar Agarwal on 31/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TADiscoverInfo.h"

@implementation TADiscoverInfo

+ (TADiscoverInfo *)getDiscoverInfo{

    TADiscoverInfo *info = [[TADiscoverInfo alloc] init];
    info.Id = @"";
    info.discoverImage = @"";
    info.discoverTitle = @"";
    info.dicoverDiscription = @"";
    info.discoverTime = @"";
    info.discoverTagArray = @[];
    info.isReadMore = @"";
    return info;

}
@end
