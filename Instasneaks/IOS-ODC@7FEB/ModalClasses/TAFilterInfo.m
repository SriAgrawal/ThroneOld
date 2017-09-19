//
//  TAFilterInfo.m
//  Throne
//
//  Created by Shridhar Agarwal on 30/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TAFilterInfo.h"
#import "Macro.h"


@implementation TAFilterInfo

+ (TAFilterInfo *)getFilterInfo {
    
    TAFilterInfo *info = [[TAFilterInfo alloc] init];
    info.Id = @"";
    info.selectedGender = @"";
    info.selectedSubcategory = @"";
    info.selectedCategory = @"";
    info.selectedHeatIndex = @"";
    info.isSelectedMultipleColor= @"";
    info.selectedMutilpleColor = @[];
    info.selectedSize = @[];
    info.isSelectedSize = @"";
    info.isSelectedHeatIndex = @"";
    info.isSave = @"";
    
    return info;
}

+ (TAFilterInfo *)getFilterInfo:(NSMutableDictionary *)result{
    TAFilterInfo *info = [[TAFilterInfo alloc] init];
    info.categoryArray = [NSMutableArray new];
    NSArray * arrayOfCategory = [result objectForKeyNotNull:@"category" expectedObj:@""];
    for (NSDictionary * catDict in arrayOfCategory) {
        TAFilterInfo *infoCategory = [[TAFilterInfo alloc] init];
        infoCategory.Id = [catDict objectForKeyNotNull:pId expectedObj:@""];
        infoCategory.name = [[catDict objectForKeyNotNull:pName expectedObj:@""] uppercaseString];
        [info.categoryArray addObject:infoCategory];
    }
    info.conditionArray = [result objectForKeyNotNull:pCondition expectedObj:@""];
    info.genderArray = [result objectForKeyNotNull:pGender expectedObj:@""];
    info.heat_indexArray = [result objectForKeyNotNull:pHeat_index expectedObj:@""];
    info.priceArray = [result objectForKeyNotNull:pPrice expectedObj:@""];

    return info;
}

// parse data in case of category
+ (TAFilterInfo *)getFilterInfoForCategory:(NSMutableDictionary *)result{
    TAFilterInfo *info = [[TAFilterInfo alloc] init];
    info.categoryArray = [NSMutableArray new];
    NSArray * arrayOfCategory = [result objectForKeyNotNull:@"subcategory" expectedObj:@""];
    for (NSDictionary * catDict in arrayOfCategory) {
        TAFilterInfo *infoCategory = [[TAFilterInfo alloc] init];
        infoCategory.Id = [catDict objectForKeyNotNull:pId expectedObj:@""];
        infoCategory.name = [[catDict objectForKeyNotNull:pName expectedObj:@""] uppercaseString];
        [info.categoryArray addObject:infoCategory];
    }
    info.conditionArray = [result objectForKeyNotNull:pCondition expectedObj:@""];
    info.genderArray = [result objectForKeyNotNull:pGender expectedObj:@""];
    info.heat_indexArray = [result objectForKeyNotNull:pHeat_index expectedObj:@""];
    info.priceArray = [result objectForKeyNotNull:pPrice expectedObj:@""];
    
    info.sizeArray = [NSMutableArray new];
    NSArray * arrayOfSize = [result objectForKeyNotNull:@"size" expectedObj:@""];
    for (NSDictionary * sizeDict in arrayOfSize) {
        TAFilterInfo *infoSize = [[TAFilterInfo alloc] init];
        infoSize.Id = [sizeDict objectForKeyNotNull:pId expectedObj:@""];
        infoSize.name = [[sizeDict objectForKeyNotNull:pName expectedObj:@""] uppercaseString];
        infoSize.isSelected = NO;
        [info.sizeArray addObject:infoSize];
    }
    
    info.colorArray = [NSMutableArray new];
    NSArray * arrayOfColor = [result objectForKeyNotNull:@"color" expectedObj:@""];
    for (NSDictionary * colorDict in arrayOfColor) {
        TAFilterInfo *infoColor = [[TAFilterInfo alloc] init];
        infoColor.Id = [colorDict objectForKeyNotNull:pId expectedObj:@""];
        infoColor.name = [[colorDict objectForKeyNotNull:pName expectedObj:@""] uppercaseString];
        infoColor.isSelected = NO;
        [info.colorArray addObject:infoColor];
    }
    return info;
}
@end
