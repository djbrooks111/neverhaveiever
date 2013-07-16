//
//  ViewController.h
//  NHIE
//
//  Created by David Brooks on 5/15/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionViewController.h"
#import "DataStorage.h"
#import "AwesomeMenu.h"
#import "AboutViewController.h"

@interface ViewController : UIViewController <AwesomeMenuDelegate> {
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet QuestionViewController *questionView;
    IBOutlet AboutViewController *aboutView;
}

@end
