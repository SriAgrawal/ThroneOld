//
//  UserInfo.m
//  MealDeal
//
//  Created by Raj Kumar Sharma on 22/10/16.
//  Copyright © 2016 Krati Agarwal. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo


+ (id)sharedManager
{
    static id sharedManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

+ (UserInfo *)getDefaultInfo {
    
    UserInfo *info = [[UserInfo alloc] init];
    
    info.userNameString = @"";
    info.fullNameString = @"";
    info.emailString = @"";
    info.phoneString = @"";
    info.passwordString = @"";
    info.confirmPasswordString = @"";
    info.countryString = @"";
    info.stateString = @"";
    info.cityString = @"";
    info.zipCodeString = @"";
    info.descriptionString = @"";
    info.accessCodeString = @"";
    info.dateOfBirthString =@"";
    info.userTypeString =@"";
    info.organisationString =@"";
    info.oldPasswordString = @"";
    info.firstTextfield = @"";
    info.secondTextfield = @"";
    info.streetString = @"";
    
    return info;
}

+ (NSMutableArray *)parseDataForCountryList:(NSMutableArray*)countryArray{
    
    NSMutableArray *countryArrayList = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in countryArray) {
        UserInfo *countryObj = [[UserInfo alloc] init];
        countryObj.counrtyId = [dic objectForKeyNotNull:@"id" expectedObj:@""];
        countryObj.countryISOName = [dic objectForKeyNotNull:@"iso_name" expectedObj:@""];
        countryObj.counrtyISOCode = [dic objectForKeyNotNull:@"iso" expectedObj:@""];
        countryObj.CountryISOCodeName = [dic objectForKeyNotNull:@"iso3" expectedObj:@""];
        countryObj.Countrynumcode = [dic objectForKeyNotNull:@"numcode" expectedObj:@""];
        [countryArrayList addObject:countryObj];
    }
    return countryArrayList;
}

+ (NSMutableArray *)parseDataForStateList:(NSMutableArray*)stateArray{
    
    NSMutableArray *stateArrayList = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *dic in stateArray) {
        UserInfo *stateObj = [[UserInfo alloc] init];
        stateObj.stateId = [dic objectForKeyNotNull:@"id" expectedObj:@""];
        stateObj.stateISOName = [dic objectForKeyNotNull:@"name" expectedObj:@""];
        [stateArrayList addObject:stateObj];
    }
    return stateArrayList;
}

@end
