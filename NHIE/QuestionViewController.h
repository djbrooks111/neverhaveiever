//
//  QuestionViewController.h
//  NHIE
//
//  Created by David Brooks on 5/15/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStorage.h"
#import "MBProgressHUD.h"
#import "MPAdView.h"
#import "MPInterstitialAdController.h"
#import "Flurry.h"

@interface QuestionViewController : UIViewController <MPAdViewDelegate, MPInterstitialAdControllerDelegate> {
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIBarButtonItem *navigationBarBackButton;
    NSMutableArray *questionArray;
    IBOutlet UILabel *questionLabel;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *removeAdButton;
    int indexTracker;
    int adTracker;
    int otherAdTracker;
}

@property (nonatomic, retain) NSMutableArray *questionArray;
@property (nonatomic, retain) MPAdView *adView;
@property (nonatomic, retain) MPInterstitialAdController *interstitial;

-(void)setAdTracker:(int)tracker;
-(void)leaveView;

@end
