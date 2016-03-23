#import "SearchTableViewController.h"
#import "User.h"
#import "UserDetailTableViewController.h"

@implementation SearchTableViewController
@synthesize users, searchResults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    users = [NSMutableArray new];
    
    [self getUsers];
}

-(void)getUsers{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         for (PFObject *object in objects) {
             User *tempUser = [User new];
             tempUser.username = [object objectForKey:@"username"];
             tempUser.password = [object objectForKey:@"password"];
             tempUser.email = [object objectForKey:@"email"];
             [users addObject:tempUser];
         }
     }];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"username contains[c] %@", searchText];
    searchResults = [users filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchController.searchBar
                                                     selectedScopeButtonIndex]]];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
    }
    
    User *user = [searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = nil;
    User *user = nil;
    
    indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
    user = [searchResults objectAtIndex:indexPath.row];
    
    UserDetailTableViewController *vc = [segue destinationViewController];
    vc.user = user;
}

@end