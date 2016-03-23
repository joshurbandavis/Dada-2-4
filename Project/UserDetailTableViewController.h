#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Literature.h"
#import "AddLineViewController.h"
//#import "CompleteStoryViewController.h"

@interface UserDetailTableViewController : UITableViewController

@property (nonatomic, strong) User *user;
@property NSMutableArray *poetryArray;
@property NSMutableArray *fictionArray;
@property NSMutableArray *literatureArray;
@property int selectedIndex;
@property (strong, nonatomic) IBOutlet UITableView *tableViewObject;

@end
