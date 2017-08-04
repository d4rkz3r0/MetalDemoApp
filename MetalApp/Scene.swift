//
//  Scene.swift
//  MetalBreakout
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
}
