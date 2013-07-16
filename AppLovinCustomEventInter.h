//
//  AppLovinCustomEventInter.h
//  NHIE
//
//  Created by David Brooks on 7/9/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADCustomEventInterstitial.h"
#import "GADCustomEventInterstitialDelegate.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "ALAdService.h"
#import "ALInterstitialAd.h"

@interface AppLovinCustomEventInter : NSObject <GADCustomEventInterstitialDelegate,GADCustomEventInterstitial, ALAdLoadDelegate, ALAdDisplayDelegate>  {
    ALInterstitialAd *appLovinInter;
    ALAd *appLovinAd;
}

@end
