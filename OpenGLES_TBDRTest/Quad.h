//
//  Quad.h
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 27.03.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>


@interface Quad : NSObject

@property (nonatomic, assign) GLKVector2 position;
@property (nonatomic, assign) GLKVector2 scale;

- (GLKMatrix4) modelMatrix;

@end
