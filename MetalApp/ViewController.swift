//
//  ViewController.swift
//  MetalApp
//
//  Created by Steve Kerney on 8/2/17.
//  Copyright © 2017 d4rkz3r0. All rights reserved.
//

import UIKit
import MetalKit


enum ClearColors
{
    static let green = MTLClearColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0);
    static let black = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0);
    static let yellow = MTLClearColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0);
    static let red = MTLClearColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0);
    
}
class ViewController: UIViewController
{

    var renderer: Renderer?;
    
    var metalView: MTKView
    {
        return view as! MTKView;
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad();
        
        initMetal();
    }

    func initMetal()
    {
        metalView.clearColor = ClearColors.red;
        metalView.depthStencilPixelFormat = .depth32Float
        
        //Get Reference to Device
        metalView.device = MTLCreateSystemDefaultDevice();
        guard let vDevice = metalView.device else { fatalError("Device not created, please run on a physical device."); }
        
        //Init Renderer
        renderer = Renderer(device: vDevice);
        
        //Set Scene
        renderer?.scene = LightingScene(device: vDevice, size: view.bounds.size);
        metalView.delegate = renderer;
    }
    
    //MARK: Touch delegates.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        renderer?.scene?.touchesBegan(view, touches: touches, with: event);
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        renderer?.scene?.touchesMoved(view, touches: touches, with: event);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        renderer?.scene?.touchesEnded(view, touches: touches, with: event);
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        renderer?.scene?.touchesCancelled(view, touches: touches, with: event);
    }
}
