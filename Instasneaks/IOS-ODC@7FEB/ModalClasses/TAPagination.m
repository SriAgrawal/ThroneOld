//
//  TAPagination.m
//  Throne
//
//  Created by Suresh patel on 22/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAPagination.h"

@implementation TAPagination


+(TAPagination *)getPaginationInfoFromDict : (NSDictionary *)data {
    
    TAPagination *page = [[TAPagination alloc] init];
    page.current_page = [data objectForKeyNotNull:@"current_page" expectedObj:@""];
    page.pages = [data objectForKeyNotNull:@"pages" expectedObj:@""];;
    page.total_count = [data objectForKeyNotNull:@"total_count" expectedObj:@""];
    page.per_page = [data objectForKeyNotNull:@"per_page" expectedObj:@""];
    page.per_page = [data objectForKeyNotNull:@"per_page" expectedObj:@""];
    page.count = [data objectForKeyNotNull:@"count" expectedObj:@""];

    return page;
}

@end
