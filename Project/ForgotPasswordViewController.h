#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController <UITextFieldDelegate>

@property NSString *username;
@property NSString *securityAnswer;
@property NSString *securityQuestion;
@property NSString *password;
@property (weak, nonatomic) IBOutlet UILabel *securityQuestionLabel;
@property (weak, nonatomic) IBOutlet UITextField *securityQuestionAnswerField;

@end
