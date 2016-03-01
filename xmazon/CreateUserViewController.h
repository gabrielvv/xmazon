//
//  CreateUserViewController.h
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateUserViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UILabel *passOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *passTwoLabel;
@property (weak, nonatomic) IBOutlet UITextField *passOne;
@property (weak, nonatomic) IBOutlet UITextField *passTwo;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end
