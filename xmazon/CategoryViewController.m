//
//  CategoryViewController.m
//  xmazon
//
//  Created by SEDRAIA on 01/03/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductViewController.h"
#import "MyOAuthManager.h"

@interface CategoryViewController ()

@end

@implementation CategoryViewController

@synthesize categories = categories_;
@synthesize storeLabel = storeLabel_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Category";
    self.storeName.text = self.storeLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static  NSString* const kCellReuseIdentifier = @"CoolId";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier];
    }
    
    NSDictionary* cat = [categories_ objectAtIndex:indexPath.row];
    cell.textLabel.text = [cat objectForKey:@"name"];

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

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    productCtrl.catLabel = cell.textLabel.text;
    productCtrl.storeLabel = self.storeLabel;

    [[MyOAuthManager sharedManager] getProductListForCat:[category objectForKey:@"uid"] search:nil limit:nil offset:nil successCallback:sc];
    
    [self.navigationController pushViewController:productCtrl animated:YES];
}

@end
