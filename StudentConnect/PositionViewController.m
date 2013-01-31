//
//  PositionViewController.m
//  StudentConnect
//
//  Created by Kishore Joshi on 1/28/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "PositionViewController.h"
#import "Position.h"    
#import "PositionCell.h"
#import <RestKit/RestKit.h>
#define NUMBER_OF_SECTION 1

@interface PositionViewController ()

@property (strong, nonatomic) NSArray *positionData;

@end

@implementation PositionViewController

@synthesize StaticTableView,DynamicTableView;
@synthesize positionData;

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

    NSURL *baseURL =[NSURL URLWithString:@"http://studentconnect.apphb.com/api/"];
    AFHTTPClient* client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    [client setDefaultHeader:@"Content-Length" value:@"0"];
    
    
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"application/json"];
    
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Position class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
    
     @"Title":@"Title",
      @"Description":@"Description"
     
     }];
    
    [objectManager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                                                  pathPattern:nil
                                                                                      keyPath:nil
                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager postObject:nil  path:@"positiondetails"
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                          positionData = mappingResult.array;
                          if(self.isViewLoaded)
                              [DynamicTableView reloadData];
                          
                          
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
    return NUMBER_OF_SECTION;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableView == StaticTableView){
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    else{
        return positionData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == StaticTableView) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    PositionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PositionCell"];
    Position *position = [positionData objectAtIndex:indexPath.row];
    cell.textDescription.text = position.Description;
    cell.textTitle.text = position.Title;
    
    /*CGRect frame = cell.textDescription.frame;
    frame.size.height = cell.textDescription.contentSize.height;
    cell.textDescription.frame = frame;
    // Configure the cell...
    
    CGRect cellFrame = cell.frame;
    cellFrame.size.height = frame.size.height + 40;
    cell.frame = cellFrame;*/
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == StaticTableView) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 122;
}

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
