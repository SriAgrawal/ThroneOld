//
//  TAStoreDetailsVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 23/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TAStoreDetailsVC : UIViewController

@property (assign,nonatomic) layoutType layoutSet;
@property (assign, nonatomic) StoreDetailType storeType;
@property (strong, nonatomic) NSString          *storeId;
@end
