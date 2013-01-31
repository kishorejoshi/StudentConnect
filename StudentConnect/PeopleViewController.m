//
//  PeopleViewController.m
//  StudentConnect
//
//  Created by Kishore Joshi on 1/28/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "PeopleViewController.h"
#import <RestKit/RestKit.h>
#import "Person.h"
#import "PersonCell.h"
#define NUMBER_OF_SECTION 1

@interface PeopleViewController ()

@property (strong, nonatomic) NSArray *personData;

@end

@implementation PeopleViewController
@synthesize StaticTableView, DynamicTableView;
@synthesize personData;
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
    
    RKObjectMapping *objectMapping = [RKObjectMapping mappingForClass:[Person class]];
    
    [objectMapping addAttributeMappingsFromDictionary:@{
     @"DisplayOrder":@"DisplayNumber",
     @"Name":@"Name",
     @"BioLink":@"BioLink",
     @"ImageUrl":@"ImageUrl",
     @"Title":@"Title",
     @"MoreInfo":@"MoreInfo"
     
     }];
    
    [objectManager addResponseDescriptor: [RKResponseDescriptor responseDescriptorWithMapping:objectMapping
                                                                                  pathPattern:nil
                                                                                      keyPath:nil
                                                                                  statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)]];
    
    [objectManager postObject:nil  path:@"people"
                   parameters:nil
                      success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult){
                          personData = mappingResult.array;
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
        return personData.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == StaticTableView) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    PersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonCell"];
    Person *person = [personData objectAtIndex:indexPath.row];
    cell.textDescription.text = person.MoreInfo;
    cell.textTitle.text = person.Title;
    cell.textName.text = person.Name;
    // Configure the cell...
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == StaticTableView) {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 132;
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
