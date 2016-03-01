//
//  CategoryViewController.m
//  xmazon
//
//  Created by VAUTRIN on 01/03/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductViewController.h"
#import "myOAuthManager.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

@synthesize categories = categories_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Category";
    
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
    NSDictionary* cat = [categories_ objectAtIndex:indexPath.row];
    //    cell.textLabel.text = [NSString stringWithFormat:@"Row %lu", indexPath.row];
    cell.textLabel.text = [cat objectForKey:@"name"];
    
    //    cell.detailTextLabel.text = @"super trop bien"; //pour UITableViewCellStyleSubtitle/Value1...
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.categories count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* category = [self.categories objectAtIndex:indexPath.row];
    ProductViewController* productCtrl = [ProductViewController new];
    
    void (^sc)(NSDictionary*) = ^(NSDictionary* response){
        productCtrl.products = [response objectForKey:@"result"];
        [productCtrl.productTableView reloadData];
    };

    [[myOAuthManager sharedManager] getProductListForCat:[category objectForKey:@"uid"] search:nil limit:nil offset:nil successCallback:sc];
    
    [self.navigationController pushViewController:productCtrl animated:YES];
}

@end
