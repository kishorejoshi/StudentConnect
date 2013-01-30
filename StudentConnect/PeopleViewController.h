//
//  PeopleViewController.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/28/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITableView *DynamicTableView;
@property (strong, nonatomic) IBOutlet UITableView *StaticTableView;

@end
