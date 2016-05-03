//
//  TestPoint.h
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 5/3/16.
//  Copyright © 2016 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpenGLRenderer.h"

@interface TestPoint : NSObject

- (instancetype) initWithSizeOfScreen:(CGSize) sizeOfScreen andShader:(BaseShader *) shader;

- (void) draw;

@end
