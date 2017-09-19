//
//  TACheckOutInfo.m
//  Throne
//
//  Created by Shridhar Agarwal on 28/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import "TACheckOutInfo.h"

@implementation TACheckOutInfo

+ (TACheckOutInfo *)getStoreInfo {
    
    TACheckOutInfo *info = [[TACheckOutInfo alloc] init];
    info.orderSizeId = @"";
    info.discountCode = @"";
    info.orderNumber = @"";
    info.orderPrice = @"";
    return info;

}
+(TACheckOutInfo*)parseOrderDetails:(NSMutableDictionary*)dic{

    TACheckOutInfo *info = [[TACheckOutInfo alloc] init];
    info.orderSizeId = @"";
    info.discountCode = @"";
    info.orderNumber = [dic objectForKeyNotNull:@"number" expectedObj:@""];
    [NSUSERDEFAULT setObject:info.orderNumber forKey:@"OrderNumber"];
    info.orderPrice = [dic objectForKeyNotNull:@"total" expectedObj:@""];
    info.discountAmount = [dic objectForKeyNotNull:@"display_adjustment_total" expectedObj:@""];
    info.shippingAmount = [dic objectForKeyNotNull:@"display_ship_total" expectedObj:@""];
    info.taxAmount = [dic objectForKeyNotNull:@"display_tax_total" expectedObj:@""];
    NSDictionary *billingInfo = [dic objectForKeyNotNull:@"bill_address" expectedObj:@""];
    info.isEmptyAddress = [billingInfo isKindOfClass:[NSDictionary class]] ? NO : YES;
        UserInfo *obj = [[UserInfo alloc] init];
    obj.streetAddress2String = [billingInfo objectForKeyNotNull:pAddressOne expectedObj:@""];
    obj.cityString = [billingInfo objectForKeyNotNull:pCity expectedObj:@""];
    obj.stateString = [billingInfo objectForKeyNotNull:@"state_text" expectedObj:@""];
    obj.zipCodeString = [billingInfo objectForKeyNotNull:pZipCode expectedObj:@""];
    obj.stateId = [billingInfo objectForKeyNotNull:pStateId expectedObj:@""];
    obj.counrtyId = [billingInfo objectForKeyNotNull:pCountryId expectedObj:@""];
    obj.countryString = [[billingInfo objectForKeyNotNull:@"country" expectedObj:[NSDictionary dictionary]] objectForKeyNotNull:@"iso_name" expectedObj:@""];
    info.userInfo = obj;
    return info;
}
@end
