//
//  VertexTypes.swift
//  MetalBreakout
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import simd

struct VertexPos
{
    var position: float3;
}

struct VertexPosColUV
{
    var position: float3;
    var color: float4;
    var uv: float2;
}

struct ModelConstants
{
    var modelViewMX = matrix_identity_float4x4;
}
