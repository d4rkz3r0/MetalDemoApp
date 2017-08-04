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
    var quad: Plane;
    
    override init(device: MTLDevice, size: CGSize)
    {
        quad = Plane(device: device, imageName: "ebayWallpaper.jpg");

        let quad2 = Plane(device: device, imageName: "ebayWallpaper.jpg");
        quad2.worldScale = float3(0.5);
        quad2.worldPosition.y = 1.5;

        
        
        super.init(device: device, size: size);
        addNode(childNode: quad);
        quad.addNode(childNode: quad2);
    }
    
    override func update(deltaTime: Float)
    {
        quad.worldRotation.y += deltaTime;
    }
}
