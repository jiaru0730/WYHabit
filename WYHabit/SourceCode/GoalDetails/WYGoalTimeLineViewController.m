//
//  WYGoalTimeLineViewController.m
//  WYHabit
//
//  Created by Jia Ru on 3/29/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#import "WYGoalTimeLineViewController.h"
#import "WYGoal.h"
#import "WYDataManager.h"
#import "WYDate.h"


@interface WYGoalTimeLineViewController ()

@property (copy, nonatomic) NSString *goalID;

@property (strong, nonatomic) WYGoal *goal;
@property (assign, nonatomic) int elapsedDays;
@property (assign, nonatomic) int longestSequence;
@property (assign, nonatomic) float percentageInAll;
@property (assign, nonatomic) int rankingInAll;


@end

@implementation WYGoalTimeLineViewController

- (id)initWithGoal:(NSString *)goalID {
    self = [super init];
    if (self) {
        _goalID = goalID;
        _goal = [[WYDataManager sharedInstance] getGoalByID:self.goalID];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (int)calculateElapsedDays {
    NSTimeInterval elapsedTimeInterval = [self.goal.achiveTime timeIntervalSinceDate:self.goal.startTime];
    return (elapsedTimeInterval / kSecondsPerDay) + 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"timeLineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSString *timelineDescription = nil;
    switch (indexPath.row) {
        case 0: {
            WYDate *startWYDate = [[WYDataManager sharedInstance] convertDateToWYDate:self.goal.startTime];
            timelineDescription = [NSString stringWithFormat:@"StartTime:%d %d %d", startWYDate.year, startWYDate.month, startWYDate.day];
            break;
        }
        case 1: {
            WYDate *achiveWYDate = [[WYDataManager sharedInstance] convertDateToWYDate:self.goal.achiveTime];
            timelineDescription = [NSString stringWithFormat:@"AchiveTime:%d %d %d", achiveWYDate.year, achiveWYDate.month, achiveWYDate.day];
            break;
        }
        case 2:
            timelineDescription = [NSString stringWithFormat:@"ElapsedDays:%d", [self calculateElapsedDays]];
            break;
        case 3: {
            timelineDescription = [NSString stringWithFormat:@"ContinueSequence:%d", [[WYDataManager sharedInstance] calculateContinueSequenceForGoal:self.goalID]];
            break;
        }
        case 4:
            timelineDescription = [NSString stringWithFormat:@"TotalPercentage:%f%%", [[WYDataManager sharedInstance] calculateCommitPercentageForGoal:self.goalID] * 100];
            break;
        case 5:
            timelineDescription = [NSString stringWithFormat:@"Ranking:%d", [[WYDataManager sharedInstance] calculateCommitRankingForGoal:self.goalID]];
            break;
        default:
            timelineDescription = [NSString stringWithFormat:@""];
            break;
    }
    
    cell.textLabel.text = timelineDescription;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
