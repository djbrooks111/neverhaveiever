//
//  QuestionViewController.m
//  NHIE
//
//  Created by David Brooks on 5/15/13.
//  Copyright (c) 2013 David J Brooks. All rights reserved.
//

#import "QuestionViewController.h"

#define IS_SHORT_IPHONE     ([UIScreen mainScreen].bounds.size.height == 480)
#define IS_TALL_IPHONE      ([UIScreen mainScreen].bounds.size.height == 568)
#define SHORT_IPHONE_HEIGHT 480
#define TALL_IPHONE_HEIGHT  568
#define DEVICE_WIDTH        320
#define IS_RETINA_DISPLAY   ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && [UIScreen mainScreen].scale == 2.0)


@interface QuestionViewController ()

@end

@implementation QuestionViewController

@synthesize questionArray;

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
    NSLog(@"viewDidLoad entered");
    
    // Creating background view
    [self createBackgroundView];
    
    navigationBar.topItem.title = categoryString;
    
    questionArray = [[NSMutableArray alloc] init];
    indexTracker = -1;
}

-(void)createBackgroundView {
    // Creating needed variables
    UIImage *backgroundImage = [UIImage imageNamed:@"QuestionBackground.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [nextButton setImage:[UIImage imageNamed:@"QuestionButton.png"] forState:UIControlStateNormal];
    
    if (IS_SHORT_IPHONE) {
        // iPhone 4S - Regular and 2x backgrounds
        backgroundImageView.frame = CGRectMake(0, navigationBar.frame.size.height, DEVICE_WIDTH, SHORT_IPHONE_HEIGHT - navigationBar.frame.size.height);
        nextButton.frame = CGRectMake(20, 325, nextButton.frame.size.width, nextButton.frame.size.height);
        questionLabel.frame = CGRectMake(70, 150, questionLabel.frame.size.width, questionLabel.frame.size.height);
    } else if (IS_TALL_IPHONE) {
        backgroundImageView.frame = CGRectMake(0, navigationBar.frame.size.height, DEVICE_WIDTH, TALL_IPHONE_HEIGHT - navigationBar.frame.size.height);
        nextButton.frame = CGRectMake(20, 390, nextButton.frame.size.width, nextButton.frame.size.height);
        questionLabel.frame = CGRectMake(70, 185, questionLabel.frame.size.width, questionLabel.frame.size.height);
    }
    
    [self.view addSubview:backgroundImageView];
    [self.view sendSubviewToBack:backgroundImageView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Creating navigation bar
    navigationBar.topItem.title = categoryString;
    
    
    questionLabel.text = @"";
    [questionArray removeAllObjects];
    indexTracker = -1;
    
    // Getting questions
    [self showProgressView];
}

-(IBAction)goBack {
    [self leaveView];
}

-(void)leaveView {
    questionLabel.text = @"";
    navigationBar.topItem.title = @"";
    [questionArray removeAllObjects];
    [self resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


// Getting questions
-(void)showProgressView {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"Loading Questions...";
    hud.dimBackground = YES;
    sleep(1);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // DO STUFF
        [self getQuestions];
        sleep(1);
        [self shuffleQuestions];
        sleep(1);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

-(void)getQuestions {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:urlString ofType:@"txt"];
    NSString *myFile = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    NSArray *phrases = [myFile componentsSeparatedByString:@"\n"];
    [questionArray addObjectsFromArray:phrases];
    NSLog(@"New Count: %d", [questionArray count]);
}

-(void)shuffleQuestions {
    for (int i = 0; i < [questionArray count]; i++) {
        NSString *neededString = [questionArray objectAtIndex:i];
        neededString = [neededString stringByReplacingOccurrencesOfString:@"=" withString:@"\n"];
        [questionArray removeObjectAtIndex:i];
        [questionArray insertObject:neededString atIndex:i];
    }
    
    NSUInteger firstObject = 0;
    for (int x = 0; x < [questionArray count]; x++) {
        NSUInteger randomIndex = arc4random() % [questionArray count];
        [questionArray exchangeObjectAtIndex:firstObject withObjectAtIndex:randomIndex];
        firstObject += 1;
    }
    NSLog(@"Shuffles array:\n\n%@", questionArray);
}

-(void)displayQuestion {
    indexTracker++;
    
    if (indexTracker == [questionArray count]) {
        [self shuffleQuestions];
        indexTracker = 0;
    }
    questionLabel.text = [questionArray objectAtIndex:indexTracker];
}

-(IBAction)nextQuestion {
    [self displayQuestion];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
        [self displayQuestion];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end