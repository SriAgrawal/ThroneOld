//
//  NSDictionary+APIAddition.h
//  ProjectTemplate
//
//  Created by Raj Kumar Sharma on 20/05/16.
//  Copyright © 2016 Mobiloitte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (APIAddition)

- (id)objectForKeyNotNull:(id)key expectedObj:(id)obj;

+ (id)dictionaryWithContentsOfJSONURLData:(NSData *)JSONData;

- (NSData*)toNSData;
- (NSString *)toJsonString;

@end
