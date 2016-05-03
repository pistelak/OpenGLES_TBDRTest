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

#define GLSL(version, shader)  "#version " #version "\n" #shader

@interface BaseShader : NSObject

// Program Handle
@property (readwrite) GLuint program;

// Attribute Handles
@property (readwrite) GLuint in_position;

// Uniform Handles
@property (readwrite) GLuint u_projectionMatrix;

- (void) loadShader;

@end
