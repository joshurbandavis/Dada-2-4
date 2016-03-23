#import "CreateLitViewController.h"

@implementation CreateLitViewController
@synthesize literature, literatureType, currentUser, titleField, lineLimitField, firstLineField, scrollView;


- (void)viewDidLoad {
    [super viewDidLoad];
    literature = [[Literature alloc]init];
    literature.lines = [[NSMutableArray alloc]init];
    literature.authors = [[NSMutableArray alloc]init];
    if([literatureType isEqualToString:@"poetry"])
    {
        self.title = [NSString stringWithFormat:@"Create Poetry"];
    }
    else
    {
        self.title = [NSString stringWithFormat:@"Create Fiction"];
    }
    lineLimitField.delegate = self;
    titleField.delegate = self;
    firstLineField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)createStory:(id)sender {
    literature.title = titleField.text;
    literature.literatureType = literatureType;
    literature.linesLeft = [lineLimitField.text intValue] - 1;
    [literature.lines addObject:firstLineField.text];
    [literature.authors addObject:currentUser.username];
    literature.currentLine = firstLineField.text;
    literature.isPublic = true;

    PFQuery *query = [PFQuery queryWithClassName:@"Literature"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *literatureObj = [PFObject objectWithClassName:@"Literature"];
            literatureObj[@"title"] = literature.title;
            literatureObj[@"literatureType"] = literature.literatureType;
            literatureObj[@"isPublic"] = [NSString stringWithFormat:@"%@", literature.isPublic ? @"true" : @"false"];
            literatureObj[@"linesLeft"] = [NSString stringWithFormat:@"%i", literature.linesLeft];
            literatureObj[@"lines"] = literature.lines;
            literatureObj[@"authors"] = literature.authors;
            literatureObj[@"currentLine"] = literature.currentLine;
            [literatureObj saveInBackground];
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                    message:@"Successfully Created!"
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
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