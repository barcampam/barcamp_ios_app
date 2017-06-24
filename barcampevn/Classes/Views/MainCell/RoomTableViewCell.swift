//
//  RoomTableViewCell.swift
//  barcampevn
//

import UIKit
import PureLayout

class RoomTableViewCell: UITableViewCell {
    
    //MARK: - Create UIElements -
    var cellContentView = RoomTableViewCellContentView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Color.blue
        contentView.addSubview(cellContentView)
        cellContentView.autoPinEdgesToSuperviewEdges()
    }
    
    func configure(_ room: String) {
        cellContentView.roomLabel.text = room
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - RoomTableViewCellContentView
class RoomTableViewCellContentView: UIView {
    
    //MARK: - Initialize -
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        
        backgroundColor = Color.blue
        addAllUIElements()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privat Methods -
    private func addAllUIElements() {
        addSubview(roomLabel)
        
        setConstraints()
    }
    
    //MARK: - Constraints -
    func setConstraints() {
        roomLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        roomLabel.autoAlignAxis(.horizontal, toSameAxisOf: self, withOffset: -8)
    }
    
    //MARK: - Create UIElements -
    lazy var roomLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = UIColor.white
        view.textAlignment = .center
        view.numberOfLines = 1
        
        return view
    }()
}
