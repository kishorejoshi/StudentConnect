//
//  ContactInfoViewController.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/13/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@interface ContactInfoViewController : UITableViewController<UITextFieldDelegate,UITableViewDelegate,BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textMajor;
@property (weak, nonatomic) IBOutlet UITextField *textAboutMe;

//- (IBAction)buttonSave:(id)sender;

@end
