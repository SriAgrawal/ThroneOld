//
//  TAProductDetailVC.h
//  Throne
//
//  Created by Suresh patel on 28/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAProductDetailVC : UIViewController

@property (strong, nonatomic) NSString      * productId;
@property (strong, nonatomic) NSString      * productName;
@property (assign, nonatomic) BOOL            isForBuy;
@property (assign, nonatomic) BOOL            isCommingFromService;

@end
