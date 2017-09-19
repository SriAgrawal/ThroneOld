//
//  TADiscoverInfo.h
//  Throne
//
//  Created by Shridhar Agarwal on 31/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TADiscoverInfo : NSObject
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *discoverImage;
@property (strong, nonatomic) NSString *discoverTitle;
@property (strong, nonatomic) NSString *dicoverDiscription;
@property (strong, nonatomic) NSString *discoverTime;
@property (strong, nonatomic) NSArray *discoverTagArray;
@property (nonatomic,assign)  BOOL     isReadMore;
+ (TADiscoverInfo *)getDiscoverInfo;
@end
