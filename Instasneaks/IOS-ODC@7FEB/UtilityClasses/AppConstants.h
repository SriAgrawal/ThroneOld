//
//  AppConstants.h
//  Coachify
//
//  Created by Raj Kumar Sharma on 09/11/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#ifndef AppConstants_h
#define AppConstants_h

typedef enum content {
    TermsCondition,
    PrivacyPolicy,
    Contact,
    FAQ,
} ContentType;

typedef enum sizeInformation {
    gender,
    topSize,
    shoeSize,
    bottomSize,
} sizeType;

typedef enum TotalSales {
    inventory,
    profit,
    sales,
    analytics,
} salesType;


typedef enum UserTask {
    Home,
    Discover,
    Search,
    Profile
} UserTaskType;

typedef enum layout {
    Grid,
    List,
} layoutType;

typedef enum OrderInfoType {
    order,
    payment,
    wallet,
    shipping,
} orderType;

typedef enum StoreDetailOptions {
    ALL,
    FORSALE,
    SOLD
} StoreDetailType;

typedef enum PersonalInfo {
    Email,
    Website,
    Location,
    Phone,
    Social,
    Tagline,
    Password,
    Bio
} PersonalType;

//@@@ Static Constants
static NSString *kIsTutorialVisited  = @"isTutorialVisited";
static NSString *pTitle = @"title";
static NSString *pPopUp = @"popUp";

static NSString *pIcon = @"icon";
static NSString *pSubArray = @"subArray";
static NSString *pLevel = @"level";
static NSString *pTutorialImage = @"tutorialImage";
static NSString *pStatus = @"productStatus";
static NSString *pSkip = @"fromSkip";


//@@@ Storyboards

static NSString *mainStoryboardString = @"Main";
static NSString *profileStoryboardString = @"Profile";
static NSString *settingStoryboardString = @"Settings";
static NSString *homeStoryboardString = @"Home";
static NSString *discoverStoryboardString = @"Discover";
static NSString *searchStoryboardString = @"Search";
static NSString *dashboardContainerStoryboardString = @"DashboardContainer";
static NSString *categoryStoryboardString = @"Category";
static NSString *purchaseStoryboardString = @"Purchase";
static NSString *storeStoryboardString = @"Store";


//@@@ Storyboards Segues
static NSString *unwindToLoginVCSegue = @"unwindToLoginVCSegue";

//Instabug Key

static NSString *instaBugKey = @"5fc4c66c1232932da2eb9a87694592d3";

#endif /* AppConstants_h */
