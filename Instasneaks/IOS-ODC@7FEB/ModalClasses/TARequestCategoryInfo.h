//
//  TARequestCategoryInfo.h
//  Throne
//
//  Created by Shridhar Agarwal on 31/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TARequestCategoryInfo : NSObject

@property (strong, nonatomic) NSString *storeName;
@property (strong, nonatomic) NSString *twitter;
@property (strong, nonatomic) NSString *facebook;
@property (strong, nonatomic) NSString *other;
@property (strong, nonatomic) NSString *instagram;
@property (strong, nonatomic) NSString *website;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *categorySuggestion;

@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *toSell;
@property (strong, nonatomic) NSString *currentSell;
@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *siteURL;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *socialURL;
@property (strong, nonatomic) NSString *applicationCode;


@property (assign, nonatomic) BOOL isSelected;
@property (assign, nonatomic) NSString* id;

+ (TARequestCategoryInfo *)getDefaultInfo;


@end
