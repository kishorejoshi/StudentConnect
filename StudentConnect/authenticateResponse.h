//
//  authenticateResponse.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/31/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SchoolData.h"

@interface authenticateResponse : NSObject
@property (nonatomic, retain) NSString* IsValidated;
@property (nonatomic, retain) SchoolData* schooldata;
@end
