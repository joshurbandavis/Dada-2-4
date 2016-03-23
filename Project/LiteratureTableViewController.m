#import "LiteratureTableViewController.h"

@implementation LiteratureTableViewController
@synthesize tableViewObject, currentUser, literatureType, literatureArray, poetryArray, fictionArray, selectedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    tableViewObject.delegate = self;
    tableViewObject.dataSource = self;
    
    literatureArray = [[NSMutableArray alloc]init];
    poetryArray = [[NSMutableArray alloc]init];
    fictionArray = [[NSMutableArray alloc]init];
    
    [self loadArrays];

//    for (Literature *lit in poetryArray) {
//        NSLog(@"Title: %@ \nLiterature Type: %@ \nPrivacy: %d \nLines Left: %d \nCurrent Line: %@", lit.title, lit.literatureType, lit.isPublic, lit.linesLeft, lit.currentLine);
//    }
//    for (Literature *lit in fictionArray) {
//        NSLog(@"Title: %@ \nLiterature Type: %@ \nPrivacy: %d \nLines Left: %d \nCurrent Line: %@", lit.title, lit.literatureType, lit.isPublic, lit.linesLeft, lit.currentLine);
//    }
}

-(void)loadArrays
{
    PFQuery *query = [PFQuery queryWithClassName:@"Literature"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *lit in objects) {
                Literature *tempLit = [[Literature alloc]init];
                tempLit.title = [lit objectForKey:@"title"];
                tempLit.literatureType = [lit objectForKey:@"literatureType"];
                tempLit.isPublic = [[lit objectForKey:@"isPublic"] isEqualToString:@"true"] ? true : false;
                tempLit.linesLeft = [[lit objectForKey:@"linesLeft"] intValue];
                tempLit.lines = [lit objectForKey:@"lines"];
                tempLit.authors = [lit objectForKey:@"authors"];
                tempLit.currentLine = [lit objectForKey:@"currentLine"];
                [literatureArray addObject:tempLit];
                if([@"poetry" isEqualToString:[lit objectForKey:@"literatureType"]]&&tempLit.isPublic == true)
                {
                    [poetryArray addObject:tempLit];
                }
                else if([@"fiction" isEqualToString:[lit objectForKey:@"literatureType"]]&&tempLit.isPublic == true)
                {
                    [fictionArray addObject:tempLit];
                }
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self.tableViewObject reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count;
    if([literatureType isEqualToString:@"poetry"])
    {
        count = poetryArray.count;
    }
    else if([literatureType isEqualToString:@"fiction"])
    {
        count = fictionArray.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"literatureCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"literatureCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
    }
    if([literatureType isEqualToString:@"poetry"])
    {
        Literature *tempLiterature = [poetryArray objectAtIndex:indexPath.row];
        
        
        UILabel *linesLeft = (UILabel *)[cell viewWithTag:1];
        linesLeft.text = [NSString stringWithFormat:@"Lines Left: %d", tempLiterature.linesLeft];
        
        UILabel *title = (UILabel *)[cell viewWithTag:2];
        title.text = [NSString stringWithFormat:@"Title: %@", tempLiterature.title];
        
        UILabel *lastLine = (UILabel *)[cell viewWithTag:3];
        lastLine.text = [NSString stringWithFormat:@"Last Line: %@", tempLiterature.currentLine];
    }
    else if([literatureType isEqualToString:@"fiction"])
    {
        Literature *tempLiterature = [fictionArray objectAtIndex:indexPath.row];
        
        UILabel *linesLeft = (UILabel *)[cell viewWithTag:1];
        linesLeft.text = [NSString stringWithFormat:@"Lines Left: %d", tempLiterature.linesLeft];
        
        UILabel *title = (UILabel *)[cell viewWithTag:2];
        title.text = [NSString stringWithFormat:@"Title: %@", tempLiterature.title];
        
        UILabel *lastLine = (UILabel *)[cell viewWithTag:3];
        lastLine.text = [NSString stringWithFormat:@"Last Line: %@", tempLiterature.currentLine];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if([literatureType isEqualToString:@"poetry"])
    {
        Literature *tempLit = [poetryArray objectAtIndex:selectedIndex];
        if(tempLit.linesLeft == 0)
        {
            [self performSegueWithIdentifier:@"goToCompleted" sender:nil];
        }
        else
        {
            [self performSegueWithIdentifier:@"addLineToStory" sender:nil];
        }
    }
    else if([literatureType isEqualToString:@"fiction"])
    {
        Literature *tempLit = [fictionArray objectAtIndex:selectedIndex];
        if(tempLit.linesLeft == 0)
        {
            [self performSegueWithIdentifier:@"goToCompleted" sender:nil];
        }
        else
        {
            [self performSegueWithIdentifier:@"addLineToStory" sender:nil];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([literatureType isEqualToString:@"poetry"])
    {
        Literature *tempLit = [poetryArray objectAtIndex:selectedIndex];
        if(tempLit.linesLeft == 0)
        {
            FinishedViewController *vc = [segue destinationViewController];
            vc.lit = tempLit;
        }
        else
        {
            AddLineViewController *vc = [segue destinationViewController];
            vc.currentUser = currentUser;
            vc.literatureType = tempLit.literatureType;
            vc.selectedIndex = selectedIndex;
            vc.poetryArray = poetryArray;
            vc.fictionArray = fictionArray;
        }
    }
    else if([literatureType isEqualToString:@"fiction"])
    {
        Literature *tempLit = [fictionArray objectAtIndex:selectedIndex];
        if(tempLit.linesLeft == 0)
        {
            FinishedViewController *vc = [segue destinationViewController];
            vc.lit = tempLit;
        }
        else
        {
            AddLineViewController *vc = [segue destinationViewController];
            vc.currentUser = currentUser;
            vc.literatureType = tempLit.literatureType;
            vc.selectedIndex = selectedIndex;
            vc.poetryArray = poetryArray;
            vc.fictionArray = fictionArray;
        }
    }
}

@end