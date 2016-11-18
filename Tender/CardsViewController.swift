//
//  CardsViewController.swift
//  Tender
//
//  Created by Bill Luoma on 11/9/16.
//  Copyright © 2016 Bill Luoma. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: DraggableImageView!
    var centerPoint: CGPoint = CGPoint(x: 0, y:0)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dlog("in")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func proflleImageDidPan(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.view)
        //let velocity = sender.velocity(in: self.view)

        
        
        if sender.state == .began {
            centerPoint = profileImageView.center
            dlog("began")
            dlog("center: \(centerPoint)")

        }
        else if sender.state == .changed {
            dlog("sender.translation.x: \(translation)")

            
            profileImageView.center.x = centerPoint.x + translation.x
        }
        else if sender.state == .ended {
            
        }
        
    }

}

