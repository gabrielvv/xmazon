//
//  LoginViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "LoginViewController.h"
#import "CreateUserViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchConnexion:(id)sender {
    NSLog(@"Connexion");
    //Tentative de connexion avec username et password
    //Si successful -> stockage identifiants et envoi vers page d'accueil
}

- (IBAction)onTouchCreate:(id)sender {
    CreateUserViewController* c = [CreateUserViewController new];
    
    [self.navigationController pushViewController:c animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
