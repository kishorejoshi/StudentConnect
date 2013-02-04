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
#import "authenticateResponse.h"
#import "SchoolMetadata.h"

@interface LoginViewController ()
/**
 *  Keyboard controls.
 */
@property (nonatomic, strong) BSKeyboardControls *keyboardControls;

/**
 *  Scroll view to text field.
 *  @param textField Text field to scroll to.
 */
- (void)scrollViewToTextField:(id)textField;
@end

@implementation LoginViewController

@synthesize textPasscode;
@synthesize textError;
@synthesize keyboardControls =_keyboardControls;

/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    //UITableViewCell *cell = (UITableViewCell *) ((UIView *) textField).superview.superview;
    //[self.StaticTableView scrollRectToVisible:cell.frame animated:YES];
}

#pragma mark -
#pragma mark BSKeyboardControls Delegate

/*
 * The "Done" button was pressed
 * We want to close the keyboard
 */
- (void)keyboardControlsDonePressed:(BSKeyboardControls *)controls
{
    [controls.activeTextField resignFirstResponder];
}

/* Either "Previous" or "Next" was pressed
 * Here we usually want to scroll the view to the active text field
 * If we want to know which of the two was pressed, we can use the "direction" which will have one of the following values:
 * KeyboardControlsDirectionPrevious        "Previous" was pressed
 * KeyboardControlsDirectionNext            "Next" was pressed
 */
/*- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}*/

#pragma mark -
#pragma mark Text Field Delegate

/* Editing began */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.keyboardControls.textFields containsObject:textField])
        self.keyboardControls.activeTextField = textField;
    [self scrollViewToTextField:textField];
}

#pragma mark -
#pragma mark Text View Delegate

/* Editing began */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.keyboardControls.textFields containsObject:textView])
        self.keyboardControls.activeTextField = textView;
    [self scrollViewToTextField:textView];
}


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
    // Initialize the keyboard control

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
     @"SchoolData.Alias":@"Alias",
     @"SchoolData.Passcode":@"Passcode",
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
                              
                              SchoolMetadata *schoolObj = [SchoolMetadata getInstance];
                              schoolObj.Alias = response.Alias;
                              schoolObj.Passcode = response.Passcode;
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
