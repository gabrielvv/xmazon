//
//  ProductViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "ProductViewController.h"
#import "TabBarViewController.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

@synthesize products = products_;
@synthesize storeLabel = storeLabel_;
@synthesize catLabel = catLabel_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Products";
    self.storeName.text = [[NSString alloc] initWithFormat:@"%@ - %@", self.storeLabel, self.catLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static  NSString* const kCellReuseIdentifier = @"CoolId";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:kCellReuseIdentifier];
    }
    NSDictionary* product = [products_ objectAtIndex:indexPath.row];
    cell.textLabel.text = [product objectForKey:@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: %.2f €", [[product objectForKey:@"price"] floatValue]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.products count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Add Product To Cart" message:cell.textLabel.text preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* validateAction = [UIAlertAction actionWithTitle: @"Validate" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        //Validate Action
        TabBarViewController* tab = (TabBarViewController*)[self tabBarController];
        UITabBarItem* item = [[[tab tabBar] items] objectAtIndex:2];
        NSInteger i = [item.badgeValue integerValue];
        item.badgeValue = [[NSString alloc] initWithFormat:@"%ld", ++i];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle: @"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        //Cancel Action
        
    }];
    
    [alertController addAction: validateAction];
    [alertController addAction: cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
   
}
@end
