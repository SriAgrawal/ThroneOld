//
//  TACategoryInfo.h
//  Throne
//
//  Created by Suresh patel on 27/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@interface TACategoryInfo : NSObject

@property (strong, nonatomic) NSString          * categoryId;
@property (strong, nonatomic) NSString          * categoryName;
@property (strong, nonatomic) NSString          * categoryDescription;
@property (strong, nonatomic) NSString          * categoryImage;
@property (strong, nonatomic) NSString          * selectedCategoryName;
@property (assign, nonatomic) BOOL                isSelected;
@property (strong, nonatomic) NSString          * selectedCategoryImage;
@property (strong, nonatomic) NSMutableArray    * subCategoryArray;

+(NSMutableArray *)parseCategoryListDataWithList:(NSArray *)categories;

@end
