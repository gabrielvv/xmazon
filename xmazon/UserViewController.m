//
//  OrdersViewController.m
//  xmazon
//
//  Created by SEDRAIA on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "JZUser.h"
#import "MyOAuthManager.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Account";
    JZUser* user = [JZUser sharedUser];
    self.username.text = user.username;
    self.lastname.text = user.lastname;
    self.firstname.text = user.firstname;
    self.email.text = user.email;

    
    // Do any additional setup after loading the view from its nib.
    //Création du bouton Deconnexion
    UIBarButtonItem* deconnectButton = [[UIBarButtonItem alloc] initWithTitle:@"Deconnexion" style:UIBarButtonItemStylePlain target:self action:@selector(onTouchDeconnectButton)];
    
    self.navigationItem.rightBarButtonItems = @[deconnectButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onTouchDeconnectButton{
    NSLog(@"Touch deconnect");
    
    [[JZUser sharedUser] eraseProperties];
    LoginViewController* login = [LoginViewController new];
    [[MyOAuthManager sharedManager] eraseTokens];
    UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:login];

    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.window makeKeyAndVisible];
    app.window.rootViewController = navCtrl;

}

@end
