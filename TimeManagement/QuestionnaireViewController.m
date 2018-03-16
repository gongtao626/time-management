//
//  QuestionnaireViewController.m
//  TimeManagement
//
//  Created by kit305 on 15/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "DBManager.h"


@interface QuestionnaireViewController ()
@property (nonatomic, strong) NSArray *questionArray;
@property (nonatomic, strong) NSArray *optionArray;
@property (nonatomic, strong) NSMutableArray *answerArray;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrAnswer;

@property (nonatomic) int firstTimeAnswer;

-(void)loadData;
-(void)saveData;

-(void)calculateGrade;
@end

// some local variables for the game
//int secretNumber;
//BOOL success = NO;
int questionIndex = 0;
int gradeShortRangePlanning = 0;
int gradeTimeAttitude = 0;
int gradeLongRangPlanning = 0;
int totalGrade = 0;
UIPickerView *picker;

@implementation QuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    questionIndex = 0;
    _previousButton.hidden = YES;
    
    self.answerArray = [[NSMutableArray alloc] initWithCapacity:18];
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"questionAnswers.sql"];
    
    [self loadData];
    
    if(self.arrAnswer.count == 18)
    {
        _firstTimeAnswer = 0;
        for (int i=0; i<18;i++)
        {
            self.answerArray[i] = self.arrAnswer[i][1];//@"Please select frequency";
        }
    }
    else
    {
        _firstTimeAnswer = 1;
        for (int i=0; i<18;i++)
        {
            self.answerArray[i] = @"Please select frequency";
        }
    }
    
    
    self.questionArray = [[NSArray alloc]initWithObjects:@"Short-Range Planning\n 1. Do you make a list of the things you have to do each day?", @"Short-Range Planning\n2. Do you plan your day before you start it?", @"Short-Range Planning\n3. Do you make a schedule of the activities you have to do on work days?", @"Short-Range Planning\n4. Do you write a set of goals for yourself for each day?", @"Short-Range Planning\n5. Do you spend time each day planning?", @"Short-Range Planning\n6. Do you have a clear idea of what you want to accomplish during the next week?", @"Short-Range Planning\n7. Do you set and honor priorities?", @"Time Attitudes\n 1. Do you often find yourself doing things which interfere with your schoolwork simply because you hate to say \"No\" to people? *", @"Time Attitudes\n 2. Do you feel you are in charge of your own time, by and large?", @"Time Attitudes\n 3. On an average class day do you spend more time with personal grooming than doing schoolwork?*", @"Time Attitudes\n 4. Do you believe that there is room for improvement in the way you manage your time? *", @"Time Attitudes\n 5. Do you make constructive use of your time?", @"Time Attitudes\n 6. Do you continue unprofitable routines or activities?*", @"Long-Range Planning\n 1. Do you usually keep your desk clear of everything other than what you are currently working on?", @"Long-Range Planning\n 2. Do you have a set of goals for the entire quarter?", @"Long-Range Planning\n 3. The night before a major assignment is due, are you usually still working on it? *", @"Long-Range Planning\n 4. When you have several things to do, do you think it is best to do a little bit of work on each one?", @"Long-Range Planning\n 5. Do you regularly review your class notes, even when a test is not imminent?",nil];
    
    self.optionArray=[[NSArray alloc]initWithObjects:@"Please select frequency",@"Never",@"Rarely",@"Occasionally",@"Regularly", @"Always", nil];
    
    picker=[[UIPickerView alloc]init];
    picker.dataSource=self;
    picker.delegate=self;
    [picker setShowsSelectionIndicator:YES];
    [self.answerTextfield setInputView:picker];
    
    UIToolbar *toolBar2=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar2 setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn2=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(removePicker)];
    UIBarButtonItem *space2=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar2 setItems:[NSArray arrayWithObjects:space2,doneBtn2, nil]];
    [self.answerTextfield setInputAccessoryView:toolBar2];
    
    //Initialize the first question and answer
    self.questionLabel.text = self.questionArray[questionIndex];
    self.answerTextfield.text=self.answerArray[questionIndex];
    
}
-(void)loadData{
    // Form the query.
    NSString *query = @"select * from questionAnswer";
    
    // Get the results.
    if (self.arrAnswer != nil) {
        self.arrAnswer = nil;
    }
    self.arrAnswer = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
}


-(void)removePicker
{
    [picker selectRow:0 inComponent:0 animated:YES];
    [self.answerTextfield resignFirstResponder];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.optionArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.optionArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.answerTextfield.text=[self.optionArray objectAtIndex:row];
    self.answerArray[questionIndex] = self.answerTextfield.text;
    
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

- (IBAction)previousQuestionTap:(id)sender {
    
    if(questionIndex > 0){
        questionIndex--;
        self.questionLabel.text = self.questionArray[questionIndex];
        self.answerTextfield.text = self.answerArray[questionIndex];
        _nextButton.hidden = NO;
        if(questionIndex == 0)
            _previousButton.hidden = YES;
        else
            _previousButton.hidden= NO;
    }
    //self.answerTextfield.text = @"";
}

- (IBAction)nextQuestionTap:(id)sender {
    
    if (questionIndex < 17){
        questionIndex++;
        self.questionLabel.text = self.questionArray[questionIndex];
        self.answerTextfield.text=self.answerArray[questionIndex];
        _previousButton.hidden = NO;
        if(questionIndex == 17)
            _nextButton.hidden = YES;
        else
            _nextButton.hidden = NO;
    }
    
    //self.answerTextfield.text = @"";
    
}

- (IBAction)submitQuestionnaire:(id)sender {
    //NSLog(@"Finish Answering");
    NSLog(@"Answer: %@", self.answerArray);
    [self calculateGrade];
   
    [self saveData];
    
    UIAlertView	*alert = [[UIAlertView alloc]
                          initWithTitle:@"Your Mark!"
                          message:[NSString stringWithFormat:@"Total Grade %d/90 = \n SR Planning %d(CLASS AVG:22)/35 + \nTime Attitude %d(CLASS AVG:19)/30 + \nLR Planning %d(CLASS AVG:14.3)/25", totalGrade,gradeShortRangePlanning,gradeTimeAttitude,gradeLongRangPlanning]
                          delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    NSLog(@"totalGrade %d = gradeShortRangePlanning %d + gradeTimeAttitude %d + gradeLongRangPlanning %d", totalGrade,gradeShortRangePlanning,gradeTimeAttitude,gradeLongRangPlanning);
    NSString *strX = [NSString stringWithFormat:@"%d",totalGrade];
    
    [self.delegate userDidEnterInformation:strX];
    
    gradeShortRangePlanning = 0;
    gradeTimeAttitude = 0;
    gradeLongRangPlanning = 0;
    totalGrade = 0;
    
}

-(void)calculateGrade{
    for (int i=0; i<=17;i++)
    {
        if(i < 7){
            if([self.answerArray[i] isEqualToString:self.optionArray[0]])
                gradeShortRangePlanning += 0;
            else if([self.answerArray[i] isEqualToString:self.optionArray[1]])
                gradeShortRangePlanning += 1;
            else if([self.answerArray[i] isEqualToString:self.optionArray[2]])
                gradeShortRangePlanning += 2;
            else if([self.answerArray[i] isEqualToString:self.optionArray[3]])
                gradeShortRangePlanning += 3;
            else if([self.answerArray[i] isEqualToString:self.optionArray[4]])
                gradeShortRangePlanning += 4;
            else if([self.answerArray[i] isEqualToString:self.optionArray[5]])
                gradeShortRangePlanning += 5;
        }
        if(i>=7 && i<=12){
            
            if(i==7 || i==9 || i==10 || i==12 )
            {
                if([self.answerArray[i] isEqualToString:self.optionArray[0]])
                    gradeTimeAttitude += 0;
                else if([self.answerArray[i] isEqualToString:self.optionArray[1]])
                    gradeTimeAttitude += 5;
                else if([self.answerArray[i] isEqualToString:self.optionArray[2]])
                    gradeTimeAttitude += 4;
                else if([self.answerArray[i] isEqualToString:self.optionArray[3]])
                    gradeTimeAttitude += 3;
                else if([self.answerArray[i] isEqualToString:self.optionArray[4]])
                    gradeTimeAttitude += 2;
                else if([self.answerArray[i] isEqualToString:self.optionArray[5]])
                    gradeTimeAttitude += 1;
            }
            else {
                if([self.answerArray[i] isEqualToString:self.optionArray[0]])
                    gradeTimeAttitude += 0;
                else if([self.answerArray[i] isEqualToString:self.optionArray[1]])
                    gradeTimeAttitude += 1;
                else if([self.answerArray[i] isEqualToString:self.optionArray[2]])
                    gradeTimeAttitude += 2;
                else if([self.answerArray[i] isEqualToString:self.optionArray[3]])
                    gradeTimeAttitude += 3;
                else if([self.answerArray[i] isEqualToString:self.optionArray[4]])
                    gradeTimeAttitude += 4;
                else if([self.answerArray[i] isEqualToString:self.optionArray[5]])
                    gradeTimeAttitude += 5;
            }
        }
        
        if(i>=13 && i<=17){
            
            if(i==15)
            {
                if([self.answerArray[i] isEqualToString:self.optionArray[0]])
                    gradeLongRangPlanning += 0;
                else if([self.answerArray[i] isEqualToString:self.optionArray[1]])
                    gradeLongRangPlanning += 5;
                else if([self.answerArray[i] isEqualToString:self.optionArray[2]])
                    gradeLongRangPlanning += 4;
                else if([self.answerArray[i] isEqualToString:self.optionArray[3]])
                    gradeLongRangPlanning += 3;
                else if([self.answerArray[i] isEqualToString:self.optionArray[4]])
                    gradeLongRangPlanning += 2;
                else if([self.answerArray[i] isEqualToString:self.optionArray[5]])
                    gradeLongRangPlanning += 1;
            }
            else {
                if([self.answerArray[i] isEqualToString:self.optionArray[0]])
                    gradeLongRangPlanning += 0;
                else if([self.answerArray[i] isEqualToString:self.optionArray[1]])
                    gradeLongRangPlanning += 1;
                else if([self.answerArray[i] isEqualToString:self.optionArray[2]])
                    gradeLongRangPlanning += 2;
                else if([self.answerArray[i] isEqualToString:self.optionArray[3]])
                    gradeLongRangPlanning += 3;
                else if([self.answerArray[i] isEqualToString:self.optionArray[4]])
                    gradeLongRangPlanning += 4;
                else if([self.answerArray[i] isEqualToString:self.optionArray[5]])
                    gradeLongRangPlanning += 5;
            }
        }
        
    }
    
    totalGrade = gradeShortRangePlanning+gradeTimeAttitude+gradeLongRangPlanning;
}

-(void)saveData
{
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
    for(int i=0; i<18; i++)
    {
        if (self.firstTimeAnswer == 1) {
            query = [NSString stringWithFormat:@"insert into questionAnswer (answer, score) values('%@', '%d')", self.answerArray[i], totalGrade];
        }
        else{
            query = [NSString stringWithFormat:@"update questionAnswer set answer='%@', score='%d' where questionID=%d", self.answerArray[i], totalGrade, i+1];
        }
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Inform the delegate that the editing was finished.
            //[self.delegate editingInfoWasFinished];
            
            // Pop the view controller.
            //[self.navigationController popViewControllerAnimated:YES];
        }
        else{
            NSLog(@"Could not execute the query.");
        }
    }
 }
@end
