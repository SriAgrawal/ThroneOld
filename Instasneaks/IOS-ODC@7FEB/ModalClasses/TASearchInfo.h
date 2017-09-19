//
//  TASearchInfo.h
//  Throne
//
//  Created by Suresh patel on 31/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface TASearchInfo : NSObject

@property (strong, nonatomic) NSString      * searchQuery;
@property (strong, nonatomic) NSString      * searchCategory;

+(NSMutableArray *)parseSearchSuggestedData:(NSArray *)searchData;

@end
