//
//  TestQuad.h
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 5/3/16.
//  Copyright © 2016 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLRenderer.h"

@interface TestQuad : NSObject

- (instancetype) initWithSizeOfScreen:(CGSize) sizeOfScreen sizeOfQuads:(CGSize) sizeOfQuads andShader:(BaseShader *) shader;

- (void) draw;

@end
