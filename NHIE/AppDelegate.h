//
//  AppDelegate.h
//  NHIE
//
//  Created by David Brooks on 5/15/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStorage.h"
#import "MKStoreManager.h"
#import <Crashlytics/Crashlytics.h>
#import "ALSdk.h"
#import "Flurry.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
