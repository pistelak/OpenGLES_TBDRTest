//
//  TestPoint.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 5/3/16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "TestPoint.h"

#import <vector>

@implementation TestPoint
{
    GLuint _vao;
    GLuint _vertexBuffer;
    
    std::vector<vertex_t> _vertices;
    
    CGSize _screenSize;
    
    BaseShader *_shader;
}

- (instancetype) initWithSizeOfScreen:(CGSize) sizeOfScreen andShader:(BaseShader *) shader
{
    self = [super init];
    if (self) {
        _screenSize = sizeOfScreen;
        _shader = shader;
        
        [self setupOpenGL];
    }
    
    return self;
}

- (void) setupOpenGL
{
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    
    _vertices = [self points];
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _vertices.size() * sizeof(vertex_t), &_vertices[0], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(_shader.in_position);
    glVertexAttribPointer(_shader.in_position, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), NULL);
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (void) draw
{
    glBindVertexArray(_vao);
    
    glDrawArrays(GL_POINTS, 0, (int) _vertices.size());
    
    glBindVertexArray(0);
}

#pragma mark -
#pragma mark Vertices 

- (std::vector<vertex_t>) points
{
    std::vector<vertex_t> vertices;
    
    for (NSUInteger i = 0; i < _screenSize.height; ++i) {
        for (NSUInteger j = 0; j < _screenSize.width; ++j) {
            
            vertex_t newVertex = {
                static_cast<GLfloat>(j),
                static_cast<GLfloat>(i),
                0.f
            };
            
            vertices.push_back(newVertex);
        }
    }
    
    return vertices;
}

@end
