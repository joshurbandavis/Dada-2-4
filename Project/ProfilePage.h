#import <UIKit/UIKit.h>
#import "User.h"
#import <Parse/Parse.h>

@interface ProfilePage : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>
@property User *currentUser;
@property (nonatomic, strong) User *user;
@property NSString *selection;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@end
