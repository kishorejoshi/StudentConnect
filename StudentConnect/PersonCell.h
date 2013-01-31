//
//  PersonCell.h
//  StudentConnect
//
//  Created by Kishore Joshi on 1/29/13.
//  Copyright (c) 2013 Kishore Joshi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *textTitle;
@property (weak, nonatomic) IBOutlet UITextView *textDescription;
@end
