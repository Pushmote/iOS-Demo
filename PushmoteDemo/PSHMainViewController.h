#import <UIKit/UIKit.h>

@interface PSHMainViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel* applicationId;
@property (weak, nonatomic) IBOutlet UIButton *popoverButton;
@property (nonatomic, assign) NSString* applicationKey;

- (void)checkReady;

@end
