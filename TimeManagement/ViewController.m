//
//  ViewController.m
//  TimeManagement
//
//  Created by kit305 on 14/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()

@property (nonatomic) int recordIDToEdit;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrAnswer;

@property (nonatomic, strong) DBManager *dbManager2;
@property (nonatomic, strong) NSArray *arrTask;

-(void)loadData;
-(void)loadData2;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"questionAnswers.sql"];
    
    [self loadData];
    
    if(self.arrAnswer.count == 18)
    {
        
        NSInteger grade = [self.arrAnswer[0][2] integerValue];
        float percentMark = grade/90.0;
        
        _gradeLabel.text = [NSString stringWithFormat:@"%.1f%%", percentMark*100];

    }
    
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:@"taskInfoDB.sql"];
    
    [self loadData2];
    
    NSMutableString *upcomingTask = [[NSMutableString alloc] init];
    for(int i=0; i < self.arrTask.count;i++)
    {
        [upcomingTask appendString:[NSString stringWithFormat:@"%@ %@ %@ %@ %@\n\n", self.arrTask[i][1], self.arrTask[i][2], self.arrTask[i][3], self.arrTask[i][4], self.arrTask[i][5]]];
    }
    self.upComingThreeTasks.text = upcomingTask;
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

-(void)loadData2{
    // Form the query.
    NSString *query = @"select * from taskInfo order by datetime(duedate) limit 3";
    
    // Get the results.
    if (self.arrTask != nil) {
        self.arrTask = nil;
    }
    self.arrTask = [[NSArray alloc] initWithArray:[self.dbManager2 loadDataFromDB:query]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)suggestionTapped:(id)sender {
    
    UIApplication *application = [UIApplication sharedApplication];
    
    NSURL *URL = [NSURL URLWithString:@"https://www.youtube.com/watch?v=3Q-LXUm-ZKc"];
    
    [application openURL:URL];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"idSegueEditInfo"]){
        NewTaskViewController *newTaskViewController = [segue destinationViewController];
        //newTaskViewController.delegate = self;
    
        newTaskViewController.recordIDToEdit = self.recordIDToEdit;
    }
    
    if ([[segue identifier] isEqualToString:@"idSegueQuestionnaire"]){
        QuestionnaireViewController *newQuestionnaireViewController = [segue destinationViewController];
        newQuestionnaireViewController.delegate = self;
        
        //newTaskViewController.recordIDToEdit = self.recordIDToEdit;
    }
    
    if ([[segue identifier] isEqualToString:@"idSegueCurrentTasks"]){
        ViewAllTaskViewController *newViewAllTaskViewController = [segue destinationViewController];
        //newTaskViewController.delegate = self;
        
        //newTaskViewController.recordIDToEdit = self.recordIDToEdit;
    }
}

-(void)userDidEnterInformation:(NSString *)info {
    NSInteger grade = [info integerValue];
    float percentMark = grade/90.0;
    
    _gradeLabel.text = [NSString stringWithFormat:@"%.1f%%", percentMark*100];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addNewTask:(id)sender {
    self.recordIDToEdit = -1;
    
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
    
}

- (IBAction)questionnaireTap:(id)sender {
    
    [self performSegueWithIdentifier:@"idSegueQuestionnaire" sender:self];
}

- (IBAction)viewAllTaskTap:(id)sender {
    [self performSegueWithIdentifier:@"idSegueCurrentTasks" sender:self];
}

- (IBAction)updateUpcomingTasks:(id)sender {
    [self loadData2];
    
    NSMutableString *upcomingTask = [[NSMutableString alloc] init];
    for(int i=0; i < self.arrTask.count;i++)
    {
        [upcomingTask appendString:[NSString stringWithFormat:@"%@ %@ %@ %@ %@\n\n", self.arrTask[i][1], self.arrTask[i][2], self.arrTask[i][3], self.arrTask[i][4], self.arrTask[i][5]]];
    }
    self.upComingThreeTasks.text = upcomingTask;
    
}



@end
