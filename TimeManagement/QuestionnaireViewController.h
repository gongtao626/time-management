//
//  QuestionnaireViewController.h
//  TimeManagement
//
//  Created by kit305 on 15/5/17.
//  Copyright © 2017 utas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataEnteredDelegate <NSObject>
-(void)userDidEnterInformation:(NSString *) info;
@end

@interface QuestionnaireViewController : UIViewController{
}
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *previousButton;

@property (nonatomic) id <DataEnteredDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;

@property (strong, nonatomic) IBOutlet UITextField *answerTextfield;

- (IBAction)previousQuestionTap:(id)sender;

- (IBAction)nextQuestionTap:(id)sender;
- (IBAction)submitQuestionnaire:(id)sender;

@end
