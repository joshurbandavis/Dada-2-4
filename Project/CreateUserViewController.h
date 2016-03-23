#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateUserViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntryField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UILabel *emailErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameErrorLabel;
@property UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIPickerView *securityQuestion;
@property (weak, nonatomic) IBOutlet UITextField *securityAnswer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property NSMutableArray *questions;
@property NSString *selectedQuestion;

@end