//
//  LoginViewController.m
//  StudentConnect
//
//  Created by Kishore Joshi on 1/30/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"
#import  <RestKit/RestKit.h>
#import "SchoolData.h"
#import "PasscodeRequest.h"
#import "IsValidResponse.h"
#import "authenticateResponse.h"

@interface LoginViewController ()

@end
@implementation LoginViewController

@synthesize textPasscode;
@synthesize textError;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [textError setHidden:TRUE];

    [self.textPasscode setDelegate:self];
    [self.textPasscode setReturnKeyType:UIReturnKeyDone];
    [self.textPasscode addTarget:self
                       action:@selector(textFieldFinished:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (IBAction)textFieldFinished:(id)sender
{
     [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLogin:(id)sender {    
    
   NSURL *baseURL =[NSURL URLWithString:@"http://studentconnect.apphb.com/api/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [client setDefaultHeader:@"Content-Type" value:@"application/json"];
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    

    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
    
    RKObjectMapping *authResponse = [RKObjectMapping mappingForClass:[authenticateResponse class]];
    
    [authResponse addAttributeMappingsFromDictionary:@{
     @"Alias":@"Alias",
     @"Passcode":@"Passcode",
     @"IsValidated":@"IsValidated"
     }];
    
    [objectManager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:authResponse 
                                                                                  pathPattern:nil
                                                                                      keyPath:nil
                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];

    
    [objectManager postObject:nil  path:@"authenticate"
                   parameters:@{@"passcode" : textPasscode.text}
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                          NSLog(@"Authentication api success!!!");
                          authenticateResponse* response = mappingResult.firstObject;
                          if([response.IsValidated isEqualToString:@"true"])
                          {
                              TabBarViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarControl"];
                              [self.navigationController pushViewController:controller animated:YES];
                          }
                          else
                          {
                              [textError setHidden:FALSE];
                          }
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Validating"
                                                                          message:[error localizedDescription]
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          [alert show];
                          NSLog(@"Login authentication error: %@", error);
                      }
     ];
    
}

@end
