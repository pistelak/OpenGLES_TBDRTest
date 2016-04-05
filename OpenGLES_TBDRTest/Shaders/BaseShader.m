//
//  BaseShader.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 27.03.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "BaseShader.h"

// Shaders
#define STRINGIFY(A) #A
#include "SimpleVS.vsh"
#include "SimpleFS.fsh"

@implementation BaseShader

- (void)loadShader
{
    // Program
    ShaderProcessor* shaderProcessor = [[ShaderProcessor alloc] init];
    self.program = [shaderProcessor BuildProgram:SimpleVS with:SimpleFS];
    
    // Attributes
    
    // Uniforms
    self.u_modelMatrix = glGetUniformLocation(self.program, "u_modelMatrix");
    self.u_projectionMatrix = glGetUniformLocation(self.program, "u_projectionMatrix");
}

@end
