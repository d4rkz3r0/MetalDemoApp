//
//  GameScene.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

class GameScene: Scene
{
    //Models
    let xWing: Model;
    
    override init(device: MTLDevice, size: CGSize)
    {
        xWing = Model(device: device, modelName: "xWing");
        xWing.worldScale = float3(0.0025);
        
        
        super.init(device: device, size: size);
        
        
        addNode(childNode: xWing);
        camera.worldPosition.z = -6.0;
    }
    
    override func update(deltaTime: Float)
    {
        xWing.worldRotation.y += deltaTime;
    }
}
