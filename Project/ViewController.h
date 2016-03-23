#import <UIKit/UIKit.h>
#import "User.h"
#import "GameMenuViewController.h"
#import <Parse/Parse.h>
#import "ForgotPasswordViewController.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

@property NSString *launchScreenSelection;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *usernameErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;
@property User *currentUser;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property NSString *securityAnswer;
@property NSString *securityQuestion;
@property NSString *password;

@end

