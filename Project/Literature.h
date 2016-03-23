#import <Foundation/Foundation.h>
#import "User.h"

@interface Literature : NSObject

@property NSString *title;
@property NSString *literatureType;
@property BOOL isPublic;
@property int linesLeft;
@property NSMutableArray *lines;
@property NSMutableArray *authors;
@property NSString *currentLine;

@end