//
//  PositionViewController.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/28/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PositionViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *StaticTableView;
@property (weak, nonatomic) IBOutlet UITableView *DynamicTableView;

@end
