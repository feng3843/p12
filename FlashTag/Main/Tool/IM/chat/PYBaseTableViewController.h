//
//  PYBaseTableViewController.h
//  CM
//
//  Created by 付晨鸣 on 15/2/2.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYBaseCommon.h"

@interface PYBaseTableViewController : PYBaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
