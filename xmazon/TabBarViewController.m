//
//  TabBarViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "StoreViewController.h"
#import "SearchViewController.h"
#import "CartViewController.h"
#import "OrdersViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**********************************************************************************************************************************/
    
    UINavigationController* storeNavCtrl = [[UINavigationController alloc] initWithRootViewController:[StoreViewController new]];
    storeNavCtrl.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag: 1];
    
    /*******************************************/
    
    UINavigationController* searchNavCtrl = [[UINavigationController alloc] initWithRootViewController:[SearchViewController new]];
    searchNavCtrl.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag: 2];

    /*****************************************/
    
    UINavigationController* cartNavCtrl = [[UINavigationController alloc] initWithRootViewController:[CartViewController new]];
    cartNavCtrl.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag: 3];
    
    /*****************************************/
    
    UINavigationController* userNavCtrl = [[UINavigationController alloc] initWithRootViewController:[OrdersViewController new]];
    userNavCtrl.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag: 4];
    
    /*****************************************/
    
    [self setViewControllers:@[storeNavCtrl, searchNavCtrl, cartNavCtrl, userNavCtrl] animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
