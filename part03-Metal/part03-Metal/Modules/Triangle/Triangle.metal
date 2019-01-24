//
//  Triangle.metal
//  part03-Metal
//
//  Created by 詹保成 on 2019/1/24.
//  Copyright © 2019 残无殇. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

#import "TriangleHeaders.h"

typedef struct
{
    float4 position [[position]];
    float4 color;
} RasterizerData;

vertex RasterizerData vertexShader(constant TriangleVertex *vertices [[buffer(0)]],
                                   uint vid [[vertex_id]]) {
    RasterizerData outVertex;

    outVertex.position = vector_float4(vertices[vid].position, 0.0, 1.0);
    outVertex.color = vertices[vid].color;

    return outVertex;
}

fragment float4 fragmentShader(RasterizerData inVertex [[stage_in]]) {
    return inVertex.color;
}


