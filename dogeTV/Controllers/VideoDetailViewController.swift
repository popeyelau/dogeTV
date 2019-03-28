//
//  VideoDetailViewController.swift
//  dogeTV
//
//  Created by Popeye Lau on 2019/3/14.
//  Copyright © 2019 Popeye Lau. All rights reserved.
//

import UIKit
import SnapKit
import Carbon
import PromiseKit
import Kingfisher
import PKHUD
import SPStorkController


class VideoDetailViewController: UIViewController {
    var resourceIndex = 0
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    var selectionController: SelectionViewController<Int>?
    var media: Video?
    var episodes: [Episode] = []

    lazy var renderer = Renderer(
        target: collectionView,
        adapter: VideoDetailViewAdapter(),
        updater: UICollectionViewUpdater()
    )

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @objc func switchResource(_ sender: UIButton) {
        guard let video = media, video.source > 0 else {
            showInfo("没有其它路线可用")
            return
        }
        
        if selectionController == nil {
            let sources = Array(0..<min(video.source, 8))
            selectionController = SelectionViewController(sources, labels: { "线路 \($0+1)" } ){ [weak self] (source) in
                self?.resourceIndex = source
                self?.refreshResource(with: source)
            }
            selectionController?.preferredContentSize = CGSize(width: 130, height: sources.count * 44)
        }
        showSourceSelectionView(with: sender)
    }
    
    func showSourceSelectionView(with sourceView: UIView) {
        guard let controller = selectionController else {
            return
        }
        let presentationController = PopoverPresentation.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds.insetBy(dx: -10, dy: 0)
        presentationController.permittedArrowDirections = [.left]
        present(controller, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = media?.name
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 40, left: 8, bottom: 0, right: 8))
        }
        render()
        renderer.adapter.didSelect = {[weak self] ctx in
            guard let item = ctx.node.component.as(EpisodeItemComponent.self) else {
                return
            }
            self?.handleSelect(item: item.data)
        }
    }

    func handleSelect(item: Episode) {
        //FIXME:
        if item.url.hasSuffix(".m3u8")
            || item.url.hasSuffix(".m3u")
            || item.url.hasSuffix(".mp4")
            || item.url.hasSuffix(".avi"){
            play(with: item)
            return
        }

        //call resolve api
        HUD.show(.progress)
        _ = APIClient.resolveUrl(url: item.url)
            .done { (url) in
                self.play(with: Episode(title: item.title, url: url))
            }.catch({ (error) in
                print(error)
                self.showError(error)
            }).finally {
                HUD.hide()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    

    override var shouldAutorotate: Bool {
        return false
    }

    func render() {
        guard let video = self.media else { return }
        let cells = episodes.map { (item) -> CellNode in
            CellNode(EpisodeItemComponent(data: item))
        }

        renderer.render(Section(id: 0, header: ViewNode(VideoHeaderComponent(data: video))),
                        Section(id: 1, header: ViewNode(VideoEpisodeHeaderComponent(data: "线路\(resourceIndex+1)") { [weak self] sender in
                            self?.switchResource(sender)
                        }), cells: cells))
    }
    
    func play(with video: Episode) {
        if video.url.isEmpty {
            showInfo("无效的地址")
            return
        }
        
        /*
        //nPlayer 打开
        if UIApplication.shared.canOpenURL(URL(string: "nplayer-http://")!) {
            let nPlayer = URL(string: "nplayer-\(video.url)")!
            UIApplication.shared.open(nPlayer, options: [:], completionHandler: nil)
            return
        }*/

        UIPasteboard.general.string = video.url
        let target = PlayerViewController()
        target.onDidDisappear = {
            SPStorkController.updatePresentingController(modal: self)
        }
        present(target, animated: true) {
            target.play(url: video.url, title: nil)
        }
    }


    func refreshResource(with index: Int) {
        guard let id = media?.id else {
            return
        }
        _ = APIClient.fetchEpisodes(id: id, source: index).done { (episodes) in
            self.episodes = episodes
            }.catch({ (error) in
                print(error)
                self.showError(error)
            }).finally {
                self.render()
                HUD.hide()
        }
    }
}

class VideoDetailViewAdapter: UICollectionViewFlowLayoutAdapter {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SPStorkController.scrollViewDidScroll(scrollView)
    }
}
