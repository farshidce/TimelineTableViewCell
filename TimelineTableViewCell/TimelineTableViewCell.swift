//
//  TimelineTableViewCell.swift
//  TimelineTableViewCell
//
//  Created by Zheng-Xiang Ke on 2016/10/20.
//  Copyright © 2016年 Zheng-Xiang Ke. All rights reserved.
//

import UIKit

@objcMembers
@objc public class TimelineTableViewCell: UITableViewCell {

    @IBOutlet weak open var titleLabel: UILabel!
    @IBOutlet weak open var descriptionLabel: UILabel!
    @IBOutlet weak open var lineInfoLabel: UILabel!
    @IBOutlet weak open var bottomImageView: UIImageView!
    @IBOutlet weak open var thumbnailImageView: UIImageView!

    //    public init() {
    //        self.init(diameter: 6.0, lineWidth: 2.0, color: UIColor.black, filled: false)
    //    }

    open var timelinePoint = TimelinePoint(diameter: 6.0,
                                           lineWidth: 2.0,
                                           color: UIColor.black,
                                           filled: false) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    open var timeline = Timeline(width: 2.0,
                                 frontColor: UIColor.black,
                                 backColor: UIColor.black) {
        didSet {
            self.setNeedsDisplay()
        }
    }

    open var bubbleRadius: CGFloat = 2.0 {
        didSet {
            if (bubbleRadius < 0.0) {
                bubbleRadius = 0.0
            } else if (bubbleRadius > 6.0) {
                bubbleRadius = 6.0
            }

            self.setNeedsDisplay()
        }
    }

    open var bubbleColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override open func draw(_ rect: CGRect) {
        for layer in self.contentView.layer.sublayers! {
            if layer is CAShapeLayer {
                layer.removeFromSuperlayer()
            }
        }

        lineInfoLabel.sizeToFit()
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        bottomImageView.sizeToFit()

        timelinePoint.position = CGPoint(x: timeline.leftMargin + timeline.width / 2, y: titleLabel.frame.origin.y + titleLabel.intrinsicContentSize.height / 2 - timelinePoint.diameter / 2)

        timeline.start = CGPoint(x: timelinePoint.position.x + timelinePoint.diameter / 2, y: 0)
        timeline.middle = CGPoint(x: timeline.start.x, y: timelinePoint.position.y)
        timeline.end = CGPoint(x: timeline.start.x, y: self.bounds.size.height)
        timeline.draw(view: self.contentView)

        timelinePoint.draw(view: self.contentView)

        if let title = titleLabel.text, !title.isEmpty {
            drawBubble()
        }
    }

    fileprivate func drawBubble() {
        let offset: CGFloat = 15
        let bubbleRect = CGRect(
            x: titleLabel.frame.origin.x - offset / 2,
            y: titleLabel.frame.origin.y - offset / 2,
            width: titleLabel.intrinsicContentSize.width + offset,
            height: titleLabel.intrinsicContentSize.height + offset)

        let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: bubbleRadius)
        let startPoint = CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 - 8)
        path.move(to: startPoint)
        path.addLine(to: startPoint)
        path.addLine(to: CGPoint(x: bubbleRect.origin.x - 8, y: bubbleRect.origin.y + bubbleRect.height / 2))
        path.addLine(to: CGPoint(x: bubbleRect.origin.x, y: bubbleRect.origin.y + bubbleRect.height / 2 + 8))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = bubbleColor.cgColor
        
        self.contentView.layer.insertSublayer(shapeLayer, below: titleLabel.layer)
    }
}
