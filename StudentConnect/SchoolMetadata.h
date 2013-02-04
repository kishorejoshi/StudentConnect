//
//  SchoolMetadata.h
//  StudentConnect
//
//  Created by Kishore Joshi on 2/3/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchoolMetadata : NSObject
@property (nonatomic, retain) NSString* Alias;
@property (nonatomic, retain) NSString* Passcode;
+(SchoolMetadata *)getInstance;
@end
