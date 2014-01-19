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
#import "AboutViewController.h"

@interface ViewController : UIViewController {
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet QuestionViewController *questionView;
    IBOutlet AboutViewController *aboutView;
    
    // Category Buttons
    IBOutlet UIButton *dirtySexButton;
    IBOutlet UIButton *schoolButton;
    IBOutlet UIButton *relationshipsButton;
    IBOutlet UIButton *workButton;
    IBOutlet UIButton *drinkingButton;
    IBOutlet UIButton *randomButton;
}

- (IBAction)categoryButtonClicked:(UIButton *)button;

@end
