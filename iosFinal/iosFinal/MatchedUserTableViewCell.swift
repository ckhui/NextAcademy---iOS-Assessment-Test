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
    @IBOutlet weak var unmatchButton: UIButton! {
        didSet{
            unmatchButton.addTarget(self, action: #selector(unmatchButtonPressed) , for: .touchUpInside)
        }
    }
    @IBOutlet weak var displayImageView: UIImageView!
    var delegate : MatchedUserTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func unmatchButtonPressed(){
        delegate?.didTapUnmatch(atCell: self)
    }
    
}

protocol MatchedUserTableViewCellDelegate {
    func didTapUnmatch(atCell cell: MatchedUserTableViewCell)
}
