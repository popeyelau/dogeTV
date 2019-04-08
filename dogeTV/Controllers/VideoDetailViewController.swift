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


class VideoDetailViewController: BaseViewController {
    
    enum ID {
        case header
        case lines
        case episodes
        case recommends
    }
    
    var resourceIndex = 0
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.theme_backgroundColor = AppColor.secondaryBackgroundColor
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    var selectionController: SelectionViewController<Int>?
    var detail: VideoDetail?
    var episodes: [Episode] = []

    lazy var renderer = Renderer(
        target: collectionView,
        adapter: VideoDetailViewAdapter(),
        updater: UICollectionViewUpdater()
    )

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = AppColor.secondaryBackgroundColor
       
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        render()
        renderer.adapter.didSelect = {[weak self] ctx in
            if let item = ctx.node.component.as(EpisodeItemComponent.self) {
                self?.handleSelect(item: item.data)
            } else if let item = ctx.node.component.as(SourceItemComponent.self) {
                self?.resourceIndex = item.data.source
                self?.refreshResource(with: item.data.source)
            } else if let item = ctx.node.component.as(VideoItemComponent.self){
                self?.showVideo(with: item.id)
            }
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
        guard let detail = self.detail else { return }
        
        title = detail.info.name
        
        // 头部
        let header = Section(id: ID.header, header: ViewNode(VideoHeaderComponent(data: detail.info)))

        // 线路
        let lines = (0..<min(detail.info.source,10)).map{ (source) -> CellNode in
            CellNode(SourceItemComponent(data: VideoSource(source: source, isSelected: resourceIndex == source)))
        }
        let lineSection = Section(id: ID.lines, header: ViewNode(VideoEpisodeHeaderComponent(title: "线路",
                                                                           subTitle: "线路画质从高到低")), cells: lines)

        // 分集
        let cells = episodes.map { (item) -> CellNode in
            CellNode(EpisodeItemComponent(data: item))
        }
        let episodeSection = Section(id: ID.episodes, header: ViewNode(VideoEpisodeHeaderComponent(title: "分集")), cells: cells)
        
        var sections: [Section] = [header, lineSection, episodeSection];
        
        // 推荐
        if let recommends = detail.recommends {
            let cells = recommends.prefix(6).compactMap{ (item) -> CellNode in CellNode(VideoItemComponent(data: item)) }
            let recommendSection = Section(id: ID.recommends, header: ViewNode(VideoEpisodeHeaderComponent(title: "猜你喜欢")), cells: cells)
            sections.append(recommendSection)
        }

        renderer.render(sections)
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
        guard let id = detail?.info.id else {
            return
        }
        HUD.show(.progress)
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
