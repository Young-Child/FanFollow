//
//  HorizontalImageSlideView.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

import Kingfisher

protocol ImageSlideDelegate: AnyObject {
    func imageSlideView(_ slideView: HorizontalImageSlideView, didChangeCurrentPage page: Int)
}

class HorizontalImageSlideView: UIView {
    public var pageControl: UIPageControl? {
        didSet {
            oldValue?.removeFromSuperview()
            
            if let pageControl = pageControl {
                addSubview(pageControl)
                pageControl.addTarget(self, action: #selector(didChangedCurrentPage), for: .valueChanged)
            }
            
            setNeedsLayout()
        }
    }
    
    let scrollView = UIScrollView()
    var resources: [Resource] = []
    private var slideShowItems: [UIImageView] = []
    private var currentPage: Int = .zero {
        didSet {
            if oldValue != currentPage {
                pageControl?.currentPage = currentPage
            }
        }
    }
    
    weak var delegate: ImageSlideDelegate?
    
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
        
        layoutPageControl()
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
        
        if let pageControl = pageControl {
            addSubview(pageControl)
        }
        
        layoutScrollView()
    }
    
    func layoutPageControl() {
        if let pageControl = pageControl {
            let topPadding = Constants.Spacing.small
            pageControl.sizeToFit()
            pageControl.frame = CGRect(
                x: frame.size.width / 2 - pageControl.frame.size.width / 2,
                y: frame.size.height - pageControl.frame.height - topPadding,
                width: pageControl.frame.size.width,
                height: pageControl.frame.size.height + topPadding
            )
        }
    }
    
    func layoutScrollView() {
        let pageControlSize = pageControl?.frame.size
        let topPadding = Constants.Spacing.small
        let bottomHeight = (pageControlSize?.height ?? .zero) + topPadding
        scrollView.frame = CGRect(
            x: .zero,
            y: .zero,
            width: frame.size.width,
            height: frame.size.height - bottomHeight
        )
        
        scrollView.contentSize = CGSize(
            width: scrollView.frame.size.width * CGFloat(slideShowItems.count),
            height: scrollView.frame.size.height
        )
        
        let size = scrollView.frame.size
        
        for (index, view) in slideShowItems.enumerated() {
            view.frame = CGRect(
                x: size.width * CGFloat(index),
                y: .zero,
                width: size.width,
                height: size.height
            )
        }
        
        pageControl?.numberOfPages = slideShowItems.count
    }
    
    func reloadScrollView() {
        resetImages()
        
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
    
    func resetImages() {
        for view in slideShowItems {
            view.removeFromSuperview()
        }
        
        slideShowItems = []
    }
    
    func setImageInputs(_ inputs: [String]) {
        let imageResources = inputs.compactMap { URL(string: $0) }.map { url in
            return ImageResource(downloadURL: url)
        }
        
        self.resources = imageResources
        
        reloadScrollView()
        layoutScrollView()
    }
    
    @objc private func didChangedCurrentPage() {
        if let newPage = pageControl?.currentPage {
            self.currentPage = newPage
        }
        
        if currentPage < slideShowItems.count {
            let scrollTarget = CGRect(
                x: scrollView.frame.size.width * CGFloat(currentPage),
                y: .zero,
                width: scrollView.frame.size.width,
                height: scrollView.frame.size.height
            )
            
            scrollView.scrollRectToVisible(scrollTarget, animated: true)
        }
    }
}

extension HorizontalImageSlideView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = (currentPage == slideShowItems.count - 1) && (currentPage == 0)
        
        let width = scrollView.frame.size.width
        
        if width > .zero {
            let offset = scrollView.contentOffset.x
            let currentPage = Int(offset + width / 2) / Int(width)
            self.currentPage = currentPage
        }
    }
}
