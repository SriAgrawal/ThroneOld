//
//  TASearchTagsCell.h
//  Throne
//
//  Created by Suresh patel on 30/12/16.
//  Copyright © 2016 Shridhar Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Macro.h"

@interface TASearchTagsCell : UITableViewCell

@property (nonatomic, copy) NSArray *tags;
@property (nonatomic, weak) IBOutlet JCTagListView *tagListView;

@end
