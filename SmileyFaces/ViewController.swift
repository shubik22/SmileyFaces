//
//  ViewController.swift
//  SmileyFaces
//
//  Created by Sam Sweeney on 10/7/15.
//  Copyright © 2015 Wealthfront. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var trayView: UIView!
    @IBOutlet weak var smileyFaceImageView: UIImageView!
    @IBOutlet weak var excitedFaceImageView: UIImageView!
    @IBOutlet weak var sadFaceImageView: UIImageView!
    @IBOutlet weak var tongueFaceImageView: UIImageView!
    @IBOutlet weak var winkFaceImageView: UIImageView!
    @IBOutlet weak var deadFaceImageView: UIImageView!
    
    var trayOriginalCenter: CGPoint!
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBAction func dragSmileyPanGesture(sender: UIPanGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        if sender.state == UIGestureRecognizerState.Began {
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == UIGestureRecognizerState.Changed {
            var translation = sender.translationInView(newlyCreatedFace)
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
    }

    @IBAction func onTrayPanGesture(sender: UIPanGestureRecognizer) {
        let point = panGestureRecognizer.locationInView(view)
        let velocity = panGestureRecognizer.velocityInView(trayView)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            print("Began: \(velocity.y)")
            trayOriginalCenter = point
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            print("Changed: \(velocity.y)")
            var translation = panGestureRecognizer.translationInView(trayView)
            trayView.center = CGPoint(x: trayView.frame.width/2.0, y: trayOriginalCenter.y + translation.y)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if velocity.y < 0 {
                animateTrayToOpen()
            } else {
                animateTrayToClosed()
            }
            print("Ended: \(velocity.y)")
        }
    }
    
    func animateTrayToOpen() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.trayView.center = self.trayCenterWhenOpen
            }, completion: nil)
    }
    
    func animateTrayToClosed() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.trayView.center = self.trayCenterWhenClosed
            }, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "toggleTrayView")
        trayView.addGestureRecognizer(tapGestureRecognizer)
        
        trayCenterWhenOpen = CGPoint(x: view.frame.width/2.0, y: view.frame.height - trayView.frame.height/2.0)
        trayCenterWhenClosed = CGPoint(x: view.frame.width/2.0, y: view.frame.height + trayView.center.y/6.0)
        trayView.center = trayCenterWhenClosed
    }
    
    func toggleTrayView() {
        if trayView.center == trayCenterWhenOpen {
            animateTrayToClosed()
        } else {
            animateTrayToOpen()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

