//
//  ViewController.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 05.04.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *recognizer;

@end

@implementation ViewController
{
    OpenGLRenderer *_renderer;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    _type = ScreenFillingTestPoint;
    
    self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    [self.recognizer setNumberOfTapsRequired:3];
    [self.view addGestureRecognizer:self.recognizer];
    
    self.preferredFramesPerSecond = 60;
    
    _renderer = [[OpenGLRenderer alloc] initWithTestType:_type];
    
    View *view = (View *) self.view;
    self.delegate = _renderer;
    view.delegate = _renderer;
}

- (void) viewTapped
{
    _type = (_type + 1) % (ScreenFillingTestRectangle + 1);
    
    NSLog(@"Test type will be changed to %@", [self stringWithTestType:_type]);
}

- (NSString *) stringWithTestType:(ScreenFillingTestType) testType
{
    NSDictionary<NSNumber *, NSString *> *mappingDictionary = @{
        @(ScreenFillingTestPoint)      :   @"ScreenFillingTestPoint",
        @(ScreenFillingTestSquare)     :   @"ScreenFillingTestSquare",
        @(ScreenFillingTestRectangle)  :   @"ScreenFillingTestRectangle"
    };
    
    return mappingDictionary[@(testType)];
}

@end

