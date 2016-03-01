//
//  CreateUserViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "CreateUserViewController.h"
#import "StoreViewController.h"
#import "myOAuthManager.h"
#import "GVUser.h"

@interface CreateUserViewController () <UITextFieldDelegate>

@end

@implementation CreateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastName.autocorrectionType = UITextAutocorrectionTypeNo;
    myOAuthManager* sharedManager = [myOAuthManager sharedManager];
    [sharedManager getStoreList];
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
    
    void (^myBlock)(NSDictionary*) = ^(NSDictionary* response){
        GVUser* user = [GVUser sharedUser];
        //Temporaire: Test si l'opération a réussie -> ce n'est pas là qu'il faudrait le faire
        if([user.username isEqualToString:self.userName.text] && [user.password isEqualToString:self.passOne.text]){
            StoreViewController* store = [StoreViewController new];
            [self.navigationController pushViewController:store animated:YES];
        }else{
            //Message d'erreur
        }
    };
    
    myOAuthManager* sharedManager = [myOAuthManager sharedManager];
    [sharedManager authSubscribeWithMail:self.userName.text andPassword:self.passOne.text callback:myBlock];
    
    

}// fin onTouchCreate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
