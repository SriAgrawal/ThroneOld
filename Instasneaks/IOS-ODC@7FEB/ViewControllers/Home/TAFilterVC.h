//
//  TAFilterVC.h
//  Throne
//
//  Created by Priya Sharma on 16/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAFilterInfo.h"

@protocol navigationDelegateForFilter <NSObject>
- (void)manageTheNavigation:(NSMutableArray*)arrayForFilterObj filterPreference:(TAFilterInfo *)parameter;
- (void)manageTheNavigation:(NSMutableArray*)arrayForFilterObj;
@end
@interface TAFilterVC : UIViewController
@property (nonatomic, weak) id <navigationDelegateForFilter> delegateForFilter;
@property (assign, nonatomic) BOOL isFromHome;
@property (strong,nonatomic)NSString * categoryId;
@property (strong,nonatomic)NSMutableArray * categoryPassedArray;
@property (strong,nonatomic)NSMutableDictionary * filterDict;

@end
