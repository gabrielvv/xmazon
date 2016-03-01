//
//  ProductViewController.h
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray* products_;
}

@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (nonatomic) NSMutableArray* products;

@end
