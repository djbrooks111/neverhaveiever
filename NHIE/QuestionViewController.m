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
    NSLog(@"viewDidLoad entered");
    
    // Creating background view
    [self createBackgroundView];
    
    if ([MKStoreManager isFeaturePurchased:@"removeAds"]) {
        // SHOW NO ADS
        [self.adView setHidden:YES];
        [self.adView setAlpha:0];
        [self.adView removeFromSuperview];
        self.adView = NULL;
        self.interstitial = NULL;
        [removeAdButton setHidden:YES];
        [removeAdButton removeFromSuperview];
        removeAdButton.frame = CGRectMake(0, 0, 0, 0);
        removeAdButton = NULL;
    } else {
        // SHOW ADS
        // MoPub
        self.adView = [[MPAdView alloc] initWithAdUnitId:@"6f71e4b432744296a12deede3df084a3" size:MOPUB_BANNER_SIZE];
        self.adView.testing = YES;
        self.adView.delegate = self;
        [self.adView startAutomaticallyRefreshingContents];
        CGRect frame = self.adView.frame;
        CGSize size = [self.adView adContentViewSize];
        frame.origin.y = [[UIScreen mainScreen] applicationFrame].size.height - size.height;
        self.adView.frame = frame;
        [self.view addSubview:self.adView];
        [self.adView loadAd];
        
        self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"b58296ef5de043a6be0270ee5ff35a4e"];
        self.interstitial.testing = YES;
        self.interstitial.delegate = self;
        [self.interstitial loadAd];
        
        otherAdTracker = 1;
        
        NSLog(@"MoPub Banner Testing: %@ and Full Screen Testing: %@", self.adView.testing ? @"YES" : @"NO", self.interstitial.testing ? @"YES" : @"NO");
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
        if (otherAdTracker == 1) {
            otherAdTracker = 0;
        } else {
            [self.adView loadAd];
            [self.interstitial loadAd];
        }
    }
    
    // Creating navigation bar
    navigationBar.topItem.title = categoryString;
    
    // ADS
    if ([MKStoreManager isFeaturePurchased:@"removeAds"]) {
        [self.adView setHidden:YES];
        [self.adView setAlpha:0];
        [self.adView removeFromSuperview];
        self.adView = NULL;
        self.interstitial = NULL;
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
    if (self.interstitial.ready) {
        [self.interstitial showFromViewController:self];
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
         [self.adView setHidden:YES];
         [self.adView setAlpha:0];
         [self.adView removeFromSuperview];
         self.adView = NULL;
         self.interstitial = NULL;
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

// MoPub Banner
-(UIViewController *)viewControllerForPresentingModalView {
    return self;
}

-(void)adViewDidLoadAd:(MPAdView *)view {
    NSLog(@"MoPub ad loaded");
    CGSize size = [view adContentViewSize];
    CGFloat centeredX = (self.view.bounds.size.width - size.width) / 2;
    CGFloat bottomAlignedY = self.view.bounds.size.height - size.height;
    view.frame = CGRectMake(centeredX, bottomAlignedY, size.width, size.height);
    [self.adView setHidden:NO];
}

-(void)adViewDidFailToLoadAd:(MPAdView *)view {
    NSLog(@"MoPub ad failed to load");
    [self.adView setHidden:YES];
}

-(void)willPresentModalViewForAd:(MPAdView *)view {
    NSLog(@"MoPub ad has been clicked");
}

-(void)didDismissModalViewForAd:(MPAdView *)view {
    NSLog(@"MoPub ad was closed");
}

-(void)willLeaveApplicationFromAd:(MPAdView *)view {
    NSLog(@"MoPub leaving app");
}

// MoPub Interstitial
-(void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Full Screen ad loaded");
}

-(void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Full Screen ad failed to load");
}

-(void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Full Screen ad about to appear");
    adTracker = 1;
}

-(void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Full Screen ad about to disappear");
}

-(void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"MoPub Full Screen ad appeared");
}

-(void)interstitialDidDisappear:(MPInterstitialAdController *)interstitialView {
    NSLog(@"MoPub Full Screen ad disappeared");
    if (![self.presentedViewController isBeingDismissed]) {
        [self leaveView];
    }
}

/*
-(void)burstlyBannerAdView:(BurstlyBannerAdView *)view didHide:(NSString *)lastViewedNetwork {
    NSLog(@"Burstly ad hidden with network: %@", lastViewedNetwork);
}

-(void)burstlyBannerAdView:(BurstlyBannerAdView *)view didShow:(NSString *)adNetwork {
    NSLog(@"Burstly ad shown with network: %@", adNetwork);
    [self.banner setHidden:NO];
}

-(void)burstlyBannerAdView:(BurstlyBannerAdView *)view didCache:(NSString *)adNetwork {
    NSLog(@"Burstly ad pre-cached with network: %@", adNetwork);
}

-(void)burstlyBannerAdView:(BurstlyBannerAdView *)view wasClicked:(NSString *)adNetwork {
    NSLog(@"Burstly ad was clicked with network: %@", adNetwork);
}

-(void)burstlyBannerAdView:(BurstlyBannerAdView *)view didFailWithError:(NSError *)error {
    NSLog(@"Burstly ad failed with error: %@", error);
    [self.banner setHidden:YES];
}
 */

/*
-(void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"Dismissed full screen ad");
    adTracker = 1;
}
 */

-(void)leaveView {
    questionLabel.text = @"";
    navigationBar.topItem.title = @"";
    [self.adView stopAutomaticallyRefreshingContents];
    [self.adView setHidden:YES];
    [questionArray removeAllObjects];
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
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