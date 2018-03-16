//
//  ViewAllTaskViewController.h
//  TimeManagement
//
//  Created by kit305 on 15/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTaskViewController.h"

@interface ViewAllTaskViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblTask;
- (IBAction)sortByCatagory:(id)sender;
- (IBAction)sortByDuedate:(id)sender;

@end
