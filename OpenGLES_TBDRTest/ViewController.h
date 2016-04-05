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

#import "View.h"

#import "Shaders/BaseShader.h"

typedef struct {
    GLfloat position[3];
} vertex_t;

@interface ViewController : GLKViewController <GLKViewDelegate>

@property (nonatomic, strong) View *view;


@end

