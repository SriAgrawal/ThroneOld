//
//  TAStoreInfo.h
//  Throne
//
//  Created by Shridhar Agarwal on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface TAStoreInfo : NSObject

@property (strong, nonatomic) NSString *storeId;
@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *storeTitle;
@property (nonatomic) int storeRating;
@property (strong, nonatomic) NSMutableArray *storeCategroyArray;
@property (strong, nonatomic) NSString *storeDescription;
@property (strong, nonatomic) NSString *storeView_Count;
@property (strong, nonatomic) NSString *storeFollowers_Count;
@property (strong, nonatomic) NSString *storeFollowerImage;
@property (strong, nonatomic) NSString *storeHeaderImage;
@property (strong, nonatomic) NSString *storeLogoImage;
@property (strong, nonatomic) NSString *address_name;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *avg_rate;
@property (strong, nonatomic) NSString *heat_index;

@property (nonatomic) BOOL isFollow;
+ (TAStoreInfo *)getStoreInfo;
+(NSMutableArray *)parseStoreListData:(NSMutableDictionary *)storeDic;
+(NSMutableArray *)parseFollowingStoreListData:(NSMutableDictionary *)storeDic;
+(TAStoreInfo *)parseStoreDetailsData:(NSMutableDictionary *)storeDic;
+(NSMutableArray *)parseFollowerSuggestedData:(NSMutableDictionary *)storeDic;
+(NSMutableArray *)parseCategoryDataWithList:(NSArray *)categoryArray;
@end
