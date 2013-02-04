//
//  SchoolMetadata.m
//  StudentConnect
//
//  Created by Kishore Joshi on 2/3/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "SchoolMetadata.h"

@implementation SchoolMetadata

@synthesize Alias,Passcode;

static SchoolMetadata *instance = nil;

+ (SchoolMetadata *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [SchoolMetadata new];
        }
    }
    return instance;
}
@end
