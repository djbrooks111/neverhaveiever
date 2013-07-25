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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // Navigation Bar
    navigationBar.topItem.title = @"Pick Your Category";
    
    // Creating the background view
    [self createBackgroundView];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"AlreadyRan"]) {
        // Has not run before
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"AlreadyRan"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome!" message:@"To get started, tap the icon in the middle of the screen!" delegate:self cancelButtonTitle:@"Okay!" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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
    
    navigationBar.frame = CGRectMake(0, 0, navigationBar.frame.size.width, navigationBar.frame.size.height);
    
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
}

-(void)createMenuView {
    AwesomeMenuItem *dirtySexItem = [[AwesomeMenuItem alloc]
                                     initWithImage:[UIImage imageNamed:@"Dirty.png"]
                                     highlightedImage:nil
                                     ContentImage:[UIImage imageNamed:@"Dirty.png"]
                                     highlightedContentImage:nil];
    AwesomeMenuItem *schoolItem = [[AwesomeMenuItem alloc]
                                   initWithImage:[UIImage imageNamed:@"School.png"]
                                   highlightedImage:nil
                                   ContentImage:[UIImage imageNamed:@"School.png"]
                                   highlightedContentImage:nil];
    AwesomeMenuItem *relationshipsItem = [[AwesomeMenuItem alloc]
                                          initWithImage:[UIImage imageNamed:@"Relationships.png"]
                                          highlightedImage:nil
                                          ContentImage:[UIImage imageNamed:@"Relationships.png"]
                                          highlightedContentImage:nil];
    AwesomeMenuItem *workItem = [[AwesomeMenuItem alloc]
                                 initWithImage:[UIImage imageNamed:@"Work.png"]
                                 highlightedImage:nil
                                 ContentImage:[UIImage imageNamed:@"Work.png"]
                                 highlightedContentImage:nil];
    AwesomeMenuItem *drinkingItem = [[AwesomeMenuItem alloc]
                                     initWithImage:[UIImage imageNamed:@"Drinking.png"]
                                     highlightedImage:nil
                                     ContentImage:[UIImage imageNamed:@"Drinking.png"]
                                     highlightedContentImage:nil];
    AwesomeMenuItem *randomItem = [[AwesomeMenuItem alloc]
                                   initWithImage:[UIImage imageNamed:@"Random.png"]
                                   highlightedImage:nil
                                   ContentImage:[UIImage imageNamed:@"Random.png"]
                                   highlightedContentImage:nil];
    
    NSArray *menuOptions = [NSArray arrayWithObjects:dirtySexItem, schoolItem, relationshipsItem, workItem, drinkingItem, randomItem, nil];
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.frame menus:menuOptions];
    menu.delegate = self;
    
    
    if (IS_SHORT_IPHONE) {
        // iPhone 4S
        menu.frame = CGRectMake(DEVICE_WIDTH/2 - menu.frame.size.width/2, SHORT_IPHONE_HEIGHT/2 - menu.frame.size.height/2, menu.frame.size.width, menu.frame.size.height);
    } else if (IS_TALL_IPHONE) {
        // iPhone 5
        menu.frame = CGRectMake(DEVICE_WIDTH/2 - menu.frame.size.width/2, TALL_IPHONE_HEIGHT/2 - menu.frame.size.height/2 + 50, menu.frame.size.width, menu.frame.size.height);
    }
    
    [self.view addSubview:menu];
}

-(void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx {
    NSLog(@"User selected index: %d", idx);
    
    switch (idx) {
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
    
    [menu removeFromSuperview];
    
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
