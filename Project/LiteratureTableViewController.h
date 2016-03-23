#import <UIKit/UIKit.h>
#import "User.h"
#import "Literature.h"
#import "AddLineViewController.h"
#import "FinishedViewController.h"
#import <Parse/Parse.h>

@interface LiteratureTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property User *currentUser;
@property NSString *literatureType;
@property NSMutableArray *literatureArray;
@property NSMutableArray *poetryArray;
@property NSMutableArray *fictionArray;
@property int *selectedIndex;
@property (strong, nonatomic) IBOutlet UITableView *tableViewObject;

@end
