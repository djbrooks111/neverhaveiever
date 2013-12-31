//
//  ViewController.m
//  NHIE
//
//  Created by David Brooks on 5/15/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import "ViewController.h"

#define IS_SHORT_IPHONE     ([UIScreen mainScreen].bounds.size.height == 480)
#define IS_TALL_IPHONE      ([UIScreen mainScreen].bounds.size.height == 568)
#define SHORT_IPHONE_HEIGHT 480
#define TALL_IPHONE_HEIGHT  568
#define DEVICE_WIDTH        320
#define IS_RETINA_DISPLAY   ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && [UIScreen mainScreen].scale == 2.0)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Navigation Bar
    navigationBar.topItem.title = @"Pick Your Category";
    
    // Creating the background view
    [self createBackgroundView];
    
    // In App Purchases
    inAppPurchaseManager = [[InAppPurchaseManager alloc] init];
    [inAppPurchaseManager loadStore];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyRan"]) {
        // Has not run before
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AlreadyRan"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"To get started, tap the icon in the middle of the screen!" delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Creating the menu
    [self createMenuView];
}

-(void)createBackgroundView {
    // Creating needed variable
    UIImage *backgroundImage = [UIImage imageNamed:@"CategoryBackground.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    if (IS_SHORT_IPHONE) {
        // iPhone 4S - Regular and 2x backgrounds
        backgroundImageView.frame = CGRectMake(0, navigationBar.frame.size.height, DEVICE_WIDTH, SHORT_IPHONE_HEIGHT - navigationBar.frame.size.height);
    } else if (IS_TALL_IPHONE) {
        backgroundImageView.frame = CGRectMake(0, navigationBar.frame.size.height, DEVICE_WIDTH, TALL_IPHONE_HEIGHT - navigationBar.frame.size.height);
    }
    
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
}

-(void)createMenuView {
    if (IS_SHORT_IPHONE) {
        // iPhone 4S
        dirtySexButton.frame = CGRectMake(21, 81, 278, 45);
        schoolButton.frame = CGRectMake(21, 146, 278, 45);
        relationshipsButton.frame = CGRectMake(21, 211, 278, 45);
        workButton.frame = CGRectMake(21, 276, 278, 45);
        drinkingButton.frame = CGRectMake(21, 341, 278, 45);
        randomButton.frame = CGRectMake(21, 406, 278, 45);
    } else if (IS_TALL_IPHONE) {
        // iPhone 5
        dirtySexButton.frame = CGRectMake(21, 121, 278, 45);
        schoolButton.frame = CGRectMake(21, 186, 278, 45);
        relationshipsButton.frame = CGRectMake(21, 251, 278, 45);
        workButton.frame = CGRectMake(21, 316, 278, 45);
        drinkingButton.frame = CGRectMake(21, 381, 278, 45);
        randomButton.frame = CGRectMake(21, 446, 278, 45);
    }
    
    // Setting button images
    [dirtySexButton setImage:[UIImage imageNamed:@"DirtySexButton.png"] forState:UIControlStateNormal];
    [schoolButton setImage:[UIImage imageNamed:@"SchoolButton.png"] forState:UIControlStateNormal];
    [relationshipsButton setImage:[UIImage imageNamed:@"RelationshipsButton.png"] forState:UIControlStateNormal];
    [workButton setImage:[UIImage imageNamed:@"WorkButton.png"] forState:UIControlStateNormal];
    [drinkingButton setImage:[UIImage imageNamed:@"DrinkingButton.png"] forState:UIControlStateNormal];
    [randomButton setImage:[UIImage imageNamed:@"RandomButton.png"] forState:UIControlStateNormal];
}

-(IBAction)categoryButtonClicked:(UIButton *)button {
    NSLog(@"User selected button tag: %d", button.tag);
    
    switch (button.tag) {
        case 0:
            categoryString = @"Dirty & Sex";
            urlString = @"DirtyAndSexPhrases";
            break;
            
        case 1:
            categoryString = @"School";
            urlString = @"SchoolPhrases";
            break;
            
        case 2:
            categoryString = @"Relationships";
            urlString = @"RelationshipsPhrases";
            break;
            
        case 3:
            categoryString = @"Work";
            urlString = @"WorkPhrases";
            break;
            
        case 4:
            categoryString = @"Drinking";
            urlString = @"DrinkingPhrases";
            break;
            
        case 5:
            categoryString = @"Random";
            urlString = @"RandomPhrases";
            break;
            
        default:
            break;
    }
    
    [Flurry logEvent:[NSString stringWithFormat:@"Selected %@", categoryString]];
    
    // Go to next view
    [self presentViewController:questionView animated:YES completion:NULL];
}

-(IBAction)about {
    aboutView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:aboutView animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
