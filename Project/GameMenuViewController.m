#import "GameMenuViewController.h"
@implementation GameMenuViewController
@synthesize currentUser, literatureType, selection, segControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@ \n %@ \n %@", currentUser.username, currentUser.password, currentUser.email);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)profileSelect:(id)sender {
    if([currentUser.username isEqualToString:@"guest"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Guest Cannot View Profile! Please login or register to proceed."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        selection= [NSString stringWithFormat:@"profile"];
        [self performSegueWithIdentifier:@"profile" sender:nil];
    }
}

- (IBAction)searchButton:(id)sender {
    selection= [NSString stringWithFormat:@"search"];
    [self performSegueWithIdentifier:@"search" sender:nil];
}

- (IBAction)poetryClicked:(id)sender {
    NSInteger selectedIndex = segControl.selectedSegmentIndex;
    if([currentUser.username isEqualToString:@"guest"])
    {
        if(selectedIndex == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Guest Cannot Create! Please login or register to proceed."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if(selectedIndex == 1)
        {
            literatureType = [NSString stringWithFormat:@"poetry"];
            selection= [NSString stringWithFormat:@"literature"];
            [self performSegueWithIdentifier:@"goToContinueTable" sender:nil];
        }
    }
    else
    {
        literatureType = [NSString stringWithFormat:@"poetry"];
        selection= [NSString stringWithFormat:@"literature"];
        if(selectedIndex == 0)
        {
            [self performSegueWithIdentifier:@"goToCreateLit" sender:nil];
        }
        else if(selectedIndex == 1)
        {
            [self performSegueWithIdentifier:@"goToContinueTable" sender:nil];
        }
    }
}

- (IBAction)fictionClicked:(id)sender {
    NSInteger selectedIndex = segControl.selectedSegmentIndex;
    if([currentUser.username isEqualToString:@"guest"])
    {
        if(selectedIndex == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Guest Cannot Create! Please login or register to proceed."
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else if(selectedIndex == 1)
        {
            literatureType = [NSString stringWithFormat:@"fiction"];
            selection= [NSString stringWithFormat:@"literature"];
            [self performSegueWithIdentifier:@"goToContinueTable" sender:nil];
        }
    }
    else
    {
        literatureType = [NSString stringWithFormat:@"fiction"];
        selection = [NSString stringWithFormat:@"literature"];
        if(selectedIndex == 0)
        {
            [self performSegueWithIdentifier:@"goToCreateLit" sender:nil];
        }
        else if(selectedIndex == 1)
        {
            [self performSegueWithIdentifier:@"goToContinueTable" sender:nil];
        }
    }
}

- (IBAction)gameInfoClicked:(id)sender
{
    literatureType = [NSString stringWithFormat:@"none"];
    selection = [NSString stringWithFormat:@"gameInfo"];
    [self performSegueWithIdentifier:@"goToGameInfo" sender:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSInteger selectedIndex = segControl.selectedSegmentIndex;
    if([selection isEqualToString:@"literature"])
    {
        if(selectedIndex == 0)
        {
            CreateLitViewController *vc = [segue destinationViewController];
            vc.currentUser = currentUser;
            vc.literatureType = literatureType;
        }
        else if(selectedIndex == 1)
        {
            LiteratureTableViewController *vc = [segue destinationViewController];
            vc.currentUser = currentUser;
            vc.literatureType = literatureType;
        }
    }
    else if ([selection isEqualToString:@"profile"])
    {
        ProfilePage *vc = [segue destinationViewController];
        vc.currentUser = currentUser;
    }
    else
    {
        
    }
}

@end
