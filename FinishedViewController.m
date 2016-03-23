#import "FinishedViewController.h"

@interface FinishedViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *storyTextField;

@end

@implementation FinishedViewController
@synthesize lit, titleLabel, storyTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"Completed Literature"];
    titleLabel.text = lit.title;
    
    NSString *story = [[NSString alloc]init];
    
    for(NSString *string in lit.lines)
    {
        if([story isEqualToString:@""])
        {
            story = string;
        }
        else
        {
            story = [NSString stringWithFormat:@"%@\n%@", story, string];
        }
    }
    storyTextField.text = story;
    storyTextField.textAlignment = NSTextAlignmentCenter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)homeClicked:(id)sender
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

@end
