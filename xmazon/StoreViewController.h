//
//  StoreViewController.h
//  xmazon
//
//  Created by VAUTRIN on 14/02/2016.
//  Copyright © 2016 esgi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray* stores_;
}

@property (weak, nonatomic) IBOutlet UITableView *storeTableView;
@property (nonatomic, strong) NSMutableArray *stores;

@end
