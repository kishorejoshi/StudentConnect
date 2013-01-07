//
//  ContactUsViewController.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/6/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSKeyboardControls.h"

@interface ContactUsViewController : UITableViewController<UITextFieldDelegate,UITableViewDelegate,BSKeyboardControlsDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textName;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPhone;
@property (weak, nonatomic) IBOutlet UITextField *textMajor;
@property (weak, nonatomic) IBOutlet UITextView *textAboutMe;

@end
