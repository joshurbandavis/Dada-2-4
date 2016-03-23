#import "AddLineViewController.h"

@implementation AddLineViewController
@synthesize currentUser, literatureType, nextLineTextField, selectedIndex, poetryArray, fictionArray, selectedTitle, lastLineView, literatureTitle, scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Add a Line"];
    if([literatureType isEqualToString:@"poetry"])
    {
        Literature *tempLiterature = [poetryArray objectAtIndex:selectedIndex];
        selectedTitle = tempLiterature.title;
        lastLineView.text = [NSString stringWithFormat:@"%@", tempLiterature.currentLine];
        lastLineView.textAlignment = NSTextAlignmentCenter;
    }
    else if([literatureType isEqualToString:@"fiction"])
    {
        Literature *tempLiterature = [fictionArray objectAtIndex:selectedIndex];
        selectedTitle = tempLiterature.title;
        lastLineView.text = [NSString stringWithFormat:@"%@", tempLiterature.currentLine];
        lastLineView.textAlignment = NSTextAlignmentCenter;
    }
    literatureTitle.text = [NSString stringWithFormat:@"%@", selectedTitle];
    
    nextLineTextField.delegate = self;
    [self setToPublic:@"false"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)homeClicked:(id)sender {
    [self setToPublic:@"true"];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

- (void)setToPublic:(NSString *)option{
    PFQuery *query = [PFQuery queryWithClassName:@"Literature"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                if([literatureTitle.text isEqualToString:[object objectForKey:@"title"]] && [lastLineView.text isEqualToString:[object objectForKey:@"currentLine"]])
                {
                    object[@"isPublic"] = option;
                    
                    [object saveInBackground];
                }
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (IBAction)submit:(id)sender {
    [self setToPublic:@"true"];
    PFQuery *query = [PFQuery queryWithClassName:@"Literature"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *lit in objects) {
                if([selectedTitle isEqualToString:[lit objectForKey:@"title"]])
                {
                    lit[@"linesLeft"] = [NSString stringWithFormat:@"%i", [[lit objectForKey:@"linesLeft"]intValue] - 1];
                    NSMutableArray *tempLines = [lit objectForKey:@"lines"];
                    [tempLines addObject:nextLineTextField.text];
                    lit[@"lines"] = tempLines;
                    lit[@"currentLine"] = nextLineTextField.text;
                    NSMutableArray *tempAuthors = [lit objectForKey:@"authors"];
                    BOOL authorFound = false;
                    for (NSString *author in tempAuthors) {
                        if([author isEqualToString:currentUser.username])
                            authorFound = true;
                    }
                    if(!authorFound)
                    {
                        [tempAuthors addObject:currentUser.username];
                    }
                    lit[@"authors"] = tempAuthors;
                    [lit saveInBackground];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"Line Successfully Added!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                }
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [self setToPublic:@"true"];
    }
    [super viewWillDisappear:animated];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 60; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
