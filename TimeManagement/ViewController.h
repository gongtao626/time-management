//
//  ViewController.h
//  TimeManagement
//
//  Created by kit305 on 14/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTaskViewController.h"
#import "QuestionnaireViewController.h"
#import "ViewAllTaskViewController.h"

@interface ViewController : UIViewController <DataEnteredDelegate>

@property (strong, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *upComingThreeTasks;

- (IBAction)suggestionTapped:(id)sender;
- (IBAction)addNewTask:(id)sender;
- (IBAction)questionnaireTap:(id)sender;
- (IBAction)viewAllTaskTap:(id)sender;
- (IBAction)updateUpcomingTasks:(id)sender;

@end

