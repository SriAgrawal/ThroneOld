//
//  TAPagination.h
//  Throne
//
//  Created by Suresh patel on 22/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface TAPagination : NSObject

@property (nonatomic, strong) NSString  *count;
@property (nonatomic, strong) NSString  *current_page;
@property (nonatomic, strong) NSString  *pages;
@property (nonatomic, strong) NSString  *per_page;
@property (nonatomic, strong) NSString  *total_count;
@property (nonatomic, assign) BOOL       isMoreDataAvailable;


+(TAPagination *)getPaginationInfoFromDict : (NSDictionary *)data;

@end
