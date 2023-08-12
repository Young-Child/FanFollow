//
//  UploadLinkPreView.swift
//  FanFollow
//
//  Created by parkhyo on 2023/08/03.
//

import UIKit
import LinkPresentation

final class UploadLinkPreview: UIView {
    // View Properties
    private let defaultImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = Constants.Image.link
    }
    
    private let linkPreview = LPLinkView().then {
        $0.isHidden = true
    }
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Link Method
extension UploadLinkPreview {
    func setLink(to link: URL) {
        let provider = LPMetadataProvider()
        
        provider.startFetchingMetadata(for: link) { meta, error in
            DispatchQueue.main.async {
                guard let meta = meta, error == nil else {
                    self.defaultImageView.isHidden = false
                    self.linkPreview.isHidden = true
                    return
                }
                
                self.linkPreview.metadata = meta
                self.defaultImageView.isHidden = true
                self.linkPreview.isHidden = false
            }
        }
    }
}

// Configure UI
private extension UploadLinkPreview {
    func configureUI() {
        configureLayer()
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [linkPreview, defaultImageView].forEach(addSubview(_:))
    }
    
    func configureLayer() {
        layer.cornerRadius = 12
        layer.backgroundColor = UIColor.systemGray5.cgColor
        clipsToBounds = true
    }
    
    func makeConstraints() {
        linkPreview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        defaultImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(70)
        }
    }
}
