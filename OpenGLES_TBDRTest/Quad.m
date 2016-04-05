//
//  Quad.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 27.03.16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "Quad.h"

@implementation Quad
{
    GLKMatrix4 _modelMatrix;
}

- (GLKMatrix4)modelMatrix
{
    return _modelMatrix;
}

- (void) setPosition:(GLKVector2)position
{
    _position = position;
    
    _modelMatrix = GLKMatrix4Identity;
    _modelMatrix = GLKMatrix4Translate(_modelMatrix, self.position.x, self.position.y, 0);
    _modelMatrix = GLKMatrix4Scale(_modelMatrix, self.scale.x, self.scale.y, 0);
}

- (void) setScale:(GLKVector2)scale
{
    _scale = scale;
    
    _modelMatrix = GLKMatrix4Identity;
    _modelMatrix = GLKMatrix4Translate(_modelMatrix, self.position.x, self.position.y, 0);
    _modelMatrix = GLKMatrix4Scale(_modelMatrix, self.scale.x, self.scale.y, 0);
}


@end
