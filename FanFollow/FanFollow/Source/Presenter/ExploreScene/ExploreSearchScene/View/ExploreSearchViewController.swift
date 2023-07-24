//
//  ExploreSearchViewController.swift
//  FanFollow
//
//  Created by parkhyo on 2023/07/23.
//

import UIKit
import RxSwift

final class ExploreSearchViewController: UIViewController {
    // View Properties
    private let searchBar = UISearchBar().then {
        $0.barTintColor = .blue
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.tintColor = .white
        $0.searchTextField.textColor = .white
        $0.searchTextField.clearButtonMode = .whileEditing
        $0.searchTextField.leftView?.tintColor = .white
        $0.searchTextField.backgroundColor = .red
        $0.setImage(UIImage(systemName: Constants.searchImage), for: .clear, state: .normal)
        $0.searchTextField.attributedPlaceholder = NSAttributedString(
            string: Constants.searchPlaceHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
    
    private let searchTableView = UITableView(frame: .zero, style: .plain).then {
        $0.separatorColor = .clear
        $0.backgroundColor = .clear
        $0.register(CreatorListCell.self, forCellReuseIdentifier: CreatorListCell.reuseIdentifier)
    }
    
    // Properties
    private let viewModel: ExploreSearchViewModel
    private let disposeBag = DisposeBag()
    
    // Initializer
    init(viewModel: ExploreSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

// Configure UI
private extension ExploreSearchViewController {
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        configureHierarchy()
        makeConstraints()
    }
    
    func configureHierarchy() {
        [searchBar, searchTableView].forEach { view.addSubview($0) }
    }
    
    func makeConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
        }
        
        searchTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// Constants
private extension ExploreSearchViewController {
    enum Constants {
        static let searchPlaceHolder = "크리에이터의 닉네임을 검색해보세요."
        static let searchImage = "magnifyingglass"
    }
}
