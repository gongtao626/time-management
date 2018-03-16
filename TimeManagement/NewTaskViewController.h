//
//  NewTaskViewController.h
//  TimeManagement
//
//  Created by kit305 on 14/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface NewTaskViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIDatePicker *datePicker;
    NSArray *catagoryArray;
}

@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;

- (IBAction)saveTaskInfo:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *taskTitleTextField;
@property (strong, nonatomic) IBOutlet UITextField *catagoryTextField;

@property (strong, nonatomic) IBOutlet UITextField *dueDateTextField;
@property (strong, nonatomic) IBOutlet UITextField *unitCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *taskWeightTextField;

@property (nonatomic) int recordIDToEdit;

@end
