//
//  QuestionViewController.m
//  NHIE
//
//  Created by David Brooks on 5/15/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import "QuestionViewController.h"

#define IS_SHORT_IPHONE     ([UIScreen mainScreen].bounds.size.height == 480)
#define IS_TALL_IPHONE      ([UIScreen mainScreen].bounds.size.height == 568)
#define SHORT_IPHONE_HEIGHT 480
#define TALL_IPHONE_HEIGHT  568
#define DEVICE_WIDTH        320
#define IS_RETINA_DISPLAY   ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && [UIScreen mainScreen].scale == 2.0)

@interface QuestionViewController ()

@end

@implementation QuestionViewController

@synthesize questionArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Creating background view
    [self createBackgroundView];
    
    if ([MKStoreManager isFeaturePurchased:@"removeAds"]) {
        // SHOW NO ADS
        [bannerView_ setHidden:YES];
        [bannerView_ setAlpha:0];
        [bannerView_ removeFromSuperview];
        bannerView_ = NULL;
        interstitial_ = NULL;
        [removeAdButton setHidden:YES];
        [removeAdButton removeFromSuperview];
        removeAdButton.frame = CGRectMake(0, 0, 0, 0);
        removeAdButton = NULL;
    }
    
    navigationBar.topItem.title = categoryString;
    
    questionArray = [[NSMutableArray alloc] init];
    indexTracker = -1;
    adTracker = 0;
}

-(void)createBackgroundView {
    // Creating needed variables
    UIImage *backgroundImage = [UIImage imageNamed:@"QuestionBackground.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [nextButton setImage:[UIImage imageNamed:@"QuestionButton.png"] forState:UIControlStateNormal];
    [removeAdButton setHidden:NO];
    
    if (IS_SHORT_IPHONE) {
        // iPhone 4S - Regular and 2x backgrounds
        backgroundImageView.frame = CGRectMake(0, navigationBar.frame.size.height, DEVICE_WIDTH, SHORT_IPHONE_HEIGHT - navigationBar.frame.size.height);
        nextButton.frame = CGRectMake(20, 325, nextButton.frame.size.width, nextButton.frame.size.height);
        questionLabel.frame = CGRectMake(70, 150, questionLabel.frame.size.width, questionLabel.frame.size.height);
    } else if (IS_TALL_IPHONE) {
        backgroundImageView.frame = CGRectMake(0, navigationBar.frame.size.height, DEVICE_WIDTH, TALL_IPHONE_HEIGHT - navigationBar.frame.size.height);
        nextButton.frame = CGRectMake(20, 390, nextButton.frame.size.width, nextButton.frame.size.height);
        questionLabel.frame = CGRectMake(70, 185, questionLabel.frame.size.width, questionLabel.frame.size.height);
    }
    
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    NSLog(@"Adtracker: %d", adTracker);
    
    if (adTracker == 1) {
        adTracker = 0;
        [self leaveView];
    } else {
        // Admob Mediation
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.adUnitID = @"72897db595724f84";
        [bannerView_ setDelegate:self];
        bannerView_.rootViewController = self;
        [bannerView_ setHidden:YES];
        [self.view addSubview:bannerView_];
        
        GADRequest *request = [GADRequest request];
        //request.testDevices = [NSArray arrayWithObjects:@"ae2f7740d94b1d3be529b0959e8893d7", @"GAD_SIMULATOR_ID", nil];
        [bannerView_ loadRequest:request];
    
        interstitial_ = [[GADInterstitial alloc] init];
        interstitial_.adUnitID = @"da932c2478bf4b41";
        [interstitial_ setDelegate:self];
        [interstitial_ loadRequest:request];
    }
    
    // Creating navigation bar
    navigationBar.topItem.title = categoryString;
    
    // ADS
    if ([MKStoreManager isFeaturePurchased:@"removeAds"]) {
        [bannerView_ setHidden:YES];
        [bannerView_ setAlpha:0];
        [bannerView_ removeFromSuperview];
        bannerView_ = NULL;
        interstitial_ = NULL;
        [removeAdButton setHidden:YES];
        [removeAdButton removeFromSuperview];
        removeAdButton.frame = CGRectMake(0, 0, 0, 0);
        removeAdButton = NULL;
    } else {
        [removeAdButton setHidden:NO];
    }
    
    questionLabel.text = @"";
    [questionArray removeAllObjects];
    
    // Getting questions
    [self showProgressView];
}

-(IBAction)goBack {
    if (interstitial_.isReady) {
        // Show ad
        [interstitial_ presentFromRootViewController:self];
    } else {
        [self leaveView];
    }
}

-(IBAction)removeAds {
    NSLog(@"Button Clicked");
    [[MKStoreManager sharedManager] buyFeature:@"removeAds"
                                    onComplete:^(NSString* purchasedFeature, NSData* receiptData, NSArray* other)
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more ads for you!" message:@"You have successfully removed advertisements from\nNever Have I Ever!\nEnjoy!" delegate:self cancelButtonTitle:@"Done!" otherButtonTitles:nil, nil];
         [alert show];
         NSLog(@"Purchased: %@", purchasedFeature);
         [bannerView_ setHidden:YES];
         [bannerView_ setAlpha:0];
         [bannerView_ removeFromSuperview];
         bannerView_ = NULL;
         interstitial_ = NULL;
         [removeAdButton setHidden:YES];
         [removeAdButton removeFromSuperview];
         removeAdButton.frame = CGRectMake(0, 0, 0, 0);
         removeAdButton = NULL;
     }
                                   onCancelled:^
     {
         NSLog(@"User Cancelled Transaction");
     }];
}

// ADMOB METHODS
-(void)adViewDidReceiveAd:(GADBannerView *)view {
    NSLog(@"Showing AdMob Ad");
    [bannerView_ setHidden:NO];
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView_.frame = CGRectMake(0, self.view.frame.size.height - bannerView_.frame.size.height, bannerView_.frame.size.width, bannerView_.frame.size.height);
    [UIView commitAnimations];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"AdMob banner error: %@", error);
    [bannerView_ setHidden:YES];
}

-(void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"Received full screen ad");
}

-(void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"Dismissed full screen ad");
    adTracker = 1;
}

-(void)leaveView {
    questionLabel.text = @"";
    navigationBar.topItem.title = @"";
    [bannerView_ setHidden:YES];
    [questionArray removeAllObjects];
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"AdMob Full error: %@", error);
    //[self leaveView];
}

-(void)setAdTracker:(int)tracker {
    adTracker = tracker;
}

// Getting questions
-(void)showProgressView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading Questions...";
    hud.dimBackground = YES;
    sleep(1);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // DO STUFF
        [self getQuestions];
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

-(void)getQuestions {
    NSString *addressString = [NSString stringWithFormat:@"http://www.brooksphere.com/neverhaveiever/%@.txt", urlString];
    NSURL *url = [NSURL URLWithString:addressString];
    NSString *myFile = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:NULL];
    NSArray *phrases = [myFile componentsSeparatedByString:@"\n"];
    [questionArray addObjectsFromArray:phrases];
    NSLog(@"Count: %d", [questionArray count]);
    
    if ([questionArray count] == 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:urlString ofType:@"txt"];
        NSString *myFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        NSArray *phrases = [myFile componentsSeparatedByString:@"\n"];
        [questionArray addObjectsFromArray:phrases];
        NSLog(@"New Count: %d", [questionArray count]);
    }
}

-(void)shuffleQuestions {
    for (int i = 0; i < [questionArray count]; i++) {
        NSString *neededString = [questionArray objectAtIndex:i];
        neededString = [neededString stringByReplacingOccurrencesOfString:@"=" withString:@"\r"];
        [questionArray removeObjectAtIndex:i];
        [questionArray insertObject:neededString atIndex:i];
    }
    
    NSUInteger firstObject = 0;
    for (int x = 0; x < [questionArray count]; x++) {
        NSUInteger randomIndex = arc4random() % [questionArray count];
        [questionArray exchangeObjectAtIndex:firstObject withObjectAtIndex:randomIndex];
        firstObject += 1;
    }
    NSLog(@"Shuffles array:\n\n%@", questionArray);
}

-(void)displayQuestion {
    indexTracker++;
    
    if (indexTracker == [questionArray count] - 1) {
        [self shuffleQuestions];
        indexTracker = 0;
    }
    questionLabel.text = [questionArray objectAtIndex:indexTracker];
}

-(IBAction)nextQuestion {
    [self displayQuestion];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        [self displayQuestion];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end