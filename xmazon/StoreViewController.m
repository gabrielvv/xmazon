//
//  StoreViewController.m
//  xmazon
//
//  Created by SEDRAIA on 14/02/2016.
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
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    categoryCtrl.storeLabel = cell.textLabel.text;

    [[myOAuthManager sharedManager] getCategoryListForStore:[store objectForKey:@"uid"] search:nil limit:nil offset:nil successCallback:sc];

    [self.navigationController pushViewController:categoryCtrl animated:YES];
}

@end
