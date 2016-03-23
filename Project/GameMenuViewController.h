#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Literature.h"
#import "SearchTableViewController.h"
#import "ProfilePage.h"
#import "CreateLitViewController.h"
#import "LiteratureTableViewController.h"

@interface GameMenuViewController : UIViewController

@property User *currentUser;
@property NSString *literatureType;
@property NSString *selection;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;

@end