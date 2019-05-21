//
//  TopicListComponent.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/15.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon

struct TopicListComponent: IdentifiableComponent {
    typealias Content = TopicListContentView

    let items: [Topic]
    var onSelect: (Int) -> Void

    var id: Int {
        return 0
    }

    func renderContent() -> Content {
        let content = Content()
        content.onSelect = onSelect
        return content
    }

    func render(in content: Content) {
        content.items = items
    }

    func referenceSize(in bounds: CGRect) -> CGSize? {
        return CGSize(width: bounds.width - 16, height: 130)
    }

    func shouldContentUpdate(with next: TopicListComponent) -> Bool {
        return items != next.items
    }
}




class TopicListContentView: UIView {
    var  items: [Topic] = [] {
        didSet {
            render()
        }
    }
    var onSelect: ((Int) -> Void)?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.theme_backgroundColor = AppColor.backgroundColor
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()


    lazy var renderer = Renderer(
        adapter: UICollectionViewFlowLayoutAdapter(),
        updater: UICollectionViewUpdater()
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        renderer.target = collectionView
        render()
        renderer.adapter.didSelect = didSelect
    }

    func didSelect(context: UICollectionViewAdapter.SelectionContext) {
        onSelect?(context.indexPath.item)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func render() {
        let cells = items.map { (item) -> CellNode in
            CellNode(TopicListItemComponent(data: item))
        }
        renderer.render(
            Section(id: 0, cells: cells)
        )
    }

}

