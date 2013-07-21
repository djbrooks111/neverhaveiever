//
//  AppLovinInterstitialCustomEvent.h
//  NHIE
//
//  Created by David Brooks on 7/19/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import "MPInterstitialCustomEvent.h"

#import "ALInterstitialAd.h"
#import "ALAdService.h"

@interface AppLovinInterstitialCustomEvent : MPInterstitialCustomEvent <ALAdDisplayDelegate, ALAdLoadDelegate> {
    ALInterstitialAd * _interstitialAd;
    ALAd * _loadedAd;
}

@end
