//
//  OpenGLRenderer.h
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 5/3/16.
//  Copyright © 2016 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>

#import "Shaders/BaseShader.h"
#import "ViewController.h"

typedef struct {
    GLfloat position[3];
} vertex_t;

@interface OpenGLRenderer : NSObject <GLKViewDelegate, GLKViewControllerDelegate>

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithTestType:(NSUInteger) type; // parameter has type ScreenFillingTestType

@end
