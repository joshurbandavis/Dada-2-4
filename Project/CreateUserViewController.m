#import "CreateUserViewController.h"

@implementation CreateUserViewController
@synthesize usernameField, passwordConfirmationField, passwordEntryField, emailField, emailErrorLabel, passwordErrorLabel, usernameErrorLabel, scrollView, securityAnswer, securityQuestion, questions, selectedQuestion;

- (void)viewDidLoad {
    [super viewDidLoad];
    [emailErrorLabel setHidden:YES];
    [passwordErrorLabel setHidden:YES];
    [usernameErrorLabel setHidden:YES];
    
    usernameField.delegate = self;
    passwordEntryField.delegate = self;
    passwordConfirmationField.delegate = self;
    emailField.delegate = self;
    securityAnswer.delegate = self;
    
    questions = [[NSMutableArray alloc]init];
    [questions addObject:@"What was the last name of your favorite teacher?"];
    [questions addObject:@"Where were you when you had your first kiss?"];
    [questions addObject:@"Who was your childhood hero?"];
    [questions addObject:@"What was the name of your second pet?"];
    self.title = [NSString stringWithFormat:@"Register"];
    [securityQuestion reloadAllComponents];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [questions count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [questions objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedQuestion = [questions objectAtIndex:row];
}

- (IBAction)submit:(id)sender {
    [emailErrorLabel setHidden:YES];
    [passwordErrorLabel setHidden:YES];
    [usernameErrorLabel setHidden:YES];
    BOOL isPwdValid = [self isPasswordValid:passwordEntryField.text];
    BOOL isEmailValid = [self isValidEmail:emailField.text];
    
    if (!isPwdValid)
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Invalid Password"
                                                        message:@"Password must be 6-20 characters and requires the following: uppercase and lowercase letters, a number, and a symbol! Ex: R3&iee"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert1 show];
    }
    if(!isEmailValid)
    {
        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Invalid Email"
                                                         message:@"Please enter a valid email. Ex: user@domain.com"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert1 show];
    }
    
    if(isPwdValid && isEmailValid)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Users"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                BOOL usernameWasFoundInDatabase = false;
                BOOL emailWasFoundInDatabase = false;
                BOOL passwordValid = true;
                for (PFObject *object in objects) {
                    if([usernameField.text isEqualToString:[object objectForKey:@"username"]])
                    {
                        usernameWasFoundInDatabase = true;
                        [usernameErrorLabel setHidden:NO];
                    }
                    if([emailField.text isEqualToString:[object objectForKey:@"email"]])
                    {
                        emailWasFoundInDatabase = true;
                        [emailErrorLabel setHidden:NO];
                    }
                }
                if(![passwordEntryField.text isEqualToString:passwordConfirmationField.text])
                {
                    [passwordErrorLabel setHidden:NO];
                    passwordValid = false;
                }
                if(!usernameWasFoundInDatabase && !emailWasFoundInDatabase && passwordValid)
                {
                    PFObject *users = [PFObject objectWithClassName:@"Users"];
                    users[@"username"] = usernameField.text;
                    users[@"password"] = passwordEntryField.text;
                    users[@"email"] = emailField.text;
                    users[@"securityQuestion"] = selectedQuestion;
                    users[@"securityAnswer"] = securityAnswer.text;
                    [users saveInBackground];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                    message:@"Profile Successfully Created!"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

-(BOOL) isValidEmail:(NSString *)email{
    NSString *expression = @"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:email options:0 range:NSMakeRange(0, [email length])];
    if(match)
        return true;
    else
        return false;
}

-(BOOL) isPasswordValid:(NSString *)pwd {
    
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    
    if ( [pwd length]<6 || [pwd length]>20 )
        return NO;  // too long or too short
    
    NSRange rang;
    NSRange range2;
    
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    NSLog(@"got here 1");
    
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )
        return NO;  // no number;
    NSLog(@"got here 2");
    
    rang = [pwd rangeOfCharacterFromSet:upperCaseChars];
    if ( !rang.length )
        return NO;  // no uppercase letter;
    NSLog(@"got here 3");
    
    rang = [pwd rangeOfCharacterFromSet:lowerCaseChars];
    if ( !rang.length )
        return NO;  // no lowerCase Chars;
    NSLog(@"got here 4");
    
    rang = [pwd rangeOfCharacterFromSet:[NSCharacterSet symbolCharacterSet]];
    range2 = [pwd rangeOfCharacterFromSet:[NSCharacterSet punctuationCharacterSet]];
    if ( !rang.length && !range2.length)
        return NO;  // no symbol;
    NSLog(@"got here 5");
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
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
    const int movementDistance = 175; // tweak as needed
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