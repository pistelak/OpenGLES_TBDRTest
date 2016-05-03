//
//  TestQuad.m
//  OpenGLES_TBDRTest
//
//  Created by Radek Pistelak on 5/3/16.
//  Copyright © 2016 ran. All rights reserved.
//

#import "TestQuad.h"

#import <vector>

@implementation TestQuad
{
    GLuint _vao;
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
    std::vector<vertex_t> _vertices;
    std::vector<GLuint> _indices;
    
    CGSize _sizeOfScreen;
    CGSize _sizeOfQuads;
    
    BaseShader *_shader;
}

- (instancetype) initWithSizeOfScreen:(CGSize) sizeOfScreen sizeOfQuads:(CGSize) sizeOfQuads andShader:(BaseShader *) shader
{
    self = [super init];
    if (self) {
        _sizeOfScreen = sizeOfScreen;
        _sizeOfQuads = sizeOfQuads;
        _shader = shader;
        
        [self setupOpenGL];
    }
    
    return self;
}

- (void) setupOpenGL
{
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    
    _vertices = [self vertices];
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, _vertices.size() * sizeof(vertex_t), &_vertices[0], GL_STATIC_DRAW);
    
    _indices = [self indices];
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, _indices.size() * sizeof(GLuint), &_indices[0], GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(_shader.in_position);
    glVertexAttribPointer(_shader.in_position, 3, GL_FLOAT, GL_FALSE, sizeof(vertex_t), NULL);
    
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (void) draw
{
    glBindVertexArray(_vao);

    glDrawElements(GL_TRIANGLE_STRIP, (int) _indices.size(), GL_UNSIGNED_INT, 0);
    
    glBindVertexArray(0);
}

#pragma mark -
#pragma mark Vertices

- (std::vector<vertex_t>) vertices
{
    std::vector<vertex_t> vertices;
    
    const CGSize drawableSize = _sizeOfScreen;
    const CGSize particleSize = _sizeOfQuads;
    
    const NSUInteger numberOfLines = drawableSize.height / particleSize.height;
    const NSUInteger particlesPerLine = drawableSize.width / particleSize.width;
    
    for (NSUInteger i = 0; i < numberOfLines; ++i) {
        for (NSUInteger j = 0; j < particlesPerLine; ++j) {
            
            vertex_t a = {
                static_cast<GLfloat>(j * particleSize.width),
                static_cast<GLfloat>(i * particleSize.height),
                0.f
            };
            
            vertex_t b = {
                static_cast<GLfloat>(j * particleSize.width),
                static_cast<GLfloat>(i * particleSize.height + particleSize.height),
                0.f
            };
            
            vertex_t c = {
                static_cast<GLfloat>(j * particleSize.width + particleSize.width),
                static_cast<GLfloat>(i * particleSize.height),
                0.f
            };
            
            vertex_t d = {
                static_cast<GLfloat>(j * particleSize.width + particleSize.width),
                static_cast<GLfloat>(i * particleSize.height + particleSize.height),
                0.f
            };
            
            vertices.push_back(a);
            vertices.push_back(b);
            vertices.push_back(c);
            vertices.push_back(d);
        }
    }
    
    return vertices;
}

#pragma mark -
#pragma mark Indices

- (std::vector<GLuint>) indices
{
    std::vector<GLuint> indices;
    
    NSUInteger numberOfVertices = _vertices.size();
    
    for (GLuint i = 0; i < numberOfVertices; ++i) {
        indices.push_back(i);
        
        if (((i+1) % 4) == 0) {
            indices.push_back(UINT32_MAX);
        }
    }
    
    return indices;
}


@end
