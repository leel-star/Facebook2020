//
//  MainController.swift
//  FB2020
//
//  Created by Matthew Sutton on 1/25/20.
//  Copyright © 2020 Matthew Sutton. All rights reserved.
//

import UIKit
import SwiftUI
import LBTATools

class PostCell: LBTAListCell<String> {
    
    let imageView = UIImageView(backgroundColor: .blue)
    let nameLabel = UILabel(text: "Name Label")
    let dateLabel = UILabel(text: "Friday at 11:11 AM")
    let postTextLabel = UILabel(text: "Here is my post text?")
    
    //let imageViewGrid = UIView(backgroundColor: .yellow)
    
    let photosGridController = PhotosGridController()
    
    override func setupViews() {
        backgroundColor = .white
        
        stack(hstack(imageView.withHeight(40).withWidth(40),
                     stack(nameLabel, dateLabel),
                     spacing: 8
        ).padLeft(12).padRight(12).padTop(12),
              postTextLabel,
              photosGridController.view,
              spacing: 8)
    }
}

class StoryHeader: UICollectionReusableView {
    
    let storiesController = StoriesController(scrollDirection: .horizontal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        stack(storiesController.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class StoryPhotoCell: LBTAListCell<String> {
    
    let imageView = UIImageView(image: nil, contentMode: .scaleAspectFill)
    let nameLabel = UILabel(text: "Mountains", font: .boldSystemFont(ofSize: 14), textColor: .white)
    
    let gradientLayer = CAGradientLayer()
    
    override var item: String! {
        didSet {
            imageView.image = UIImage(named: item)
        }
    }
    
    override func setupViews() {
        imageView.layer.cornerRadius = 10
        
        stack(imageView)
        setupGradientLayer()
        stack(UIView(), nameLabel).withMargins(.allSides(8))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    fileprivate func setupGradientLayer() {
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.1]
        layer.cornerRadius = 10
        clipsToBounds = true
        
        layer.addSublayer(gradientLayer)
    }
}

class StoriesController: LBTAListController<StoryPhotoCell, String>, UICollectionViewDelegateFlowLayout {
    
    let fbLogoImageView = UIImageView(image: UIImage(named: "facebook"), contentMode: .scaleAspectFit)
    let searchButton = UIButton(title: "Search", titleColor: .label)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.items = ["image6", "image5", "image4", "image3", "image2", "image1"]
        
        setupNavBar()
    }
    
    fileprivate func setupNavBar() {
        
        let coverWhiteView = UIView(backgroundColor: .systemBackground)
        view.addSubview(coverWhiteView)
        coverWhiteView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        let safeAreaTop = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
        coverWhiteView.constrainHeight(safeAreaTop)
        
        let width = view.frame.width - 120 - 16
        
        let titleView = UIView(backgroundColor: .clear)
        titleView.frame = .init(x: 0, y: 0, width: width, height: 50)
                        
        titleView.hstack(fbLogoImageView.withWidth(120), UIView(backgroundColor: .clear).withWidth(width), searchButton.withWidth(60))
        
        navigationItem.titleView = titleView
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let safeAreaTop = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
        
        let magicalSafeAreaTop: CGFloat = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
        print(scrollView.contentOffset.y)
        
        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
        
        let alpha: CGFloat = 1 + (scrollView.contentOffset.y / magicalSafeAreaTop)
        
        [fbLogoImageView, searchButton].forEach { $0.alpha = alpha }
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.height - 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 0, right: 12)
    }
}

class MainController: LBTAListHeaderController<PostCell, String, StoryHeader>, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1)
        self.items = ["hello", "World", "1", "2"]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: 0, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 12, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 400)
    }
}

struct MainPreview: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = UINavigationController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) -> MainPreview.ContainerView.UIViewControllerType {
            
            return UINavigationController(rootViewController: MainController())
        }
        
        func updateUIViewController(_ uiViewController: MainPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<MainPreview.ContainerView>) {
        }
    }
}
