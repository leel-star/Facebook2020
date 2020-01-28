//
//  PhotosGridController.swift
//  FB2020
//
//  Created by Matthew Sutton on 1/27/20.
//  Copyright © 2020 Matthew Sutton. All rights reserved.
//

import UIKit
import SwiftUI
import LBTATools

class PhotosGridCell: LBTAListCell<String> {
    
    let imageView = UIImageView(image: UIImage(named: "image1"), contentMode: .scaleAspectFill)
    
    override var item: String! {
        didSet {
            imageView.image = UIImage(named: item)
        }
    }
    
    override func setupViews() {
        backgroundColor = .yellow
        
        stack(imageView)
    }
}

class PhotosGridController: LBTAListController<PhotosGridCell, String>, UICollectionViewDelegateFlowLayout {
    
    let cellSpacing: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .lightGray
        
        self.items = ["image1", "image2", "image3", "image4", "image5"]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.items.count == 4 {
            // do 4 grid cell layout
        }
        
        if indexPath.item == 0 || indexPath.item == 1 {
            let width = (view.frame.width - 3 * cellSpacing) / 2
            
            return .init(width: width, height: width)
        }
        
        let width = (view.frame.width - 4.1 * cellSpacing) / 3
        
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: cellSpacing, bottom: 0, right: cellSpacing)
    }
}

struct PhotosGridPreview: PreviewProvider {
    
    static var previews: some View {
        ContainerView()
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        typealias UIViewControllerType = PhotosGridController
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<PhotosGridPreview.ContainerView>) -> PhotosGridPreview.ContainerView.UIViewControllerType {
            return PhotosGridController()
        }
        
        func updateUIViewController(_ uiViewController: PhotosGridPreview.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<PhotosGridPreview.ContainerView>) {
        }
    }
}
