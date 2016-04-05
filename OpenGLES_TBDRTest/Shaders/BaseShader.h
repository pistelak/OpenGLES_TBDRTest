//
//  BaseShader.h
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 27.03.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>
#import "ShaderProcessor.h"

#define STRINGIFY(A) #A

@interface BaseShader : NSObject

// Program Handle
@property (readwrite) GLuint program;

// Attribute Handles
@property (readwrite) GLuint in_position;

// Uniform Handles
@property (readwrite) GLuint u_modelMatrix;
@property (readwrite) GLuint u_projectionMatrix;

- (void)loadShader;

@end
