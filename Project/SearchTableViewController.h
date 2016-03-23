#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SearchTableViewController : UITableViewController

@property NSMutableArray *users;
@property NSArray *searchResults;
@property (strong, nonatomic) UISearchController *searchController;

@end
