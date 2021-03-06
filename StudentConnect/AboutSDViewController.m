//
//  AboutSDViewController.m
//  StudentConnect
//
//  Created by Kishore Joshi on 1/13/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "AboutSDViewController.h"
#import <RestKit/RestKit.h>
#import "AboutContent.h"
#import "SchoolMetadata.h"

@interface AboutSDViewController ()

@end

@implementation AboutSDViewController

@synthesize textAboutSD = _textAboutSD;
@synthesize StaticTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.StaticTableView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    NSURL *baseURL =[NSURL URLWithString:@"http://studentconnect.apphb.com/api/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    //[client setDefaultHeader:@"Content-Length" value:@"0"];
    
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];

    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];

    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[AboutContent class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
     @"ImageUrl":@"textImageUrl",
     @"AboutUsHtml":@"textAboutUs"
     }];
    SchoolMetadata *schoolObj = [SchoolMetadata getInstance];
    
   [objectManager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                                    pathPattern:nil
                                                                    keyPath:nil
                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager postObject:nil  path:@"aboutcontent"
                         parameters:@{@"SchoolAlias":schoolObj.Alias}
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                                AboutContent *object = mappingResult.firstObject;
                                _textAboutSD.text = object.textAboutUs;
                                if (self.isViewLoaded) {
                                    [_textAboutSD reloadInputViews];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}*/

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
