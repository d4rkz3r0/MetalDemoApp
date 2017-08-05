//
//  Camera.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/4/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Camera: Node
{
    var FoV: Float = 65.0;
    var FoVRadians: Float { return radians(fromDegrees: FoV); }
    var aspectRatio: Float  = 1.0;
    var nearZDist: Float = 0.1;
    var farZDist: Float = 100.0;
    
    var projectionMatrix: matrix_float4x4 { return matrix_float4x4(projectionFov: FoVRadians, aspect: aspectRatio, nearZ: nearZDist, farZ: farZDist); }
    
    var viewMatrix: matrix_float4x4
    {
        return modelMatrix;
    }
}
