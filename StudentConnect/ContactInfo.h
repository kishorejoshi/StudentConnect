//
//  ContactInfo.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/28/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject
@property (nonatomic, retain) NSString* FullName;
@property (nonatomic, retain) NSString* Major;
@property (nonatomic, retain) NSString* School;
@property (nonatomic, retain) NSString* EmailAddress;
@property (nonatomic, retain) NSString* PhoneNumber;
@property (nonatomic, retain) NSString* About;
@property (nonatomic, retain) NSString* Interests;
@property (nonatomic, retain) NSString* PreferredContactMethod;
@property (nonatomic, retain) NSString* RequesterID;
@property (nonatomic, retain) NSDate* LastUpdated;
@end
