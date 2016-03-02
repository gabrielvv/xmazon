//
//  LoginViewController.m
//  xmazon
//
//  Created by SEDRAIA on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "LoginViewController.h"
#import "CreateUserViewController.h"
#import "StoreViewController.h"
#import "myOAuthManager.h"
#import "GVUser.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Login";
    self.errorMessage.hidden = YES;
    GVUser* user = [GVUser sharedUser];
    self.userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.userNameField.text = user.email;
    self.passField.autocorrectionType = UITextAutocorrectionTypeNo;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchConnexion:(id)sender {
    NSLog(@"Connexion");
    //Tentative de connexion avec username et password
    //Si successful -> stockage identifiants, chargement de la page d'accueil et requête pour obtenir les stores
    void (^myBlock)() = ^(){

        TabBarViewController* tabBar = [TabBarViewController new];
        
//        UIWindow* w =[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        [w makeKeyAndVisible];
        UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:tabBar];

        [navCtrl setNavigationBarHidden:true];
//        w.rootViewController = [[UINavigationController alloc] initWithRootViewController:tabBar];
//        app.window = w;
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        [app.window makeKeyAndVisible];
        app.window.rootViewController = navCtrl;
        
        StoreViewController* storeCtrl = (StoreViewController*)[[[tabBar viewControllers] objectAtIndex:0] topViewController];

        void (^sc)(NSDictionary*) = ^(NSDictionary* response){
            storeCtrl.stores = [response objectForKey:@"result"];
            [[NSUserDefaults standardUserDefaults] setObject:storeCtrl.stores forKey:@"stores"];
            [storeCtrl.storeTableView reloadData];
        };
        
        [tabBar setSelectedIndex:0];
        
        [[myOAuthManager sharedManager] getStoreListWithSuccessCallback:sc errorCallback: nil];
    };
    
    void (^ec)() = ^(){
        self.errorMessage.hidden = NO;
    };
    
    [[myOAuthManager sharedManager] getAndSetOAuthTokenForUser:false username:self.userNameField.text password:self.passField.text successCallback:myBlock errorCallback:ec];
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
