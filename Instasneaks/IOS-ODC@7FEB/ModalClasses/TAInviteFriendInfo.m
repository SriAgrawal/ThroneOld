//
//  TAInviteFriendInfo.m
//  Throne
//
//  Created by Shridhar Agarwal on 04/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAInviteFriendInfo.h"

@implementation TAInviteFriendInfo
+ (TAInviteFriendInfo *)getInviteInfo {
    TAInviteFriendInfo *info = [[TAInviteFriendInfo alloc] init];
    info.isSelected = @"";
    info.friendName = @"";
    info.friendImage= nil;
    return info;
}

@end
