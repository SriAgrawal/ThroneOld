//
//  AppDelegate.h
//  Throne
//
//  Created by Shridhar Agarwal on 15/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"
#import <ZendeskSDK/ZendeskSDK.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "Flurry.h"
#import <HockeySDK/HockeySDK.h>

@class TATabBarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController     *navigationController;
@property (strong, nonatomic) TATabBarViewController     *tabBarController;
@property(assign,nonatomic) BOOL shouldAddTimer;
@property(assign,nonatomic) int pageIndex;
@property (nonatomic, assign) BOOL       isReachable;
- (void)logOut;
-(void)navigateToHomeScreenOnController:(UINavigationController *)navController withAnimation:(BOOL)isAnimate;

@end

