//
//  TATrendingSearchResultsVC.h
//  Throne
//
//  Created by Suresh patel on 04/04/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@class TASearchHeaderView;

@interface TATrendingSearchResultsVC : UIViewController

@property (strong, nonatomic) TASearchHeaderView    * headerView;
@property (assign, nonatomic) BOOL      isFromCategoryDetail;
@property (strong, nonatomic) NSString  * categoryId;

@end
