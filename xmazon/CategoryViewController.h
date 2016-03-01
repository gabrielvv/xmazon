//
//  CategoryViewController.h
//  xmazon
//
//  Created by VAUTRIN on 01/03/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray* categories_;
}

@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@property (nonatomic) NSMutableArray* categories;

@end
