//
//  Macro.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 19/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define KTextField(tag)             (UITextField*)[self.view viewWithTag:tag]
#define KButton(tag)                (UIButton *)[self.view viewWithTag:tag]
#define windowWidth                 [UIScreen mainScreen].bounds.size.width
#define windowHeight                [UIScreen mainScreen].bounds.size.height

#define KNSLOCALIZEDSTRING(key)     NSLocalizedString(key, nil)

#define APPDELEGATE                 (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define mainStoryboard              [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define storyboardForName(X)        [UIStoryboard storyboardWithName:X bundle:nil]

#define NSUSERDEFAULT               [NSUserDefaults standardUserDefaults]

#define AppColor                    [UIColor colorWithRed:229.0/255.0f green:88.0/255.0f blue:40.0/255.0f alpha:1.0f]
#define AppLightColor                    [UIColor colorWithRed:124.0/255.0f green:173.0/255.0f blue:200.0/255.0f alpha:1.0f]

#define AppFont(X)                  [UIFont systemFontOfSize:X]

#define DEGREES_TO_RADIANS(degrees) (M_PI * (degrees) / 180.0)

//log label

#define LOG_LEVEL           1

#define LogInfo(frmt, ...)                 if(LOG_LEVEL) NSLog((@"%s" frmt), __PRETTY_FUNCTION__, ## __VA_ARGS__)

#define RGBCOLOR(r,g,b,a)               [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define TRIM_SPACE(str)                 [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]


/****************** Validation Alerts ****************************/
#define             BLANK_FirstNAME                             "Please enter first name."
#define             Mini_FirstNAME                             "Please enter atleast two character of first name."
#define             BLANK_LastNAME                              "Please enter last name."
#define             Mini_LastNAME                             "Please enter atleast two character of last name."
#define             BLANK_EMAIL                                 "Please enter email address."
#define             BLANK_USERNAME                              "Please enter username."
#define             BLANK_PASSWORD                              "Please enter password."
#define             BLANK_REVIEW                                "Please enter review."
#define             VALID_FirstNAME                             "Please enter valid first name."
#define             VALID_LastNAME                             "Please enter valid last name."
#define             VALID_EMAIL                                 "Please enter valid email address."
#define             VALID_USERNAME                              "Please enter valid username."
#define             VALID_PHONE                                 "Please enter valid phone number"
#define             BLANK_PHONE                                 "Please enter phone number."
#define             BLANK_ADDRESS                               "Please enter address."
#define             BLANK_OLD_PASSWORD                          "Please enter old password."
#define             BLANK_NEW_PASSWORD                          "Please enter new password."
#define             BLANK_CONFIRM_PASSWORD                      "Please enter confirm password."
#define             VALID_PASSWORD                              "Password must be at least 6 characters."
#define             VALID_OLD_PASSWORD                          "Old password must be of atleast 6 characters."
#define             VALID_NEW_PASSWORD                          "New password must be of atleast 6 characters."
#define             PASSWORD_CONFIRM_PASSWORD_NOT_MATCH         "Password and confirm password must be same."
#define             BLANK_DOB                                    "Please select date of birth."
#define             BLANK_STORENAME                              "Please enter any store/brand name."
#define             VALID_URL                                    "Please enter valid website url."
#define             VALID_FacebookURL                            "Please enter valid facebook url."
#define             VALID_TwitterURL                             "Please enter valid twitter url."
#define             VALID_InstagramURL                           "Please enter valid instagram url."
#define             STREET_ADDRESS                               "Please enter street address."
#define             BLANK_CITY                               "Please enter city name."
#define             BLANK_STATE                               "Please select state name."
#define             BLANK_COUNTRY                               "Please select country name."
#define             BLANK_ZIP                               "Please enter ZIP code."
#define             Valid_ZIP                               "Zip code must be at least 5 characters."
#define             BLANK_EXPIRY                              "Please enter expiry date."
#define             BLANK_CARDNO                              "Please enter card number."
#define             BLANK_CVV                              "Please enter CVV."

#define RefreshAllSearchedResultData                            @"RefreshAllSearchedResultData"
#define RefreshTrendingSearchedResultData                       @"RefreshTrendingSearchedResultData"
#define RefreshProductSearchedResultData                        @"RefreshProductSearchedResultData"
#define RefreshStoresSearchedResultData                         @"RefreshStoresSearchedResultData"

#pragma mark - Frameworks

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "UIScrollView+EmptyDataSet.h"

#pragma mark - Modal Classes

#import "UserInfo.h"
#import "TACategoryInfo.h"
#import "TARequestCategoryInfo.h"
#import "TALikeInfo.h"
#import "TAProductInfo.h"
#import "TAFilterInfo.h"
#import "TAInviteFriendInfo.h"
#import "TAStoreInfo.h"
#import "TADiscoverInfo.h"
#import "TASizeInfo.h"
#import "TAPagination.h"
#import "TACheckOutInfo.h"

#pragma mark - External Classes

#import "TPKeyboardAvoidingTableView.h"
#import "MXSegmentedPager.h"
#import "MXSegmentedPagerController.h"
#import "ASJTagsView.h"
#import "ASJTag.h"
#import "HCSStarRatingView.h"
#import "JCTagListView.h"
#import "JCCollectionViewTagFlowLayout.h"
#import "AMPopTip.h"
#import "TTRangeSlider.h"
#import "FXPageControl.h"
#import "YTPlayerView.h"
#import "BDVCountryNameAndCode.h"
#import "KTSContactsManager.h"
#import "BraintreeCore.h"
#import "BraintreeUI.h"
#import "UIColor+HexString.h"


#pragma mark - Local Database Classes


#pragma mark - Web Services Helper Classes

#import "Reachability.h"
#import "MBProgressHUD.h"
#import "ServiceHelper.h"
#import "UIImageView+WebCache.h"

#pragma mark - Sub Classes

#import "IndexPathButton.h"
#import "TextField.h"
#import "GradientView.h"
#import "FRHyperLabel.h"
#import "TTTAttributedLabel.h"
#import "REFormattedNumberField.h"

#pragma mark - Category Classes

#import "NSString+Addition.h"
#import "UIView+Addition.h"
#import "UIViewController+Addition.h"
#import "UIImageView+Addition.h"
#import "UIImage+Addition.h"
#import "NSDictionary+APIAddition.h"
#import "NSDate+Addition.h"
#import "UIButton+Addition.h"

#pragma mark - Utility Files

#import "AppDelegate.h"
#import "AppUtility.h"
#import "ApiConstants.h"
#import "AlertController.h"
#import "OptionPickerManager.h"
#import "DatePickerManager.h"
#import "AppConstants.h"
#import "GIBadgeView.h"

#pragma mark - View Controllers

#import "TAOnBoardVC.h"
#import "TALoginVC.h"
#import "TASignUpVC.h"
#import "TAHomeViewController.h"
#import "TACategoryListVC.h"
#import "TAProductDetailVC.h"
#import "TASearchVC.h"
#import "TARequestCategoryVC.h"
#import "TAProfileContainerVC.h"
#import "TAFavoriteProductVC.h"
#import "TAFollowingItemVC.h"
#import "TAPurchagedItemVC.h"
#import "TATermsAndCondContainerVC.h"
#import "TATermsAndConditionsVC.h"
#import "TAForgotPasswordVC.h"
#import "TAOrderDetailsVC.h"
#import "TAMyWalletVC.h"
#import "TADiscoverVC.h"
#import "TAThankYouPopUpVC.h"
#import "TAProductDetailVC.h"
#import "TAAddShippingAddressVC.h"
#import "TACategoryDetailsVC.h"
#import "TAAddCreditCardVC.h"
#import "TATabBarViewController.h"
#import "TAPageStoreContainerViewController.h"
#import "TAStorePageViewController.h"
#import "TABecomeVendarVC.h"
#import "TAFilterVC.h"
#import "TAReferAFriendVC.h"
#import "TALikePopUpVC.h"
#import "TAPrivacyPolicyVC.h"
#import "TAPurchaseDetailsVC.h"
#import "TAInviteFriendsVC.h"
#import "TASkipLoginVC.h"
#import "TAThankYouPopUpRegisterVC.h"
#import "TAMoreVC.h"
#import "TAThanksVC.h"
#import "TAManualTagsVC.h"
#import "TADiscoverArticalVC.h"
#import "TAManualContainerVC.h"
#import "TAPortFolioVC.h"
#import "TAAvailabilityVC.h"
#import "TAWorkWithMeVC.h"
#import "TANotificationsVC.h"
#import "TAPersonalInfoVC.h"
#import "TATotalInventoryVC.h"
#import "TASizeInformationVC.h"
#import "TAPaymentVC.h"
#import "TAShippingVC.h"
#import "TAAddAddressVC.h"
#import "TACreditCardVC.h"
#import "TASocialMediaVC.h"
#import "TABioVC.h"
#import "TAMyOrderVC.h"
#import "TAselectionPopUp.h"
#import "TASettingsVC.h"
#import "TAStoresSearchResultsVC.h"
#import "TAProductsSearchResultsVC.h"
#import "TATrendingSearchResultsVC.h"
#import "TAAllSearchResultsVC.h"

#pragma mark - UIView

#import "TASearchHeaderView.h"
#import "TAProfileHeaderView.h"
#import "TATermsAndConditionsView.h"
#import "TAStorePageHeaderView.h"

#pragma mark - UITableViewCells

#import "TAAuthTableCell.h"
#import "TAProductDetailCell.h"
#import "TAProductDetailOptionsCell.h"
#import "TAViewedStoresCell.h"
#import "TATopViewedProductCell.h"
#import "TASearchResultContainerVC.h"
#import "TATrendingStoreTableCell.h"
#import "TAFeatureProductTableCell.h"
#import "TATrendingProductTableCell.h"
#import "TATrendingStoreGridTableCell.h"
#import "TASearchTagsCell.h"
#import "TAPurchagedItemCell.h"
#import "TAProductDetailsTVC.h"
#import "TASizeSelectionTVC.h"
#import "TAshippingMethodTVC.h"
#import "TASingleTextFieldTVC.h"
#import "TATwoTextFieldTVC.h"
#import "TAPaymentMethodTVC.h"
#import "TATotalTVC.h"
#import "TAFilterCategoryCell.h"
#import "TAFilterHeatIndexCell.h"
#import "TAPriceCell.h"
#import "TAOrderDetailsTableCell.h"
#import "TAMyWalletTableCell.h"
#import "TAStorePageCollectionViewCell.h"
#import "TAColorPickerCell.h"
#import "TAInviteFriendsTVC.h"
#import "TADiscoverListTVC.h"
#import "TATrendingStoriesTVC.h"
#import "TAExpandableCell.h"
#import "TASettingsNameCell.h"
#import "TAInventoryCell.h"
#import "TASocialTableCell.h"
#import "TABioCell.h"
#import "TAStayConnectCell.h"

#pragma mark - UICollectionViewCells
#import "TAOnBoardCollectionCell.h"
#import "TAHeaderCollectionCell.h"
#import "TACategoryCollectionCell.h"
#import "TAImageCollectionCell.h"
#import "TAMoreItemCollectionCell.h"
#import "TATrendingStoreCollectionCell.h"
#import "TAFeatureCollectionCell.h"
#import "TAFavoriteItemCollectionCell.h"
#import "TASizeSelectionCell.h"
#import "TASizeSelectionCell.h"
#import "TACategoryCollCell.h"
#import "TAHeatCollCell.h"
#import "TAColorPickerCollCell.h"
#import "TATrendingStoriesCollectionCell.h"
#import "TAAvailableCollectionCell.h"
#import "TASizeSectionHeaderView.h"

#endif /* Macro_h */
