#import "UserDetailTableViewController.h"
#import "FinishedViewController.h"

@implementation UserDetailTableViewController
@synthesize tableViewObject, user, poetryArray, fictionArray, literatureArray, selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    literatureArray = [[NSMutableArray alloc]init];
    poetryArray = [[NSMutableArray alloc]init];
    fictionArray = [[NSMutableArray alloc]init];
    
    self.title = [NSString stringWithFormat:@"Stories Participated In By: %@", user.username];
    [self getInfo];
}

-(void) getInfo{
    PFQuery *query = [PFQuery queryWithClassName:@"Literature"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *lit in objects)
            {
                NSArray *tempAuthors = [lit objectForKey:@"authors"];
                BOOL authorFound = false;
                for (NSString *author in tempAuthors) {
                    if([author isEqualToString:user.username])
                        authorFound = true;
                }
                if(authorFound)
                {
                    Literature *tempLit = [[Literature alloc]init];
                    tempLit.title = [lit objectForKey:@"title"];
                    tempLit.literatureType = [lit objectForKey:@"literatureType"];
                    tempLit.isPublic = [[lit objectForKey:@"isPublic"] isEqualToString:@"true"] ? true : false;
                    tempLit.linesLeft = [[lit objectForKey:@"linesLeft"] intValue];
                    tempLit.lines = [lit objectForKey:@"lines"];
                    tempLit.authors = [lit objectForKey:@"authors"];
                    tempLit.currentLine = [lit objectForKey:@"currentLine"];
                    [literatureArray addObject:tempLit];
                    if([@"poetry" isEqualToString:[lit objectForKey:@"literatureType"]])
                    {
                        [poetryArray addObject:tempLit];
                    }
                    else if([@"fiction" isEqualToString:[lit objectForKey:@"literatureType"]])
                    {
                        [fictionArray addObject:tempLit];
                    }
                }
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return literatureArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UDTableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UDTableCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
    }
    
    Literature *tempLiterature = [literatureArray objectAtIndex:indexPath.row];
    
    UILabel *linesLeft = (UILabel *)[cell viewWithTag:1];
    linesLeft.text = [NSString stringWithFormat:@"Lines Left: %d", tempLiterature.linesLeft];
    
    UILabel *title = (UILabel *)[cell viewWithTag:2];
    title.text = [NSString stringWithFormat:@"Title: %@", tempLiterature.title];
    
    UILabel *lastLine = (UILabel *)[cell viewWithTag:3];
    lastLine.text = [NSString stringWithFormat:@"Last Line: %@", tempLiterature.currentLine];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    Literature *tempLit = [literatureArray objectAtIndex:selectedIndex];
    if(tempLit.linesLeft == 0)
    {
        [self performSegueWithIdentifier:@"goCompleted" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"addLine" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    Literature *tempLit = [literatureArray objectAtIndex:selectedIndex];
    if ([[segue identifier] isEqual: @"goCompleted"])
    {
        FinishedViewController *vc = [segue destinationViewController];
        vc.lit = tempLit;
    }
    else
    {
        AddLineViewController *vc = [segue destinationViewController];
        vc.currentUser = user;
        vc.literatureType = tempLit.literatureType;
        vc.selectedIndex = selectedIndex;
        vc.poetryArray = poetryArray;
        vc.fictionArray = fictionArray;
    }
}

@end