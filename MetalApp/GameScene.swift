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
    let iPhone: Model;
    
    override init(device: MTLDevice, size: CGSize)
    {
        iPhone = Model(device: device, modelName: "iPhone");
        iPhone.worldScale = float3(0.1);
        
        super.init(device: device, size: size);
        
        addNode(childNode: iPhone);
    }
    
    override func update(deltaTime: Float)
    {
        iPhone.worldRotation.y += deltaTime;
    }
}
