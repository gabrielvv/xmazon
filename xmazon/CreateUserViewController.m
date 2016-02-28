//
//  CreateUserViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "CreateUserViewController.h"
#import "myOAuthManager.h"

@interface CreateUserViewController () <UITextFieldDelegate>

@end

@implementation CreateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.firstName.autocorrectionType = UITextAutocorrectionTypeNo;
    self.lastName.autocorrectionType = UITextAutocorrectionTypeNo;
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
//    
//    if(NSOrderedSame == [self.userName.text compare:@""]){
//        NSLog(@"userName undefined");
//        self.userNameLabel.hidden = NO;
//        self.passOne.hidden = NO;
//        self.passTwo.hidden = NO;
//        return;
//    }
//    
//    if(NSOrderedSame == [self.passOne.text compare:@""]){
//        NSLog(@"password1 undefined");
//        self.passOne.hidden = NO;
//        self.passTwo.hidden = NO;
//        return;
//    }
//    
//    if(NSOrderedSame == [self.passTwo.text compare:@""]){
//        NSLog(@"password2 undefined");
//        self.passTwo.hidden = NO;
//        return;
//    }
//    
//    if(NSOrderedSame != [self.passTwo.text compare:self.passOne.text]){
//        self.passTwo.hidden = NO;
//        self.passOne.text = @"";
//        self.passTwo.text = @"";
//        return;
//    }
    
//    NSURLSession* session = [NSURLSession sharedSession];
//    
//    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:@"http://xmazon.appspaces.fr/oauth/token"]];
//    
//    request.HTTPMethod = @"POST";
//    
//    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary* clientCred = [userDefaults objectForKey:@"clientCredentials"];
//    
//    NSString* clientId = [clientCred objectForKey:@"client_id"];
//    NSString* clientSecret = [clientCred objectForKey:@"client_secret"];
//    
//    
//    NSString* body = [[NSString alloc] initWithFormat:@"grant_type=client_credentials&client_id=%@&client_secret=%@", clientId, clientSecret];
//    
//    request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSMutableDictionary* headers = [request.allHTTPHeaderFields mutableCopy];
//    
////    [headers setObject:@"Bearer XXXX" forKey:@"Authorization"];
//    request.allHTTPHeaderFields = headers;
//    
//    [[session dataTaskWithRequest:request completionHandler:^
//      (NSData * data, NSURLResponse * response, NSError* error){
//          if(!error){
////              NSLog(@"Response : %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//              
//          }else{
//              NSLog(@"%@", error);
//          }
//      }] resume];
    
    myOAuthManager* sharedManager = [myOAuthManager sharedManager];
    [sharedManager getCategoryList];
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
