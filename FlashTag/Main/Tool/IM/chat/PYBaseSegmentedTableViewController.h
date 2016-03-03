//
//  PYBaseSegmentedTableViewController.h
//  CM
//
//  Created by 付晨鸣 on 15/3/26.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "PYBaseCommon.h"

@interface PYBaseSegmentedTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
