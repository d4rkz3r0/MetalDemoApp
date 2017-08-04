//
//  Texturable.swift
//  MetalBreakout
//
//  Created by Steve Kerney on 8/4/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import MetalKit

protocol Texturable
{
    var diffuseTexture: MTLTexture? { get set }
    
}

extension Texturable
{
    func setTexture(device: MTLDevice, imageName: String) -> MTLTexture?
    {
        let textureLoader = MTKTextureLoader(device: device);
        var diffuseTexture: MTLTexture? = nil;
        
        let textureLoaderOptions: [String : NSObject];
        let imageOrigin = NSString(string: MTKTextureLoaderOriginBottomLeft);
        textureLoaderOptions = [MTKTextureLoaderOptionOrigin: imageOrigin];
        
        guard let textureURL = Bundle.main.url(forResource: imageName, withExtension: nil) else { print("Image Name Invalid."); return nil; }
        
        do
        {
            diffuseTexture = try textureLoader.newTexture(withContentsOf: textureURL, options: textureLoaderOptions);
        } catch { print("Unable to create texture from imageName."); }
        
        
        return diffuseTexture;
    }
}
