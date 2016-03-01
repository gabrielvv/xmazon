//
//  StoreViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "StoreViewController.h"
#import "CategoryViewController.h"
#import "myOAuthManager.h"

@interface StoreViewController ()

@end

@implementation StoreViewController

@synthesize stores = stores_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Stores";

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
    
}

static  NSString* const kCellReuseIdentifier = @"CoolId";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if(!cell){
        NSLog(@"CREATE Cell");
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier];
//        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:kCellReuseIdentifier];
        //tester UITableViewCellStyleValue1 et autres styles
    }/*else{
      NSLog(@"REUSE Cell");
      }*/
    NSDictionary* store = [stores_ objectAtIndex:indexPath.row];
    //    cell.textLabel.text = [NSString stringWithFormat:@"Row %lu", indexPath.row];
    cell.textLabel.text = [store objectForKey:@"name"];
    
//    cell.detailTextLabel.text = @"super trop bien"; //pour UITableViewCellStyleSubtitle/Value1...
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [stores_ count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary* store = [self.stores objectAtIndex:indexPath.row];
    CategoryViewController* categoryCtrl = [CategoryViewController new];
    
        
    void (^sc)(NSDictionary*) = ^(NSDictionary* response){
        categoryCtrl.categories = [response objectForKey:@"result"];
        [categoryCtrl.categoryTableView reloadData];
    };
    

    [[myOAuthManager sharedManager] getCategoryListForStore:[store objectForKey:@"uid"] search:nil limit:nil offset:nil successCallback:sc];

    [self.navigationController pushViewController:categoryCtrl animated:YES];
}

@end
