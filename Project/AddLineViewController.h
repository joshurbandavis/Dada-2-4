#import <UIKit/UIKit.h>
#import "User.h"
#import "Literature.h"
#import <Parse/Parse.h>

@interface AddLineViewController : UIViewController <UIAlertViewDelegate, UITextFieldDelegate>

@property User *currentUser;
@property NSString *literatureType;
@property int *selectedIndex;
@property NSMutableArray *poetryArray;
@property NSMutableArray *fictionArray;
@property (weak, nonatomic) IBOutlet UITextField *nextLineTextField;
@property NSString *selectedTitle;
@property (weak, nonatomic) IBOutlet UITextView *lastLineView;
@property (weak, nonatomic) IBOutlet UILabel *literatureTitle;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
