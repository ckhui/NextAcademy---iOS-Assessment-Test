//
//  MatchedUserTableViewCell.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit

class MatchedUserTableViewCell: UITableViewCell {

    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var displayImageView: UIImageView!
    var delegate : MatchedUserTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began {
            gestureRecognizer.setTranslation(CGPoint.zero, in: self)
        }
        else if gestureRecognizer.state == .ended {
             let translation = gestureRecognizer.translation(in: self)
            //print(translation)
            
            if translation.x < -150 {
                delegate?.didSwipeLeft(cell: self)
            }
        }
    }
}

protocol  MatchedUserTableViewCellDelegate {
    func didSwipeLeft(cell : MatchedUserTableViewCell)
}

