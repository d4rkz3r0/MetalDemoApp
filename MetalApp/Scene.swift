//
//  Scene.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class Scene: Node
{
    var device: MTLDevice;
    var size: CGSize;
    
    init(device: MTLDevice, size: CGSize)
    {
        self.device = device;
        self.size = size;
        
        super.init();
    }
    
    func update(deltaTime: Float)
    {
        
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float)
    {
        update(deltaTime: deltaTime);
        
        //Camera View Matrix
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -4);
        
        _ = children.map({ $0.render(commandEncoder: commandEncoder, parentModelViewMatrix: viewMatrix); })
    }
}
