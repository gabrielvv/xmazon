//
//  CategoryViewController.m
//  xmazon
//
//  Created by SEDRAIA on 01/03/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "CategoryViewController.h"
#import "ProductViewController.h"
#import "myOAuthManager.h"

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

    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    productCtrl.catLabel = cell.textLabel.text;
    productCtrl.storeLabel = self.storeLabel;
    NSLog(@"didSelectRow %@ - %@", productCtrl.catLabel, productCtrl.storeLabel);
    [[myOAuthManager sharedManager] getProductListForCat:[category objectForKey:@"uid"] search:nil limit:nil offset:nil successCallback:sc];
    
    [self.navigationController pushViewController:productCtrl animated:YES];
}

@end
