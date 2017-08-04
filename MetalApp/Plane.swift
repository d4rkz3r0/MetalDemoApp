//
//  Plane.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Plane: Primitive
{
    
    override func buildVertices()
    {
        vertices =
            [
                VertexPosColUV(position: float3(-1, 1, 0),  color: float4(1, 0, 0, 1), uv: float2(0, 1)),
                VertexPosColUV(position: float3(-1, -1, 0), color: float4(0, 1, 0, 1), uv: float2(0, 0)),
                VertexPosColUV(position: float3(1, -1, 0),  color: float4(0, 0, 1, 1), uv: float2(1, 0)),
                VertexPosColUV(position: float3(1,  1, 0),  color: float4(1, 0, 1, 1), uv: float2(1, 1))
            ]
        
        indices =
            [
                0, 1, 2,
                2, 3, 0
            ]
    }
}
