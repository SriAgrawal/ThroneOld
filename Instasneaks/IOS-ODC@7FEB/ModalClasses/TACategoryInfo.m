//
//  TACategoryInfo.m
//  Throne
//
//  Created by Suresh patel on 27/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TACategoryInfo.h"

@implementation TACategoryInfo


+(NSMutableArray *)parseCategoryListDataWithList:(NSArray *)categories{
    
    NSMutableArray * categoryData = [NSMutableArray array];
    
    for (NSDictionary * dict in categories) {
        TACategoryInfo * catInfo = [[TACategoryInfo alloc] init];
        [catInfo setCategoryId:[dict objectForKeyNotNull:pId expectedObj:0]];
        [catInfo setCategoryName:[[dict objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
        [catInfo setCategoryDescription:[[dict objectForKeyNotNull:pDescription expectedObj:@""] uppercaseString]];
        [catInfo setCategoryImage:[dict objectForKeyNotNull:pCategoryUrl expectedObj:@""]];
        [catInfo setSubCategoryArray:[self parseSubCategoryListDataWithList:[dict objectForKeyNotNull:pSubcategories expectedObj:[NSArray array]]]];
        [catInfo setSelectedCategoryName:[self getFirstCherectarFromString:catInfo.categoryName]];
        [categoryData addObject:catInfo];
    }
    
    return categoryData;
}

+(NSString *)getFirstCherectarFromString:(NSString *)string{
    
    NSArray * wordsArray = [string componentsSeparatedByString:@" "];
    if (wordsArray.count>1)
        return [NSString stringWithFormat:@"%@%@", [[wordsArray firstObject] substringToIndex:1], [[wordsArray lastObject] substringToIndex:1]];
    else
        return [string substringToIndex:2];
}

+ (NSMutableArray *)parseSubCategoryListDataWithList:(NSArray *)categories{
    
    NSMutableArray * categoryData = [NSMutableArray array];
    
    for (NSDictionary * dict in categories) {
        TACategoryInfo * catInfo = [[TACategoryInfo alloc] init];
        [catInfo setCategoryId:[dict objectForKeyNotNull:pId expectedObj:0]];
        [catInfo setCategoryName:[[dict objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
        [catInfo setCategoryDescription:[[dict objectForKeyNotNull:pDescription expectedObj:@""] uppercaseString]];
        [catInfo setCategoryImage:[dict objectForKeyNotNull:pCategoryUrl expectedObj:@""]];
        
        [categoryData addObject:catInfo];
    }
    
    return categoryData;
}


@end
