//
//  OrdersViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "OrdersViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "GVUser.h"
#import "myOAuthManager.h"

@interface OrdersViewController ()

@end

@implementation OrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"User Info";
    GVUser* user = [GVUser sharedUser];
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
    
    [[GVUser sharedUser] eraseProperties];
    LoginViewController* login = [LoginViewController new];
    [[myOAuthManager sharedManager] eraseTokens];
    UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:login];

    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.window makeKeyAndVisible];
    app.window.rootViewController = navCtrl;

}

@end
