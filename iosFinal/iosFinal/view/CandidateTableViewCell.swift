//
//  CandidateTableViewCell.swift
//  iosFinal
//
//  Created by NEXTAcademy on 12/21/16.
//  Copyright © 2016 ckhui. All rights reserved.
//

import UIKit

class CandidateTableViewCell: UITableViewCell {


    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var matchButton: UIButton! {
        didSet{
            matchButton.addTarget(self, action: #selector(matchButtonPressed) , for: .touchUpInside)
        }
    }
    @IBOutlet weak var displayImageView: UIImageView!
    var delegate : CandidateTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func matchButtonPressed(){
        delegate?.didTapMatch(atCell: self)
    }

}

protocol CandidateTableViewCellDelegate {
    func didTapMatch(atCell cell: CandidateTableViewCell)
}
