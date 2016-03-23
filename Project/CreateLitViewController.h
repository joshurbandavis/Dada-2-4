#import <UIKit/UIKit.h>
#import "Literature.h"
#import "User.h"
#import <Parse/Parse.h>

@interface CreateLitViewController : UIViewController <UITextFieldDelegate>

@property Literature *literature;
@property NSString *literatureType;
@property User *currentUser;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *lineLimitField;
@property (weak, nonatomic) IBOutlet UITextField *firstLineField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end