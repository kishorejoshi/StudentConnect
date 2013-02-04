//
//  PreferredContactViewController.h
//  StudentConnect
//
//  Created by Kishore Joshi on 2/2/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferredContactViewController : UITableViewController<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *PreferredStaticTableView;
@property (weak, nonatomic) IBOutlet UIPickerView *PreferrefPicker;
@property (nonatomic) NSMutableArray *arrayContacts;
@end
