//
//  TAStoreInfo.m
//  Throne
//
//  Created by Shridhar Agarwal on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TAStoreInfo.h"

@implementation TAStoreInfo
+ (TAStoreInfo *)getStoreInfo {
    
    TAStoreInfo *info = [[TAStoreInfo alloc] init];
    info.storeTitle = @"";
    info.storeName = @"";
    info.storeRating = 0;
    info.storeId = @"";
    info.storeDescription = @"";
    info.storeView_Count = @"";
    info.storeFollowers_Count = @"";
    return info;
}

+(NSMutableArray *)parseStoreListData:(NSMutableDictionary *)dic{
    NSMutableArray *storeArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *storeDic in [dic objectForKeyNotNull:kVendors expectedObj:[NSArray array]]) {
        TAStoreInfo *info = [[TAStoreInfo alloc] init];
        info.storeCategroyArray = [[NSMutableArray alloc] init];
        info.storeId = [storeDic objectForKeyNotNull:pId expectedObj:@""];
        info.storeName = [storeDic objectForKeyNotNull:pName expectedObj:@""];
        info.storeFollowers_Count = [storeDic objectForKeyNotNull:@"followers_count" expectedObj:@""];
        info.storeView_Count = [storeDic objectForKeyNotNull:@"views_count" expectedObj:@""];
        info.isFollow = [[storeDic objectForKeyNotNull:@"followed" expectedObj:0] boolValue];
        info.storeLogoImage = [storeDic objectForKeyNotNull:@"logo_url" expectedObj:@""];
        info.storeHeaderImage = [storeDic objectForKeyNotNull:@"header_url" expectedObj:@""];
        info.storeRating = [[storeDic objectForKeyNotNull:@"heat_index" expectedObj:@""] intValue];
        if ([[self parseCategoryDataWithList:[storeDic objectForKeyNotNull:pCategory expectedObj:[NSArray array]]] count]) 
            info.storeCategroyArray = [self parseCategoryDataWithList:[storeDic objectForKeyNotNull:pCategory expectedObj:[NSArray array]]];
        [storeArray addObject:info];
    }
    return storeArray;
}

+(TAStoreInfo *)parseStoreDetailsData:(NSMutableDictionary *)storeDic{
    TAStoreInfo *info = [[TAStoreInfo alloc] init];
    info.storeCategroyArray = [[NSMutableArray alloc] init];
    info.storeId = [storeDic objectForKeyNotNull:pId expectedObj:@""];
    info.storeName = [[storeDic objectForKeyNotNull:pName expectedObj:@""] uppercaseString];
    info.storeFollowers_Count = [storeDic objectForKeyNotNull:@"followers_count" expectedObj:@""];
    info.storeView_Count = [storeDic objectForKeyNotNull:@"views_count" expectedObj:@""];
    info.isFollow = [[storeDic objectForKeyNotNull:@"followed" expectedObj:0] boolValue];
    info.storeLogoImage = [storeDic objectForKeyNotNull:@"logo_url" expectedObj:@""];
    info.storeHeaderImage = [storeDic objectForKeyNotNull:@"header_url" expectedObj:@""];
    info.address_name = [storeDic objectForKeyNotNull:@"address_name" expectedObj:@""];
    info.website = [storeDic objectForKeyNotNull:@"website" expectedObj:@""];
    info.avg_rate = [storeDic objectForKeyNotNull:@"avg_rate" expectedObj:@""];
    info.storeDescription = [storeDic objectForKeyNotNull:@"description" expectedObj:@""];
    info.heat_index = [storeDic objectForKeyNotNull:@"heat_index" expectedObj:@""];

    info.storeCategroyArray = [self parseCategoryDataWithList:[storeDic objectForKeyNotNull:pCategory expectedObj:[NSArray array]]];
    return info;
}

+(NSMutableArray *)parseFollowingStoreListData:(NSMutableArray *)storeDataArray{
    NSMutableArray *storeArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *storeDic in storeDataArray) {
        TAStoreInfo *info = [[TAStoreInfo alloc] init];
        NSMutableDictionary *vendorDic = [storeDic objectForKeyNotNull:@"vendor" expectedObj:[NSMutableDictionary dictionary]];
        info.storeCategroyArray = [[NSMutableArray alloc] init];
        info.storeId = [vendorDic objectForKeyNotNull:pId expectedObj:@""];
        info.storeName = [vendorDic objectForKeyNotNull:pName expectedObj:@""];
        info.isFollow = [[storeDic objectForKeyNotNull:@"followed" expectedObj:0] boolValue];
        info.storeLogoImage = [vendorDic objectForKeyNotNull:@"logo_url" expectedObj:@""];
        info.storeHeaderImage = [vendorDic objectForKeyNotNull:@"header_url" expectedObj:@""];
        info.storeRating = [[vendorDic objectForKeyNotNull:@"heat_index" expectedObj:@""] intValue];

        info.storeCategroyArray = [self parseCategoryDataWithList:[vendorDic objectForKeyNotNull:pCategory expectedObj:[NSArray array]]];
        [storeArray addObject:info];
    }
    return storeArray;
}

+(NSMutableArray *)parseFollowerSuggestedData:(NSMutableDictionary *)storeDic{
    NSMutableArray *suggestedArray = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in [storeDic objectForKeyNotNull:kVendors expectedObj:[NSArray array]]) {
    TAStoreInfo *info = [[TAStoreInfo alloc] init];
    info.storeCategroyArray = [[NSMutableArray alloc] init];
    info.storeId = [dic objectForKeyNotNull:pId expectedObj:@""];
    info.isFollow = [[storeDic objectForKeyNotNull:@"followed" expectedObj:0] boolValue];
    info.storeName = [dic objectForKeyNotNull:pName expectedObj:@""];
    info.storeFollowerImage = [dic objectForKeyNotNull:@"logo_url" expectedObj:@""];
    info.storeCategroyArray = [self parseCategoryDataWithList:[dic objectForKeyNotNull:pCategory expectedObj:[NSArray array]]];
    [suggestedArray addObject:info];
    }
    return suggestedArray;
}

+(NSMutableArray *)parseCategoryDataWithList:(NSArray *)categoryArray{
    
    NSMutableArray *catArray = [[NSMutableArray alloc] init];

    for (NSMutableDictionary *dic in categoryArray) {
        NSInteger index = [categoryArray indexOfObject:dic];
        NSString *tagString = [NSString stringWithFormat:@"%@, ", [dic objectForKeyNotNull:pName expectedObj:@""]];
        if (index == categoryArray.count-1) {
            tagString = [NSString stringWithFormat:@"%@", [dic objectForKeyNotNull:pName expectedObj:@""]];
        }
        [catArray addObject:[tagString uppercaseString]];
    }
    return catArray;
}

@end
