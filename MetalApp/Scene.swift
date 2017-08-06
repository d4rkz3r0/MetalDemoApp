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
    //Metal
    var device: MTLDevice;
    
    //View
    var size: CGSize;
    
    //Base Scene Required Objects
    var camera = Camera();
    var lightingInfo = LightInfo();
    
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

        addNode(childNode: camera);
    }
    
    func sceneSizeWillChange(to size: CGSize)
    {
        camera.aspectRatio = Float(size.width / size.height);
    }
    
    func update(deltaTime: Float)
    {
        
    }

    func render(commandEncoder: MTLRenderCommandEncoder, deltaTime: Float)
    {
        update(deltaTime: deltaTime);
        
        // Update Scene Constant Buffers
        //Proj MX
        sceneConstants.projectionMatrix = camera.projectionMatrix;
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, at: 2);
        
        //Lighting Info
        commandEncoder.setFragmentBytes(&lightingInfo, length: MemoryLayout<LightInfo>.stride, at: 3);
        
        
        // Render Scene's Nodes.
        _ = children.map({ $0.render(commandEncoder: commandEncoder, parentModelViewMatrix: camera.viewMatrix); })
    }
    
    //MARK: Touch Interaction
    func touchesBegan(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) { }
    func touchesMoved(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) { }
    func touchesEnded(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) { }
    func touchesCancelled(_ view: UIView, touches: Set<UITouch>, with event: UIEvent?) { }
}
