//
//  TATrendingStoriesTVC.h
//  Throne
//
//  Created by Shridhar Agarwal on 31/01/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TATrendingStoriesTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet FXPageControl *pageControll;

@end
