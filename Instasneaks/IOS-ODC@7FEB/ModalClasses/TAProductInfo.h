//
//  TAProductInfo.h
//  Throne
//
//  Created by Shridhar Agarwal on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"

@class TAStoreInfo;

@interface TAProductInfo : NSObject

@property (strong, nonatomic) NSString      * productId;
@property (strong, nonatomic) NSString      * optionId;
@property (strong, nonatomic) NSString      * variantsId;
@property (strong, nonatomic) NSString      * productName;
@property (strong, nonatomic) NSString      * productDescription;
@property (strong, nonatomic) NSString      * productSize;
@property (strong, nonatomic) NSString      * productAddress;
@property (strong, nonatomic) NSString      * productPrice;
@property (strong, nonatomic) NSString      * productSoldBy;
@property (strong, nonatomic) NSString      * productShipsFrom;
@property (strong, nonatomic) NSString      * productConditions;
@property (strong, nonatomic) NSString      * productReturns;
@property (strong, nonatomic) NSString      * productVenderId;
@property (strong, nonatomic) NSString      * productImage;
@property (strong, nonatomic) NSString      * productGender;


@property (strong, nonatomic) TAStoreInfo   * storeInfo;
@property (strong, nonatomic) NSMutableArray * productVariantsArray;
@property (strong, nonatomic) NSMutableArray * productImageDataArray;

@property (assign, nonatomic) BOOL isTapped;
@property (assign, nonatomic) BOOL isLiked;
@property (assign, nonatomic) BOOL isSold;
@property (assign, nonatomic) BOOL isNew;
@property (assign, nonatomic) BOOL isStock;
@property (assign, nonatomic) BOOL isStoreFollow;
@property (assign, nonatomic) BOOL isEnabled;


// newly added
@property (assign, nonatomic) BOOL isRemote;
@property (assign, nonatomic) BOOL isOnLocation;


+ (TAProductInfo *)getStoreInfo;
+ (TAProductInfo *)parseProductDetails:(NSDictionary *)dic;
+ (NSMutableArray *)parseProductListDataWithList:(NSArray *)products;
+(NSMutableArray *)parseFavoriteProductListDataWithList:(NSArray *)products;
+(NSMutableArray *)parsePurchasedListData:(NSArray *)products;
@end
