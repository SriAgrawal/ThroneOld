//
//  UserInfo.h
//  MealDeal
//
//  Created by Raj Kumar Sharma on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface UserInfo : NSObject

@property (strong, nonatomic) NSString *userNameString;
@property (strong, nonatomic) NSString *fullNameString;
@property (strong, nonatomic) NSString *emailString;
@property (strong, nonatomic) NSString *phoneString;
@property (strong, nonatomic) NSString *passwordString;
@property (strong, nonatomic) NSString *oldPasswordString;

@property (strong, nonatomic) NSString *accessCodeString;
@property (strong, nonatomic) NSString *dateOfBirthString;
@property (strong, nonatomic) NSString *organisationString;
@property (strong, nonatomic) NSString *userTypeString;
@property (strong, nonatomic) NSString *firstNameString;
@property (strong, nonatomic) NSString *lastNameString;
@property (strong, nonatomic) NSString *genderString;
@property (strong, nonatomic) NSString *streetString;
@property (strong, nonatomic) NSString *streetAddress2String;


@property (strong, nonatomic) NSString *confirmPasswordString;

@property (strong, nonatomic) NSString *countryString;
@property (strong, nonatomic) NSString *stateString;
@property (strong, nonatomic) NSString *cityString;
@property (strong, nonatomic) NSString *zipCodeString;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) UIImage *coverImage;

@property (strong, nonatomic) NSString *counrtyId;
@property (strong, nonatomic) NSString *counrtyISOCode;
@property (strong, nonatomic) NSString *countryISOName;
@property (strong, nonatomic) NSString *Countrynumcode;
@property (strong, nonatomic) NSString *CountryISOCodeName;

@property (strong, nonatomic) NSString *stateId;
@property (strong, nonatomic) NSString *stateISOCode;
@property (strong, nonatomic) NSString *stateISOName;
@property (strong, nonatomic) NSString *statenumcode;
@property (strong, nonatomic) NSString *stateISOCodeName;

@property (strong, nonatomic) NSString *descriptionString;

@property (strong, nonatomic) NSString *firstTextfield;
@property (strong, nonatomic) NSString *secondTextfield;

@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *expiry;
@property (strong, nonatomic) NSString *CVV;


@property (strong, nonatomic) NSString *webSite;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *tagLine;


@property (strong, nonatomic) NSString *fbUrl;
@property (strong, nonatomic) NSString *instagramUrl;
@property (strong, nonatomic) NSString *twitterUrl;

@property (strong, nonatomic) NSString *searchText;

@property (assign, nonatomic) BOOL      isForProduct;


+ (id)sharedManager;
+ (UserInfo *)getDefaultInfo;
+ (NSMutableArray *)parseDataForCountryList:(NSMutableArray*)countryArray;
+ (NSMutableArray *)parseDataForStateList:(NSMutableArray*)stateArray;

@end
