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
    var cube: Cube;
    
    override init(device: MTLDevice, size: CGSize)
    {
        cube = Cube(device: device);
        quad = Plane(device: device, imageName: "ebayWallpaper.jpg");

        super.init(device: device, size: size);
        addNode(childNode: cube);
        addNode(childNode: quad);
        
        quad.worldPosition.z = -3.0;
        quad.worldScale = float3(3.0);
        
        camera.worldPosition.x = 1.0;
        camera.worldPosition.y = -1.0;
        camera.worldPosition.z = -6.0;
        camera.worldRotation.x = radians(fromDegrees: -45.0);
        camera.worldRotation.y = radians(fromDegrees: -45.0);
    }
    
    override func update(deltaTime: Float)
    {
        cube.worldRotation.y += deltaTime;
    }
}
