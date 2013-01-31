//
//  LoginViewController.m
//  StudentConnect
//
//  Created by Kishore Joshi on 1/30/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize textPasscode;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonLogin:(id)sender {
    
    if([textPasscode.text isEqualToString:@"nyupoly"]){
        TabBarViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"tabBarControl"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

@end
