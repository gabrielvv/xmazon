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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Products";
    
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
    NSDictionary* product = [products_ objectAtIndex:indexPath.row];
    //    cell.textLabel.text = [NSString stringWithFormat:@"Row %lu", indexPath.row];
    cell.textLabel.text = [product objectForKey:@"name"];
    
    //    cell.detailTextLabel.text = @"super trop bien"; //pour UITableViewCellStyleSubtitle/Value1...
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.products count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
}
@end
