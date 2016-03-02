//
//  LoginViewController.h
//  xmazon
//
//  Created by SEDRAIA on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userNameField;

@property (weak, nonatomic) IBOutlet UITextField *passField;

@property (weak, nonatomic) IBOutlet UIButton *connexionButton;

@property (weak, nonatomic) IBOutlet UIButton *createUserButton;

@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end
