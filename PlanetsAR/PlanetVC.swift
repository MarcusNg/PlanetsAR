//
//  PlanetVC.swift
//  PlanetsAR
//
//  Created by Marcus Ng on 12/8/17.
//  Copyright © 2017 Marcus Ng. All rights reserved.
//

import UIKit
import ARKit

class PlanetVC: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
    }

    override func viewDidAppear(_ animated: Bool) {
        // Sun
        let sun = SCNNode(geometry: SCNSphere(radius: 0.35))
        
        // Parents (Invisible nodes) - change rotation time of planets around sun
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        let moonParent = SCNNode()
        
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Sun")
        sun.position = SCNVector3(0,0,-1)
        earthParent.position = SCNVector3(0,0,-1)
        venusParent.position = SCNVector3(0,0,-1)
        moonParent.position = SCNVector3(1.2,0,-0)
        
        self.sceneView.scene.rootNode.addChildNode(sun)
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        self.sceneView.scene.rootNode.addChildNode(moonParent)
        
        // Earth, Venus, Moon
        let earth = planet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "EarthDay"), specular: #imageLiteral(resourceName: "EarthSpecular"), emission: #imageLiteral(resourceName: "EarthClouds"), normal: #imageLiteral(resourceName: "EarthNormal"), position: SCNVector3(1.2,0,0))
        let venus = planet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "VenusSurface"), specular: nil, emission: #imageLiteral(resourceName: "VenusAtmosphere"), normal: nil, position: SCNVector3(0.7,0,0))
        let moon = planet(geometry: SCNSphere(radius: 0.05), diffuse: #imageLiteral(resourceName: "MoonDiffuse"), specular: nil, emission: nil, normal: nil, position: SCNVector3(0,0,-0.3))
        
        // Rotate sun
        let sunAction = rotation(time: 8)
        
        // Rotate planets and moons
        let earthParentRotation = rotation(time: 14)
        let venusParentRotation = rotation(time: 10)
        let earthRotation = rotation(time: 8)
        let moonRotation = rotation(time: 5)
        let venusRotation = rotation(time: 10)
        
        // Forever Actions
        sun.runAction(sunAction)
        earthParent.runAction(earthParentRotation)
        venusParent.runAction(venusParentRotation)
        earth.runAction(earthRotation)
        moonParent.runAction(moonRotation)
        venus.runAction(venusRotation)
        
        // Add nodes to scene
        earthParent.addChildNode(earth)
        earthParent.addChildNode(moonParent)
        venusParent.addChildNode(venus)
        earth.addChildNode(moon)
        moonParent.addChildNode(moon)

    }

    func planet(geometry: SCNGeometry, diffuse: UIImage, specular: UIImage?, emission: UIImage?, normal: UIImage?, position: SCNVector3) -> SCNNode {
        let planet = SCNNode(geometry: geometry)
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        planet.position = position
        return planet
    }
    
    func rotation(time: TimeInterval) -> SCNAction{
        let rotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: time)
        let foreverRotation = SCNAction.repeatForever(rotation)
        return foreverRotation
    }

}

extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
    
}

