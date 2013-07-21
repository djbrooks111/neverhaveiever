//
//  AppLovinBannerCustomEvent.h
//  NHIE
//
//  Created by David Brooks on 7/19/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import "MPBannerCustomEvent.h"

#import "ALAdView.h"

@interface AppLovinBannerCustomEvent : MPBannerCustomEvent <ALAdLoadDelegate> {
    ALAdView * _applovinBannerView;
}


@end
