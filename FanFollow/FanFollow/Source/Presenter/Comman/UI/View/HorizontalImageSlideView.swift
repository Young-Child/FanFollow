//
//  HorizontalImageSlideView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher

class HorizontalImageSlideView: UIView {
    let scrollView = UIScrollView()
    var resources: [Resource] = []
    private var slideShowItems: [UIImageView] = []
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutScrollView()
    }
    
    private func configureUI() {
        autoresizesSubviews = true
        clipsToBounds = true
        
        scrollView.frame = CGRect(x: .zero, y: .zero, width: frame.size.width, height: frame.size.height)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.autoresizingMask = autoresizingMask
        
        addSubview(scrollView)
        
        layoutScrollView()
    }
    
    func layoutScrollView() {
        scrollView.frame = CGRect(x: .zero, y: .zero, width: frame.size.width, height: frame.size.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(slideShowItems.count), height: frame.size.height)
        
        let size = scrollView.frame.size
        
        for (index, view) in slideShowItems.enumerated() {
            view.frame = CGRect(
                x: size.width * CGFloat(index),
                y: .zero,
                width: size.width,
                height: size.height
            )
        }
    }
    
    func reloadScrollView() {
        for view in slideShowItems {
            view.removeFromSuperview()
        }
        
        slideShowItems = []
        
        for image in resources {
            let frame = CGRect(x: .zero, y: .zero, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            let imageView = UIImageView(frame: frame)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: image)
            
            slideShowItems.append(imageView)
            scrollView.addSubview(imageView)
        }
    }
    
    func setImageInputs(_ inputs: [String]) {
        let imageResources = inputs.compactMap { URL(string: $0) }.map { url in
            return ImageResource(downloadURL: url)
        }
        
        self.resources = imageResources
        
        reloadScrollView()
        layoutScrollView()
    }
}

extension HorizontalImageSlideView: UIScrollViewDelegate {
    
}
