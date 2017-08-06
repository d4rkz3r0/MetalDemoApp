//
//  VertexTypes.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import simd

struct VertexPosColUV
{
    var position: float3;
    var color: float4;
    var uv: float2;
}

struct ModelConstants
{
    var modelViewMX = matrix_identity_float4x4;
    var materialColor = float4(1.0);
}

struct SceneConstants
{
    var projectionMatrix = matrix_identity_float4x4;
}

struct LightInfo
{
    var lightColor = float3(1.0);
    var ambientIntensity: Float = 1.0;
}
