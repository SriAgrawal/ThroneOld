//
//  TAFilterInfo.h
//  Throne
//
//  Created by Shridhar Agarwal on 30/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAFilterInfo : NSObject
@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *selectedGender;
@property (strong, nonatomic) NSString *selectedSubcategory;
@property (strong, nonatomic) NSString *selectedCategory;
@property (strong, nonatomic) NSString *selectedHeatIndex;
@property (assign, nonatomic) BOOL isSelectedMultipleColor;
@property (strong, nonatomic) NSArray *selectedMutilpleColor;
@property (strong, nonatomic) NSArray *selectedSize;
@property (assign, nonatomic) BOOL isSelectedSize;
@property (assign, nonatomic) BOOL isSelectedHeatIndex;
@property (nonatomic,assign)  BOOL     isSave;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray  *categoryArray;
@property (strong, nonatomic) NSMutableArray  *conditionArray;
@property (strong, nonatomic) NSMutableArray  *genderArray;
@property (strong, nonatomic) NSMutableArray  *heat_indexArray;
@property (strong, nonatomic) NSMutableArray  *priceArray;
@property (strong, nonatomic) NSMutableArray  *sizeArray;
@property (strong, nonatomic) NSMutableArray  *colorArray;

@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) BOOL isToggleSelected;
@property (assign, nonatomic) BOOL isMaleSelected;
@property (assign, nonatomic) BOOL isFemaleSelected;
@property (assign, nonatomic) BOOL isNewSelected;
@property (assign, nonatomic) BOOL isUsedSelected;

@property (strong, nonatomic) NSString *selectedMinimum;
@property (strong, nonatomic) NSString *selectedMaximum;

@property (assign, nonatomic) BOOL isExpanded;
@property (strong, nonatomic) NSArray *arrNoOfRows;



+ (TAFilterInfo *)getFilterInfo;
+ (TAFilterInfo *)getFilterInfo:(NSMutableDictionary *)result;
+ (TAFilterInfo *)getFilterInfoForCategory:(NSMutableDictionary *)result;

@end
