//
//  TACheckOutInfo.h
//  Throne
//
//  Created by Shridhar Agarwal on 28/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Macro.h"
@class UserInfo;
@interface TACheckOutInfo : NSObject
@property (nonatomic,strong) NSString   *discountCode;
@property (strong, nonatomic) NSString      * orderId;
@property (strong, nonatomic) NSString      * orderSizeId;
@property (strong, nonatomic) NSString      * orderNumber;
@property (strong, nonatomic) NSString      * orderPrice;
@property (strong, nonatomic) NSString      * promoCodeSuccess;
@property (strong, nonatomic) NSString      * discountAmount;
@property (strong, nonatomic) NSString      * shippingAmount;
@property (strong, nonatomic) NSString      * taxAmount;

@property (assign, nonatomic) BOOL isSizeTapped;
@property (assign, nonatomic) BOOL isEmptyAddress;
@property (strong, nonatomic)   UserInfo        *userInfo;

+ (TACheckOutInfo *)getStoreInfo;
+(TACheckOutInfo*)parseOrderDetails:(NSMutableDictionary*)dic;
@end
