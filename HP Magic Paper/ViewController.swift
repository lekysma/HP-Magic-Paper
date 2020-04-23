//
//  ViewController.swift
//  HP Magic Paper
//
//  Created by Jean martin Kyssama on 17/04/2020.
//  Copyright © 2020 Jean martin Kyssama. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        //on cree une image que notre application va reconnaitre
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Harry Potter images", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            //nombre d'images suivies ici une seule
            configuration.maximumNumberOfTrackedImages = 1
            //test :
            print("we managed to track the image")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    //MARK: - Tranformer notre image en plan / rectangle
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // node
        let node = SCNNode()
        
        //
        if let imageAnchor = anchor as? ARImageAnchor {
            // PS: Image anchor est l'image que nous reconnaissons
            
            //MARK: - Ici on va coder ce qui va concerner la video
            // un video node
            let videoNode = SKVideoNode(fileNamed: "harry-potter.mp4")
            //on joue la video
            videoNode.play()
            // on cree un video scene en 360p
            let videoScene = SKScene(size: CGSize(width: 480, height: 360))
            
            // on recalibre la position de la video via le node pour centrer le tout
            videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
            //enfin on ajoute ce bout de code pour que la video soit a l'endroit
            videoNode.yScale = -1.0
            // On connecte le scene et le node
            videoScene.addChild(videoNode)
            
            
            
            //MARK:-  on cree un plan pour afficher la figure 3d
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            // on cree un plane material
            let planeMaterial = SCNMaterial()
            //on remplace le contenu du material par la scene video
            planeMaterial.diffuse.contents = videoScene
            // on ajoute le material a notre plane
            plane.materials = [planeMaterial]
            
            // on va creer une image qui va couvrir notre plan, permet de bien visualiser
            let planeNode = SCNNode(geometry: plane)
            //orientation
            planeNode.eulerAngles.x = -Float.pi / 2
            // on attache au node parent
            node.addChildNode(planeNode)
            
            
        }
        
        return node
    }
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
