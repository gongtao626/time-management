//
//  NewTaskViewController.m
//  TimeManagement
//
//  Created by kit305 on 14/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import "NewTaskViewController.h"
#import "DBManager.h"


@interface NewTaskViewController ()
@property (nonatomic, strong) DBManager *dbManager;
-(void) loadInfoToEdit;
@end

@implementation NewTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;//UIDatePickerModeDate;
    [self.dueDateTextField setInputView:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.dueDateTextField setInputAccessoryView:toolBar];
    
    
    catagoryArray=[[NSArray alloc]initWithObjects:@"Please select catagory",@"Important & Urgent",@"Not Important & Urgent",@"Important & Not Urgent",@"Not Important & Not Urgent",nil];
    UIPickerView *picker=[[UIPickerView alloc]init];
    picker.dataSource=self;
    picker.delegate=self;
    [picker setShowsSelectionIndicator:YES];
    [self.catagoryTextField setInputView:picker];
    
    UIToolbar *toolBar2=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar2 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(removePicker)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar2 setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    [self.catagoryTextField setInputAccessoryView:toolBar2];
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taskInfoDB.sql"];
    
    
    // Check if should load specific record for editing.
    if (self.recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
}

-(void)removePicker
{
    [self.catagoryTextField resignFirstResponder];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [catagoryArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [catagoryArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.catagoryTextField.text=[catagoryArray objectAtIndex:row];
}


-(void)ShowSelectedDate
{   NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    //[formatter setDateFormat:@"dd/MMM/YYYY HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.dueDateTextField.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.dueDateTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveTaskInfo:(id)sender {
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into taskInfo values(null, '%@', '%@', '%@', '%@', '%@')", self.taskTitleTextField.text, self.catagoryTextField.text, self.dueDateTextField.text, self.unitCodeTextField.text, self.taskWeightTextField.text];
    }
    else{
        query = [NSString stringWithFormat:@"update taskInfo set title='%@', catagory='%@', duedate='%@', unitcode='%@', weight='%@' where taskInfoID=%d", self.taskTitleTextField.text, self.catagoryTextField.text, self.dueDateTextField.text, self.unitCodeTextField.text, self.taskWeightTextField.text, self.recordIDToEdit];
    }
    
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
        [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
}



-(void) loadInfoToEdit{
    // Create the query.
    NSString *query = [NSString stringWithFormat:@"select * from taskInfo where taskInfoID=%d", self.recordIDToEdit];
    
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    self.taskTitleTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"title"]];
    self.catagoryTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"catagory"]];
    self.dueDateTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"duedate"]];
    
    self.unitCodeTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"unitcode"]];
    
    self.taskWeightTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"weight"]];
    
    
}
@end
