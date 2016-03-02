//
//  CategoryViewController.h
//  xmazon
//
//  Created by SEDRAIA on 01/03/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray* categories_;
    NSString* storeLabel_;

}

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (nonatomic) NSMutableArray* categories;
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (nonatomic) NSString* storeLabel;


@end
