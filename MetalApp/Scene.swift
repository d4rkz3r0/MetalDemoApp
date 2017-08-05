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
    
    var camera = Camera();
    
    //Scene CB
    var sceneConstants = SceneConstants();
    
    init(device: MTLDevice, size: CGSize)
    {
        self.device = device;
        self.size = size;
        super.init();
        
        initCamera();
    }
    
    func initCamera()
    {
        camera.aspectRatio = Float(size.width / size.height);
        camera.worldPosition.y = -0.25;
        camera.worldPosition.z = -7.0;
        addNode(childNode: camera);
    }
    
    func update(deltaTime: Float)
    {
        
    }

    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float)
    {
        update(deltaTime: deltaTime);
        
        sceneConstants.projectionMatrix = camera.projectionMatrix;
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, at: 2);
        
        _ = children.map({ $0.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix); })
    }
}
