//
//  AppDelegate.m
//  Throne
//
//  Created by Shridhar Agarwal on 15/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Instabug/Instabug.h>
#import <Leanplum/Leanplum.h>
#import "Branch.h"
#import "Macro.h"

@interface AppDelegate ()
{
    BOOL isDeepLink;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ZDKLogger enable:YES];
    [self setUpFacebookSdk:application andLaunhOption:launchOptions];
    [self setUpInstabugSdk];
    [self setUpBrainTreeSdk];
    [self setUpZenDeskSdk];
    [self setUpLeanplumSdk];
    [self setUpFlurrySdk];
    [self setUpBranchSdk:launchOptions];
    [self setUpHockeySdk];
    
    [self checkReachability];
    [self initialMethodToSetRootView];
    [self registerDeviceForNotification];
    self.window.backgroundColor = [UIColor whiteColor];
    [Fabric with:@[[Crashlytics class]]];
       return YES;
}

-(void)manageDeepLink:(id)object{

    
    isDeepLink = NO;
    if([object isEqualToString:@"manual"]){
    
        if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {
            for (UIViewController *tabBarVC in _navigationController.viewControllers) {
                if ([tabBarVC isKindOfClass:[TATabBarViewController class]]) {
                    
                    if ([tabBarVC isKindOfClass:[TADiscoverVC class]])
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    }
                    else
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                        [self.tabBarController setSelectedViewControllerWithIndex:302];
                    }
                }
            }
        }
        else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            for (UIViewController *tabBarVC in _navigationController.viewControllers) {
                if ([tabBarVC isKindOfClass:[TATabBarViewController class]]) {
                    
                    if ([tabBarVC isKindOfClass:[TADiscoverVC class]])
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    }
                    else
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                        [self.tabBarController setSelectedViewControllerWithIndex:302];
                    }
                }
            }
        }
    }
    else{
    
        if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground || [UIApplication sharedApplication].applicationState == UIApplicationStateInactive)
        {
            for (UIViewController *tabBarVC in _navigationController.viewControllers) {
                if ([tabBarVC isKindOfClass:[TATabBarViewController class]]) {
                    
                    if ([tabBarVC isKindOfClass:[TAProductDetailVC class]])
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    }
                    else
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                        TAProductDetailVC *productVC = (TAProductDetailVC *)[storyboardForName(homeStoryboardString)instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
                        productVC.productId = @"29";
                        [self.navigationController pushViewController:productVC animated:YES];
                    }
                }
            }
        }
        else if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
        {
            for (UIViewController *tabBarVC in _navigationController.viewControllers) {
                if ([tabBarVC isKindOfClass:[TATabBarViewController class]]) {
                    
                    if ([tabBarVC isKindOfClass:[TAProductDetailVC class]])
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    }
                    else
                    {
                        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                        TAProductDetailVC *productVC = (TAProductDetailVC *)[storyboardForName(homeStoryboardString)instantiateViewControllerWithIdentifier:@"TAProductDetailVC"];
                        productVC.productId = @"34";
                        [self.navigationController pushViewController:productVC animated:YES];
                    }
                }
            }
        }
    }
}
-(void)registerDeviceForNotification{
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } 
}

-(void)initialMethodToSetRootView{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    TAOnBoardVC * onBoardVC = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TAOnBoardVC"];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:onBoardVC];
    [self.window setRootViewController:self.navigationController];
    [self.window makeKeyAndVisible];
}


- (void)logOut {
    
    //[NSUSERDEFAULT removeObjectForKey:p_id];
    //[NSUSERDEFAULT removeObjectForKey:pEmail];
    //[NSUSERDEFAULT removeObjectForKey:pPassword];
}

-(void)navigateToHomeScreenOnController:(UINavigationController *)navController withAnimation:(BOOL)isAnimate{
    
    NSLog(@"%@",navController.viewControllers);
    for (UIViewController *tabBarVC in navController.viewControllers) {
        if ([tabBarVC isKindOfClass:[TATabBarViewController class]]) {
            [self.tabBarController setIsfromOnboard:YES];
            [self.navigationController popToViewController:tabBarVC animated:YES];
        }
       else if ([tabBarVC isKindOfClass:[TAHomeViewController class]]) {
            [self.tabBarController setIsfromOnboard:YES];
            [self.navigationController popToViewController:tabBarVC animated:YES];
        }
        else
        {
            self.tabBarController = [storyboardForName(mainStoryboardString) instantiateViewControllerWithIdentifier:@"TATabBarViewController"];
            [self.tabBarController setIsfromOnboard:isAnimate];
            [navController pushViewController:self.tabBarController animated:isAnimate];
        }
    }
}

- (void)checkReachability {
    
    Reachability * reach = [Reachability reachabilityForInternetConnection];
    self.isReachable = [reach isReachable];
    reach.reachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = YES;
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability * reachability) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isReachable = NO;
            
        });
    };
    
    [reach startNotifier];
}

#pragma mark- SDK SETUP METHODS

- (void)setUpFacebookSdk:(UIApplication *)application andLaunhOption:(NSDictionary *)launchOptions{
    /*--------------- Facebook ---------------------*/
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}
- (void)setUpInstabugSdk{
    //Instabug Key
    [Instabug startWithToken:@"d406768bbf376c678a92c3962361731b" invocationEvent:IBGInvocationEventShake];
}
- (void)setUpBrainTreeSdk{
    //BRAIN TREE Key
    [BTAppSwitch setReturnURLScheme:@"com.throneappdevelopment"];
    //[BTAppSwitch setReturnURLScheme:@"com.InstasneaksDistribution"];
}
- (void)setUpLeanplumSdk{
    //LeanPulm SDK Code
#ifdef DEBUG
    LEANPLUM_USE_ADVERTISING_ID;
    [Leanplum setAppId:@"app_ZcEDurPYUtsn6Ltyz1imE2IfPX70tuxEQVz4dKRd4tA"
    withDevelopmentKey:@"dev_WdPQNDB6BIQReT6krmeA4wuWKUngef6jH2GURCGfDCM"];
#else
    [Leanplum setAppId:@"app_ZcEDurPYUtsn6Ltyz1imE2IfPX70tuxEQVz4dKRd4tA"
     withProductionKey:@"prod_hDM4H7vGrU5IXXxXTwkJD32PeikFCLsdWLRkzaim1Tk"];
#endif
    [Leanplum start];
    [Leanplum trackAllAppScreens];
}
- (void)setUpZenDeskSdk{
    //Zendesk Support SDK
    [[ZDKConfig instance]
     initializeWithAppId:@"0a339f170c298c260ca44c4a7ddeb99b58cd45eece69e694"
     zendeskUrl:@"https://throne1.zendesk.com"
     clientId:@"mobile_sdk_client_f9c38b1a29e88682ebb0"];
    
    ZDKAnonymousIdentity * identity = [ZDKAnonymousIdentity new];
    [[ZDKConfig instance] setUserIdentity:identity];

}
- (void)setUpFlurrySdk{
    //Flurry SDK
    [Flurry setDebugLogEnabled:YES];
    [Flurry startSession:@"DQJWQYDMSXSGMVT753JS"];
    [Flurry logEvent:@"logEvent: app just started"];
    
}
- (void)setUpHockeySdk{
    //Hockey App SDK
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"6c3d1d77426e43ef8b2e70e077f4ec40"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
}
- (void)setUpBranchSdk:(NSDictionary *)launchOptions{
    //Branch
    Branch *branch = [Branch getInstance];
    //    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
    // if you want to specify isReferrable, then comment out the above line and uncomment this line:
    [branch initSessionWithLaunchOptions:launchOptions isReferrable:YES andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
        if (!error)
        {
            if (isDeepLink == YES)
            {
                // params are the deep linked params associated with the link that the user clicked before showing up
                // params will be empty if no data found
                NSLog(@"param-->%@",params.description);
                [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                NSArray *linkData = [[params objectForKeyNotNull:@"manualId" expectedObj:@""] componentsSeparatedByString:@"="];
                NSLog(@"param-->%@",[linkData lastObject]);
                [self performSelector:@selector(manageDeepLink:) withObject:[linkData lastObject] afterDelay:5.0];
            }
        }
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.throneappdevelopment"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url options:options];
    }
//    if ([url.scheme localizedCaseInsensitiveCompare:@"com.mobiloitte"] == NSOrderedSame) {
//        return [BTAppSwitch handleOpenURL:url options:options];
//    }
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    // Add any custom logic here.
    return handled;
}

// If you support iOS 7 or 8, add the following method.
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //brain tree
    if ([url.scheme localizedCaseInsensitiveCompare:@"com.throneappdevelopment"] == NSOrderedSame) {
        return [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
    }
//    if ([url.scheme localizedCaseInsensitiveCompare:@"com.mobiloitte"] == NSOrderedSame) {
//        return [BTAppSwitch handleOpenURL:url sourceApplication:sourceApplication];
//    }
    //facebook
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    //branch
    //handled =[[Branch getInstance] handleDeepLink:url];
    
    return handled;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
    isDeepLink = handledByBranch;
    
    return handledByBranch;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
}

@end
