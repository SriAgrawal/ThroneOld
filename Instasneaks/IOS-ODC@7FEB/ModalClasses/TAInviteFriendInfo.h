//
//  TAInviteFriendInfo.h
//  Throne
//
//  Created by Shridhar Agarwal on 04/02/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface TAInviteFriendInfo : NSObject
@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) UIImage *friendImage;
@property (strong, nonatomic) NSString *friendContactNumber;
@property (nonatomic, assign) BOOL isSelected;
+ (TAInviteFriendInfo *) getInviteInfo;
@end
