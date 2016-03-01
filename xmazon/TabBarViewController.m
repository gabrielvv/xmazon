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

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /**********************************************************************************************************************************/
    
    //Initialisation FirstController
//    UINavigationController* loginNavCtrl = [[UINavigationController alloc] initWithRootViewController:[LoginViewController new]];
    
    /**********************************************************************************************************************************/
    
    //Initialisation SecondController
    UINavigationController* storeNavCtrl = [[UINavigationController alloc] initWithRootViewController:[StoreViewController new]];
    
    //    UITabBarItem* tabItem2 = [[UITabBarItem alloc] initWithTitle:@"haha" image: tabItem.image tag: 1];
    
    UITabBarItem* tabItem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag: 1];
    
    storeNavCtrl.tabBarItem = tabItem2;
    
    /*******************************************/
    
//    //Initialisation ThirdController
//    UINavigationController* secondNavCtrl = [[UINavigationController alloc] initWithRootViewController:[SecondListViewController new]];
//
//    //    UITabBarItem* tabItem2 = [[UITabBarItem alloc] initWithTitle:@"haha" image: tabItem.image tag: 1];
//
//    UITabBarItem* tabItem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag: 1];
//
//    secondNavCtrl.tabBarItem = tabItem2;
    
    /*****************************************/
    
    [self setViewControllers:@[storeNavCtrl] animated:NO];

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
