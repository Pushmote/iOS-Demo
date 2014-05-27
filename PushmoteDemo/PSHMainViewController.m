#import "PSHMainViewController.h"
#import "PushmoteSDK/Headers/Pushmote.h"

@interface PSHMainViewController ()

@end

static NSString *const URL = @"https://api.pushmote.com/";

@implementation PSHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.popoverButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:(UIControlEvents)UIControlEventTouchDown];

    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"appKey"]) {
        
        NSString *requestUrl = [URL stringByAppendingString:@"applications/createDemoApp"];
        NSURL *url = [NSURL URLWithString:requestUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             if (data.length > 0 && connectionError == nil)
             {
                 NSDictionary *avatars= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                 NSString *val = [avatars objectForKey:@"applicationId"];
                 [[NSUserDefaults standardUserDefaults] setValue:val forKey:@"appKey"];
                 [self.applicationId setText:val];
                 self.applicationKey = val;
             }
         }];
    } else {
        NSString* val = [[NSUserDefaults standardUserDefaults] stringForKey:@"appKey"];
        [self.applicationId setText:val];
        self.applicationKey = val;
    }
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"firstInit"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"true" forKey:@"firstInit"];
    } else {
        [self checkReady];
    }


}

- (void)checkReady {
    
    NSString *requestUrl = [URL stringByAppendingString:@"rest/ready?appKey="];
    requestUrl = [requestUrl stringByAppendingString:self.applicationKey];
    
    NSURL *url = [NSURL URLWithString:requestUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *avatars= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             if ([[avatars objectForKey:@"ready"]boolValue]){
                 UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"scenarioBoard"];
                 [self.navigationController pushViewController:vc animated:YES];
                 
                 [Pushmote startWithApplicationKey:self.applicationKey];
                 
             } else {
                 UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"No scenarioboard!" message: @"You have no scenarioboard for this application yet. Please create a scenarioboard from dashboard.pushmote.com" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];
                 [someError show];
             }
         }
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)nextButtonClick:(id)sender {
    [self checkReady];
}

@end
