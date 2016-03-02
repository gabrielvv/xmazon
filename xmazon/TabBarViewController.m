//
//  TabBarViewController.m
//  xmazon
//
//  Created by SEDRAIA on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "StoreViewController.h"
#import "SearchViewController.h"
#import "CartViewController.h"
#import "UserViewController.h"

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
    
    UINavigationController* userNavCtrl = [[UINavigationController alloc] initWithRootViewController:[UserViewController new]];
    userNavCtrl.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag: 4];
    
    /*****************************************/
    
    [self setViewControllers:@[storeNavCtrl, searchNavCtrl, cartNavCtrl, userNavCtrl] animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
