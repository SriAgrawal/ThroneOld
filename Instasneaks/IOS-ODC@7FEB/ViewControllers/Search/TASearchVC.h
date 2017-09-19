//
//  TASearchVC.h
//  Throne
//
//  Created by Suresh patel on 29/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TASearchVC : UIViewController

@property (assign, nonatomic) BOOL      isForProduct;
@property (assign, nonatomic) BOOL      isFromCategoryDetail;
@property (strong, nonatomic) NSString  * categoryId;

@end
