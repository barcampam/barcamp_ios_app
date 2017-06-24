//
//  MainCollectionViewCell.swift
//  barcampevn
//

import UIKit
import PureLayout

class MainCollectionViewCell: UICollectionViewCell {
    
    var insetLineConstraint : NSLayoutConstraint?
    
    //MARK: - Create UIElements -
    lazy var bgImageView: UIImageView = {
        let view = UIImageView.newAutoLayout()
        view.layer.cornerRadius = 6.0
        
        return view
    }()
    
    lazy var timeLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.font = Font.system_13
        view.numberOfLines = 1
        
        return view
    }()
    
    lazy var speackerLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.textColor = Color.gray_42
        view.font = Font.boldSystem_13
        view.numberOfLines = 1
        
        return view
    }()
    
    lazy var topicLabel: UILabel = {
        let view = UILabel.newAutoLayout()
        view.textColor = Color.gray_42
        view.font = Font.system_14
        view.numberOfLines = 2

        return view
    }()
    
    lazy var lineView: UIView = {
        let view = UIView.newAutoLayout()
        view.backgroundColor = Color.gray_246
        
        return view
    }()
    
    //MARK: - Initialize -
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addAllUIElements()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods -
    private func addAllUIElements() {
        addSubview(bgImageView)
        bgImageView.addSubview(timeLabel)
        bgImageView.addSubview(speackerLabel)
        bgImageView.addSubview(topicLabel)
        addSubview(lineView)
        
        setConstraints()
    }
    
    private func configWhenPassedTopic(_ schedule: Schedule) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let scheduleDate = dateFormatter.date(from: schedule.time_to.date)
        let currentDate = Date()
        
        let correctColor : UIColor!
        if let scheduleDate = scheduleDate, scheduleDate < currentDate {
            correctColor = Color.gray_142
        } else {
            correctColor = Color.gray_42
        }
        speackerLabel.textColor = correctColor
        topicLabel.textColor = correctColor
    }
    
    private func configWhenEmptyCell(_ schedule: Schedule) {
        if let _ = schedule.time_from.date.shortHour {
            timeLabel.text              = "\(schedule.time_from.date.shortHour!) - \(schedule.time_to.date.shortHour!)"
            speackerLabel.text          = schedule.en.speaker
            topicLabel.text             = schedule.en.topic
        } else {
            bgImageView.backgroundColor = UIColor.white
            timeLabel.text              = ""
            speackerLabel.text          = ""
            topicLabel.text             = ""
        }
    }
    
    //MARK: - Constraints -
     private func setConstraints() {
        let inset: CGFloat = 8
        
        bgImageView.autoPinEdge(toSuperviewEdge: .top)
        bgImageView.autoPinEdge(toSuperviewEdge: .left, withInset: inset)
        bgImageView.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        bgImageView.autoPinEdge(.bottom, to: .top, of: lineView, withOffset: -inset - 4)
        
        timeLabel.autoPinEdge(toSuperviewEdge: .top, withInset: inset)
        timeLabel.autoPinEdge(toSuperviewEdge: .left, withInset: inset)
        timeLabel.autoSetDimension(.width, toSize: 90)
        
        speackerLabel.autoAlignAxis(.horizontal, toSameAxisOf: timeLabel)
        speackerLabel.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        speackerLabel.autoPinEdge(.left, to: .right, of: timeLabel, withOffset: 0)
        
        topicLabel.autoPinEdge(.top, to: .bottom, of: timeLabel, withOffset: inset/2)
        topicLabel.autoPinEdge(toSuperviewEdge: .left, withInset: inset)
        topicLabel.autoPinEdge(toSuperviewEdge: .right, withInset: inset)
        
        lineView.autoPinEdge(toSuperviewEdge: .bottom)
        insetLineConstraint = lineView.autoPinEdge(toSuperviewEdge: .left)
        lineView.autoPinEdge(toSuperviewEdge: .right)
        lineView.autoSetDimension(.height, toSize: 1)
    }
    
    //MARK: - Public Methods -
    func setHeaderValues(schedule: Schedule) {
        backgroundColor                 = UIColor.white
        bgImageView.backgroundColor     = UIColor.white
        timeLabel.textColor             = UIColor.black
        timeLabel.font                  = Font.boldSystem_14
        timeLabel.text                  = schedule.timeForShowInHeader
        speackerLabel.text              = ""
        topicLabel.text                 = ""
    }
    
    func setRowValues(schedule: Schedule) {
        bgImageView.backgroundColor     = Color.gray_246
        timeLabel.textColor             = Color.gray_142
        timeLabel.font                  = Font.system_13
        
        configWhenPassedTopic(schedule)
        configWhenEmptyCell(schedule)
    }
}
