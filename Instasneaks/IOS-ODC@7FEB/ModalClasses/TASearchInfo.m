//
//  TASearchInfo.m
//  Throne
//
//  Created by Suresh patel on 31/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TASearchInfo.h"

@implementation TASearchInfo

+(NSMutableArray *)parseSearchSuggestedData:(NSArray *)searchData{
    NSMutableArray *suggestedArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in searchData) {
        TASearchInfo *info = [[TASearchInfo alloc] init];
        info.searchQuery = [dic objectForKeyNotNull:pQuery expectedObj:@""];
        info.searchCategory = [dic objectForKeyNotNull:kCategories expectedObj:@""];
        [suggestedArray addObject:info];
        
    }
    return suggestedArray;
}

@end
