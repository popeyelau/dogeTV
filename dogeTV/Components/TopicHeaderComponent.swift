//
//  TopicHeaderComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/3.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//


import UIKit
import SnapKit
import Carbon


struct TopicHeaderComponent: IdentifiableComponent {
    typealias Content = TopicHeaderContentView

    var id: String {
        return data.id
    }

    var data: Topic

    func renderContent() -> Content {
        let content = Content()
        return content
    }

    func render(in content: Content) {
        content.backgroundImageView.setResourceImage(with: data.cover, placeholder: UIImage(named: "blur"))
        content.intro = data.desc.trimed
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        let insets = UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        let attributes:[NSAttributedString.Key: Any] = [.font: UIFont.preferredFont(forTextStyle: .caption2), .paragraphStyle: paragraphStyle]
        let textHeight = data.desc.trimed.heightOfString(withConstrainedWidth: bounds.width, attributes: attributes, insets: insets)
        return CGSize(width: bounds.width, height: textHeight)
    }

    func shouldContentUpdate(with next: TopicHeaderComponent) -> Bool {
        return data != next.data
    }
}



class TopicHeaderContentView: UIView {
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    var intro: String? {
        didSet {
            guard let intro = intro else {
                introLabel.text = nil
                introLabel.attributedText = nil
                return
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            introLabel.attributedText = NSAttributedString(string: intro, attributes: [.paragraphStyle: paragraphStyle])
        }
    }

    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textColor = .groupTableViewBackground
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundImageView)
        addSubview(introLabel)

        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        introLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8))
        }

        let blur = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blur)
        backgroundImageView.addSubview(effectView)
        effectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
