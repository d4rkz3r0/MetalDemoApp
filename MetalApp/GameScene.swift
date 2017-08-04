//
//  GameScene.swift
//  MetalBreakout
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
        //quad = Plane(device: device);
        super.init(device: device, size: size);
        addNode(childNode: quad);
    }
}
