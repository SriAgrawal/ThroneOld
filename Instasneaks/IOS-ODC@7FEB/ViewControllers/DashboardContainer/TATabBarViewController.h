//
//  TATabBarViewController.h
//  Throne
//
//  Created by Shridhar Agarwal on 13/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TATabBarViewController : UIViewController

@property (nonatomic, assign) BOOL isfromOnboard;
@property (nonatomic, assign) BOOL isCategoryList;
@property (nonatomic, assign) BOOL isFromServiceListing;
@property(nonatomic,strong) NSString* navLblString;
@property(nonatomic,strong) NSString* categoryId;

-(void)setSelectedViewControllerWithIndex:(NSInteger)index;

@end
