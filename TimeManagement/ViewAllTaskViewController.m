//
//  ViewAllTaskViewController.m
//  TimeManagement
//
//  Created by kit305 on 15/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import "ViewAllTaskViewController.h"
#import "DBManager.h"

@interface ViewAllTaskViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPeopleInfo;

@property (nonatomic) int recordIDToEdit;

-(void)loadData;

@end

BOOL orderDesc = NO;

@implementation ViewAllTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tblTask.delegate = self;
    self.tblTask.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"taskInfoDB.sql"];
    
    [self loadData];
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

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from taskInfo";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblTask reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrPeopleInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexOfTitle = [self.dbManager.arrColumnNames indexOfObject:@"title"];
    NSInteger indexOfCatagory = [self.dbManager.arrColumnNames indexOfObject:@"catagory"];
    NSInteger indexOfDuedate = [self.dbManager.arrColumnNames indexOfObject:@"duedate"];
    
    // Set the loaded data to the appropriate cell labels.
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfTitle], [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCatagory]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"DueDate: %@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfDuedate]];
    
    return cell;
}

-(void)editingInfoWasFinished{
    // Reload the data.
    [self loadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NewTaskViewController *newNewTaskViewController = [segue destinationViewController];
    
    newNewTaskViewController.delegate = self;
    
    newNewTaskViewController.recordIDToEdit = self.recordIDToEdit;
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Get the record ID of the selected name and set it to the recordIDToEdit property.
    self.recordIDToEdit = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEditInfoFromViewAllTasks" sender:self];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from taskInfo where taskInfoID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData];
    }
}


- (IBAction)sortByCatagory:(id)sender {
    // Form the query.
    NSString *query;
    if(orderDesc == NO)
    {
        query = @"select * from taskInfo order by catagory";
        orderDesc = YES;
    }
    else
    {
        query = @"select * from taskInfo order by catagory desc";
        orderDesc = NO;
    }
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblTask reloadData];
}

- (IBAction)sortByDuedate:(id)sender {
    // Form the query.
    NSString *query;
    if(orderDesc == NO)
    {
        query = @"select * from taskInfo order by datetime(duedate)";
        orderDesc = YES;
    }
    else
    {
        query = @"select * from taskInfo order by datetime(duedate) desc";
        orderDesc = NO;
    }
    
    //taskInfoID integer primary key, title text, catagory text, duedate text, unitcode text, weight text
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblTask reloadData];
}
@end
