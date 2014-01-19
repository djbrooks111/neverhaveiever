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

@interface QuestionViewController : UIViewController {
    IBOutlet UINavigationBar *navigationBar;
    IBOutlet UIBarButtonItem *navigationBarBackButton;
    NSMutableArray *questionArray;
    IBOutlet UILabel *questionLabel;
    IBOutlet UIButton *nextButton;
    int indexTracker;
}

@property (nonatomic, retain) NSMutableArray *questionArray;

-(void)leaveView;

@end
