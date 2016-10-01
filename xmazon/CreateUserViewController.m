//
//  CreateUserViewController.m
//  xmazon
//
//  Created by SEDRAIA on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "CreateUserViewController.h"
#import "StoreViewController.h"
#import "MyOAuthManager.h"
#import "JZUser.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"

@interface CreateUserViewController () <UITextFieldDelegate>

@end

@implementation CreateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create account";
    self.userName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastName.autocorrectionType = UITextAutocorrectionTypeNo;
//    MyOAuthManager* sharedManager = [MyOAuthManager sharedManager];
//    [sharedManager getStoreList];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchCreate:(id)sender {
    
    self.userNameLabel.hidden = YES;
    self.passOneLabel.hidden = YES;
    self.passTwoLabel.hidden = YES;
    self.errorMessage.hidden = YES;
    
//    NSLog(@"create");
//    NSLog(@"username :%@", self.userName.text);
    NSLog(@"Comparison result: %ld", (long)[self.userName.text compare:@""]);
    
    if(NSOrderedSame == [self.userName.text compare:@""]){
        NSLog(@"userName undefined");
        self.userNameLabel.hidden = NO;
        self.passOne.hidden = NO;
        self.passTwo.hidden = NO;
        return;
    }
    
    if(NSOrderedSame == [self.passOne.text compare:@""]){
        NSLog(@"password1 undefined");
        self.passOne.hidden = NO;
        self.passTwo.hidden = NO;
        return;
    }
    
    if(NSOrderedSame == [self.passTwo.text compare:@""]){
        NSLog(@"password2 undefined");
        self.passTwo.hidden = NO;
        return;
    }
    
    if(NSOrderedSame != [self.passTwo.text compare:self.passOne.text]){
        self.passTwo.hidden = NO;
        self.passOne.text = @"";
        self.passTwo.text = @"";
        return;
    }
    
    JZUser* user = [JZUser sharedUser];

    void (^mySBlock)(NSDictionary*) = ^(NSDictionary* response){
        
        user.password = self.passOne.text;
        [user storeProperties];
        
        //Temporaire: Test si l'opération a réussie -> ce n'est pas là qu'il faudrait le faire
        if([user.username isEqualToString:self.userName.text] && [user.password isEqualToString:self.passOne.text]){
            
            TabBarViewController* tabBar = [TabBarViewController new];
            UINavigationController* navCtrl = [[UINavigationController alloc] initWithRootViewController:tabBar];
            [navCtrl setNavigationBarHidden:true];
            
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
            
            [[MyOAuthManager sharedManager] getStoreListWithSuccessCallback: sc errorCallback:nil];
            
        }else{
            //Message d'erreur
            self.errorMessage.hidden = NO;

        }


    };
    
    void (^myEBlock)() = ^(){
        self.errorMessage.hidden = NO;
    };
    
    MyOAuthManager* sharedManager = [MyOAuthManager sharedManager];
    [sharedManager authSubscribeWithMail:self.userName.text andPassword:self.passOne.text successCallback:mySBlock errorCallback:myEBlock];

}// fin onTouchCreate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
