//
//  QuestionViewController.h
//  NHIE
//
//  Created by David Brooks on 5/15/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADInterstitial.h"
#import "GADBannerViewDelegate.h"
#import "GADInterstitialDelegate.h"
#import "DataStorage.h"
#import "MBProgressHUD.h"
#import "MKStoreManager.h"

@interface QuestionViewController : UIViewController <GADBannerViewDelegate, GADInterstitialDelegate> {
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIBarButtonItem *navigationBarBackButton;
    NSMutableArray *questionArray;
    IBOutlet UILabel *questionLabel;
    IBOutlet UIButton *nextButton;
    IBOutlet UIButton *removeAdButton;
    int indexTracker;
    int adTracker;

    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
}

@property (nonatomic, retain) NSMutableArray *questionArray;

-(void)setAdTracker:(int)tracker;

@end
