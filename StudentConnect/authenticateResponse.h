//
//  authenticateResponse.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/31/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface authenticateResponse : NSObject
@property (nonatomic, retain) NSString* IsValidated;
@property (nonatomic, retain) NSString* Alias;
@property (nonatomic, retain) NSString* Passcode;
@end
