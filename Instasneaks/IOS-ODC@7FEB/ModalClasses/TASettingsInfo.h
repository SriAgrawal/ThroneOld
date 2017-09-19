//
//  TASettingsInfo.h
//  Throne
//
//  Created by Anil Kumar on 03/03/17.
//  Copyright © 2017 Shridhar Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TASettingsInfo : NSObject
@property (assign, nonatomic) BOOL                    isSelected;
@property (assign, nonatomic) NSString              * sectionTitle;
@property (strong, nonatomic) NSMutableArray        * sectionsRowData;

@end
