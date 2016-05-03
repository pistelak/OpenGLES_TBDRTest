//
//  ViewController.h
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 05.04.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

#import "OpenGLRenderer.h"
#import "View.h"

typedef NS_ENUM(NSUInteger, ScreenFillingTestType) {
    ScreenFillingTestPoint = 0,
    ScreenFillingTestSquare,
    ScreenFillingTestRectangle
};

@interface ViewController : GLKViewController <GLKViewDelegate>

@property (nonatomic, assign) ScreenFillingTestType type;

@end

