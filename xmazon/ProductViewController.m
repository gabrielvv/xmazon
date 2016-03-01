//
//  ProductViewController.m
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import "ProductViewController.h"

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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Price: %@ €", [product objectForKey:@"price"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.products count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}
@end
