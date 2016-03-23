#import "ViewController.h"

@implementation ViewController
@synthesize launchScreenSelection, currentUser, usernameTextField, passwordTextField, usernameErrorLabel, passwordErrorLabel, scrollView, securityAnswer, securityQuestion, password;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [usernameErrorLabel setHidden:YES];
    [passwordErrorLabel setHidden:YES];
    currentUser = [[User alloc]init];
    
    usernameTextField.delegate = self;
    passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([launchScreenSelection isEqualToString:@"login"] || [launchScreenSelection isEqualToString:@"guest"])
    {
        GameMenuViewController *vc = [segue destinationViewController];
        vc.currentUser = currentUser;
    }
    else if([launchScreenSelection isEqualToString:@"forgot"])
    {
        ForgotPasswordViewController *vc = [segue destinationViewController];
        vc.username = usernameTextField.text;
        vc.securityAnswer = securityAnswer;
        vc.securityQuestion = securityQuestion;
        vc.password = password;
    }
}

- (IBAction)guestClicked:(id)sender {
    currentUser.username = @"guest";
    currentUser.email = @"guest";
    currentUser.password = @"guest";
    launchScreenSelection = @"guest";
}

- (IBAction)loginClicked:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Users"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if(objects.count == 0)
            {
                [usernameErrorLabel setHidden:NO];
            }
            BOOL usernameNotFound = true;
            for (PFObject *object in objects) {
                if([usernameTextField.text isEqualToString:[object objectForKey:@"username"]])
                {
                    [usernameErrorLabel setHidden:YES];
                    usernameNotFound = false;
                    
                    if([passwordTextField.text isEqualToString:[object objectForKey:@"password"]])
                    {
                        [passwordErrorLabel setHidden:YES];
                        currentUser.username = usernameTextField.text;
                        currentUser.password = passwordTextField.text;
                        currentUser.email = [object objectForKey:@"email"];
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                        message:@"Login Successful!"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Ok"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [self performSegueWithIdentifier:@"login" sender:nil];
                    }
                    else
                    {
                        [passwordErrorLabel setHidden:NO];
                    }
                }
            }
            if(usernameNotFound){
                [usernameErrorLabel setHidden:NO];
            }
        }
        else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    launchScreenSelection = @"login";
}

- (IBAction)createClicked:(id)sender {
    launchScreenSelection = @"create";
}

- (IBAction)forgotPasswordClicked:(id)sender
{
    launchScreenSelection = @"forgot";
    if([usernameTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please enter your username in the username field to retrieve your password!"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            BOOL usernameFound = false;
            if (!error) {
                for (PFObject *object in objects) {
                    if([usernameTextField.text isEqualToString:[object objectForKey:@"username"]])
                    {
                        usernameFound = true;
                        securityAnswer = [object objectForKey:@"securityAnswer"];
                        securityQuestion = [object objectForKey:@"securityQuestion"];
                        password = [object objectForKey:@"password"];
                    }
                }
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            if(!usernameFound)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Username was not found in the database! Please re-enter your username."
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            else
            {
                [self performSegueWithIdentifier:@"forgotPassword" sender:nil];
            }
        }];
    }
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