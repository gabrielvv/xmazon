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
    NSString* catLabel_;
    NSString* storeLabel_;
    
}
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *category;

@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (nonatomic) NSMutableArray* products;
@property (nonatomic) NSString* catLabel;
@property (nonatomic) NSString* storeLabel;

@end
