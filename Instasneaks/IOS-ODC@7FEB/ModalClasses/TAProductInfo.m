//
//  TAProductInfo.m
//  Throne
//
//  Created by Shridhar Agarwal on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "TAProductInfo.h"

@implementation TAProductInfo
+ (TAProductInfo *)getStoreInfo {
    
    TAProductInfo *info = [[TAProductInfo alloc] init];
    info.productSize = @"";
    info.productName = @"";
    info.productPrice = @"";
    info.productAddress = @"";
    return info;
}

+ (TAProductInfo *)parseProductDetails:(NSDictionary *)dic{
    
    TAProductInfo *productInfo = [[TAProductInfo alloc] init];
    
    [productInfo setProductId:[dic objectForKeyNotNull:pId expectedObj:@""]];
    [productInfo setProductName:[[dic objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
    [productInfo setProductPrice:[dic objectForKeyNotNull:pDisplay_Price expectedObj:@""]];
    [productInfo setProductGender:[dic objectForKeyNotNull:pGender expectedObj:@""]];
    [productInfo setIsNew:[[dic objectForKeyNotNull:pCondition expectedObj:@""] isEqualToString:@"unused"]? @"NEW" : @"USED"];
    [productInfo setProductDescription:[[dic objectForKeyNotNull:pDescription expectedObj:@""] uppercaseString]];
    [productInfo setIsLiked:[[dic objectForKeyNotNull:pIsLiked expectedObj:@""] boolValue]];
    [productInfo setProductReturns:@"ALL ITEMS ON THRONE ARE FINAL SALE"];
    
    //Vendor Object
    NSDictionary *vendorInfo = [dic objectForKeyNotNull:pVendor expectedObj:[NSDictionary new]];
    TAStoreInfo *vendorObj = [[TAStoreInfo alloc] init];
    
    [vendorObj setStoreId:[vendorInfo objectForKeyNotNull:pId expectedObj:@""]];
    [vendorObj setStoreName:[[vendorInfo objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
    [vendorObj setAddress_name:[[vendorInfo objectForKeyNotNull:pAddressName expectedObj:@""] uppercaseString]];
    [vendorObj setIsFollow:[[vendorInfo objectForKeyNotNull:pIsfollowed expectedObj:@""] boolValue]];
    vendorObj.storeCategroyArray = [TAStoreInfo parseCategoryDataWithList:[vendorInfo objectForKeyNotNull:pCategory expectedObj:[NSArray array]]];
    productInfo.storeInfo = vendorObj;
    
    //Master Object
   productInfo.productImageDataArray = [[NSMutableArray alloc] init];
    NSDictionary *masterInfo = [dic objectForKeyNotNull:@"master" expectedObj:[NSDictionary new]];
    for (NSDictionary *imageDic in [masterInfo objectForKeyNotNull:@"images" expectedObj:[NSArray array]]) {
        [productInfo.productImageDataArray addObject:[imageDic objectForKeyNotNull:@"large url" expectedObj:@""]];
    }

    //Variants Object
    productInfo.productVariantsArray = [[NSMutableArray alloc] init];
    for (NSDictionary *variantsInfo in [dic objectForKeyNotNull:@"variants" expectedObj:[NSArray new]]) {
        TAProductInfo *variantsObj = [[TAProductInfo alloc] init];
        for (NSDictionary *optionDic in [variantsInfo objectForKeyNotNull:@"option_values" expectedObj:[NSArray array]]) {
            if ([[optionDic objectForKeyNotNull:@"option_type_name" expectedObj:@""] isEqualToString:@"size_shoes"]) {
                variantsObj.optionId =  [optionDic objectForKeyNotNull:@"option_type_id" expectedObj:@""];
                variantsObj.productSize = [optionDic objectForKeyNotNull:@"presentation" expectedObj:@""];
            }
        }
        variantsObj.isStock = [[variantsInfo objectForKeyNotNull:@"in_stock" expectedObj:@""] boolValue];
        variantsObj.variantsId = [variantsInfo objectForKeyNotNull:pId expectedObj:@""];
        [productInfo.productVariantsArray addObject:variantsObj];
    }
    return productInfo;
}

+(NSMutableArray *)parseProductListDataWithList:(NSArray *)products{
    
    NSMutableArray * productData = [NSMutableArray array];
    for (NSDictionary * dict in products) {
        TAProductInfo * productInfo = [[TAProductInfo alloc] init];
        [productInfo setProductId:[dict objectForKeyNotNull:pId expectedObj:0]];
        [productInfo setProductName:[[dict objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
        [productInfo setProductPrice:[dict objectForKeyNotNull:pPrice expectedObj:@""]];
        [productInfo setProductImage:[dict objectForKeyNotNull:pImageURL expectedObj:@""]];
        [productInfo setProductConditions:[dict objectForKeyNotNull:pCondition expectedObj:@""]];
        [productInfo setProductSize:[NSString stringWithFormat: @"SIZE %@", [dict objectForKeyNotNull:pPrice expectedObj:@""]]];
        [productInfo setIsLiked:[[dict objectForKeyNotNull:pIsLiked expectedObj:@""] boolValue]];
        [productInfo setIsSold:[[dict objectForKeyNotNull:pIsSold expectedObj:@""] boolValue]];
        [productInfo setStoreInfo:[self parseStoreInfoDataWithObject:[dict objectForKeyNotNull:pVendor expectedObj:[NSDictionary dictionary]]]];

        [productData addObject:productInfo];
    }
    
    return productData;
}

+(NSMutableArray *)parseFavoriteProductListDataWithList:(NSArray *)products{
    NSMutableArray * productData = [NSMutableArray array];
        for (NSDictionary * dict in products) {
        NSDictionary * productDict = [dict objectForKeyNotNull:pProduct expectedObj:[NSDictionary dictionary]];
        TAProductInfo * productInfo = [[TAProductInfo alloc] init];
        [productInfo setProductId:[productDict objectForKeyNotNull:pId expectedObj:0]];
        [productInfo setProductName:[[productDict objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
        [productInfo setProductPrice:[productDict objectForKeyNotNull:pPrice expectedObj:@""]];
        [productInfo setProductImage:[productDict objectForKeyNotNull:pImageURL expectedObj:@""]];
        [productInfo setProductSize:[NSString stringWithFormat: @"SIZE %@", [productDict objectForKeyNotNull:pPrice expectedObj:@""]]];
        [productInfo setIsLiked:[[productDict objectForKeyNotNull:pIsLiked expectedObj:@""] boolValue]];
        [productInfo setStoreInfo:[self parseStoreInfoDataWithObject:[productDict objectForKeyNotNull:pVendor expectedObj:[NSDictionary dictionary]]]];
        [productData addObject:productInfo];
    }
    return productData;
}

+(NSMutableArray *)parsePurchasedListData:(NSArray *)products{
    
    NSMutableArray * productData = [NSMutableArray array];
    
    for (NSDictionary * dict in products) {
        NSArray * itemsArray = [dict objectForKeyNotNull:pLineItems expectedObj:[NSArray new]];
        NSDictionary * itemsInfo;
        if (itemsArray.count)
            itemsInfo = [itemsArray firstObject];
        else
            continue;
        NSDictionary * productDict = [itemsInfo objectForKeyNotNull:pProduct expectedObj:[NSDictionary dictionary]];
        TAProductInfo * productInfo = [[TAProductInfo alloc] init];
        [productInfo setProductId:[productDict objectForKeyNotNull:pId expectedObj:0]];
        [productInfo setProductName:[[productDict objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
        [productInfo setProductPrice:[productDict objectForKeyNotNull:pPrice expectedObj:@""]];
        [productInfo setProductImage:[productDict objectForKeyNotNull:pImageURL expectedObj:@""]];
        [productInfo setProductSize:[NSString stringWithFormat: @"SIZE %@", [productDict objectForKeyNotNull:pPrice expectedObj:@""]]];
        [productInfo setIsLiked:[[productDict objectForKeyNotNull:pIsLiked expectedObj:@""] boolValue]];
        [productInfo setStoreInfo:[self parseStoreInfoDataWithObject:[productDict objectForKeyNotNull:pVendor expectedObj:[NSDictionary dictionary]]]];
        
        [productData addObject:productInfo];
    }
    
    return productData;
}

+(TAStoreInfo *)parseStoreInfoDataWithObject:(NSDictionary *)dict{
    
    TAStoreInfo * storeInfo = [[TAStoreInfo alloc] init];
    [storeInfo setStoreId:[dict objectForKeyNotNull:pId expectedObj:@""]];
    [storeInfo setStoreName:[[dict objectForKeyNotNull:pName expectedObj:@""] uppercaseString]];
    
    return storeInfo;
}

@end
