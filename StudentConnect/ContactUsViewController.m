//
//  ContactUsViewController.m
//  StudentConnect
//
//  Created by Kishore Joshi on 1/6/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "ContactUsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ContactInfo.h"
#import "SchoolMetadata.h"
#import "ContactInfoResponse.h"

#define SCROLL_VIEW_ANIMATION_DURATION 0.25

@interface ContactUsViewController ()

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

@implementation ContactUsViewController

@synthesize textName = _textName,
            textEmail = _textEmail,
            textPhone = _textPhone,
            textMajor = _textMajor,
            textAboutMe= _textAboutMe,
            switchProgram = _switchProgram,
            switchSoftware = _switchSoftware,
            keyboardControls = _keyboardControls,
            StaticTableView;


/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    UITableViewCell *cell = (UITableViewCell *) ((UIView *) textField).superview.superview;
    [self.StaticTableView scrollRectToVisible:cell.frame animated:YES];
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
- (void)keyboardControlsPreviousNextPressed:(BSKeyboardControls *)controls withDirection:(KeyboardControlsDirection)direction andActiveTextField:(id)textField
{
    [textField becomeFirstResponder];
    [self scrollViewToTextField:textField];
}

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

#pragma mark -
#pragma mark View lifecycle

/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.StaticTableView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    _textAboutMe.layer.borderWidth = 0.5f;
    _textAboutMe.layer.borderColor = [[UIColor grayColor] CGColor];
    _textAboutMe.layer.cornerRadius = 5;
    _textAboutMe.clipsToBounds = YES;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Initialize the keyboard controls
    self.keyboardControls = [[BSKeyboardControls alloc] init];
    
    // Set the delegate of the keyboard controls
    self.keyboardControls.delegate = self;
    
    // Add all text fields you want to be able to skip between to the keyboard controls
    // The order of thise text fields are important. The order is used when pressing "Previous" or "Next"
    self.keyboardControls.textFields = [NSArray arrayWithObjects:self.textName,
                                        self.textEmail,
                                        self.textPhone,
                                        self.textMajor,
                                        self.textAboutMe,nil];
    
    // Add the keyboard control as accessory view for all of the text fields
    // Also set the delegate of all the text fields to self
    [self.keyboardControls reloadTextFields];
    
    
}

/*- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

//#pragma mark - Table view data source

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

//#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
//}

//textView about me delegate to clear the default text
//textview on focus delegate
/*- (BOOL)textViewShouldBeginEditing:(UITextView *)textAboutMe
{
    //on focus
    if([textAboutMe.text isEqualToString:@"Tell Us about Yourself!!!"])
    {
        textAboutMe.text = @"";
    }
    return YES;
}

//textview on lost focus delegate
- (BOOL)textView:(UITextView *)textAboutMe shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        //Lost Focus
        textAboutMe.text =@"Tell Us about Yourself!!!";
        [textAboutMe resignFirstResponder];
    }
    return YES;
}*/


/*- (void)viewDidUnload
{
    [self setTextName:nil];
    [self setTextEmail:nil];
    [self setTextPhone:nil];
    [self setTextMajor:nil];
    [self setTextAboutMe:nil];
    
    [super viewDidUnload];
}*/


- (IBAction)buttonSave:(id)sender {
   
    
    NSURL *baseURL =[NSURL URLWithString:@"http://studentconnect.apphb.com/api/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
    
    SchoolMetadata *schoolObj = [SchoolMetadata getInstance];
    NSDate* currentDate = [NSDate date];
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    
    ContactInfo *contactinfo = [[ContactInfo alloc] init];
    contactinfo.FullName = _textName.text;
    contactinfo.EmailAddress = _textEmail.text;
    contactinfo.PhoneNumber = _textPhone.text;
    contactinfo.Major =_textMajor.text;
    contactinfo.LastUpdated = [currentDate description];
    contactinfo.PreferredContactMethod = @"Email";
    contactinfo.School = schoolObj.Alias;
    contactinfo.About = _textAboutMe.text;
    contactinfo.Interests = @"Software developer";
    
    if(_switchSoftware.isOn)
    {
        contactinfo.Interests = @"Software Developer";
    }
    if(_switchProgram.isOn)
    {
        contactinfo.Interests = [NSString stringWithFormat:@"%@%@%@",contactinfo.Interests, @"|", @"Program Manager"];
    }
    
    
    contactinfo.RequesterID = (__bridge NSString *)CFUUIDCreateString(NULL,uuidRef);
    
    
    
    RKObjectMapping *responseObjMapping = [RKObjectMapping mappingForClass:[ContactInfoResponse class]];
    
    [responseObjMapping addAttributeMappingsFromDictionary:@{
     @"result":@"result"     
     }];
    
    [objectManager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:responseObjMapping
                                                                                  pathPattern:nil
                                                                                      keyPath:nil
                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager postObject:contactinfo  path:@"SaveContact"
                   parameters:@{@"FullName":contactinfo.FullName,
                                @"Major":contactinfo.Major,
                                @"EmailAddress":contactinfo.EmailAddress,
                                @"School":contactinfo.School,
                                @"PhoneNumber":contactinfo.PhoneNumber,
                                @"About":contactinfo.About,
                                @"Interests":contactinfo.Interests,
                                @"PreferredContactMethod":contactinfo.PreferredContactMethod,
                                @"RequesterID":contactinfo.RequesterID,
                                @"LastUpdated":contactinfo.LastUpdated}
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                          ContactInfoResponse *response = mappingResult.firstObject;
                          if ([response.result isEqualToString:@"success"]) {
                              
                          
                          
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You!"
                                                                          message:@"Your information is submitted."
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                              [alert show];
                           
                           }
                        
                          
                      }
                      failure:^(RKObjectRequestOperation *operation, NSError *error) {
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error getting into"
                                                                          message:[error localizedDescription]
                                                                         delegate:nil
                                                                cancelButtonTitle:@"OK"
                                                                otherButtonTitles:nil];
                          [alert show];
                          NSLog(@"Hit error: %@", error);
                      }
     ];
    CFRelease(uuidRef);
}
@end
