//
//  ContactUsViewController.m
//  StudentConnect
//
//  Created by Kishore Joshi on 1/6/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "ContactUsViewController.h"

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
            keyboardControls = _keyboardControls;


/* Scroll the view to the active text field */
- (void)scrollViewToTextField:(id)textField
{
    UITableViewCell *cell = (UITableViewCell *) ((UIView *) textField).superview.superview;
    [self.tableView scrollRectToVisible:cell.frame animated:YES];
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

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
  //  return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
 //   return 0;
//}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}*/

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

- (void)viewDidUnload
{
    [self setTextName:nil];
    [self setTextEmail:nil];
    [self setTextPhone:nil];
    [self setTextMajor:nil];
    [self setTextAboutMe:nil];
    
    [super viewDidUnload];
}


@end
