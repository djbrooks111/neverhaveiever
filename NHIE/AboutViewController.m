//
//  AboutViewController.m
//  NHIE
//
//  Created by David Brooks on 5/25/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import "AboutViewController.h"

#define IS_SHORT_IPHONE     ([UIScreen mainScreen].bounds.size.height == 480)
#define IS_TALL_IPHONE      ([UIScreen mainScreen].bounds.size.height == 568)
#define SHORT_IPHONE_HEIGHT 480
#define TALL_IPHONE_HEIGHT  568
#define DEVICE_WIDTH        320
#define IS_RETINA_DISPLAY   ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && [UIScreen mainScreen].scale == 2.0)

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Creating background view
    [self createBackgroundView];
    
    navigationBar.topItem.title = @"About";
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)createBackgroundView {
    // Creating needed variables
    UIImage *backgroundImage = [UIImage imageNamed:@"AboutBackground.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    
    if (IS_SHORT_IPHONE) {
        // iPhone 4S - Regular and 2x background
        backgroundImageView.frame = CGRectMake(0, -20, DEVICE_WIDTH, SHORT_IPHONE_HEIGHT + 20);
    } else if (IS_TALL_IPHONE) {
        backgroundImageView.frame = CGRectMake(0, -30, DEVICE_WIDTH, TALL_IPHONE_HEIGHT + 30);
    }
    
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
}

-(IBAction)goBack {
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
