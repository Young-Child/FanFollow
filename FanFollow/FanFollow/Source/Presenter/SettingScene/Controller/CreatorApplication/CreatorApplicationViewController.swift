//
//  CreatorApplicationViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/01.
//

import UIKit

import RxRelay
import RxSwift

final class CreatorApplicationViewController: UIViewController {
    // View Properties
    private let backBarButtonItem = UIBarButtonItem(image: Constants.backBarButtonItemImage)
    
    private let stepView = CreatorApplicationStepView()
    
    private let pageController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private let nextButton = UIButton(type: .roundedRect).then { button in
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.label, for: .disabled)
    }
    
    private let childControllers = CreatorApplicationStep.allInstance
    
    // Properties
    weak var coordinator: CreatorApplicationCoordinator?
    private let disposeBag = DisposeBag()
    private let viewModel: CreatorApplicationViewModel
    
    private var currentStep = BehaviorRelay<CreatorApplicationStep>(value: .category)
    private var selectedCategory = BehaviorRelay<JobCategory>(value: .unSetting)
    private var writtenLinks = BehaviorRelay<[String]>(value: [])
    private var writtenIntroduce = BehaviorRelay<String>(value: "")
    
    // Initializer
    init(viewModel: CreatorApplicationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
}

// Binding Method
private extension CreatorApplicationViewController {
    func bind() {
        bindViews()
        let input = input()
        let output = viewModel.transform(input: input)
        bind(output)
    }
    
    func input() -> CreatorApplicationViewModel.Input {
        let confirmButtonTapped = nextButton.rx.tap
            .filter { self.currentStep.value == .confirm }
            .map { _ in
                return (
                    self.selectedCategory.value.rawValue,
                    self.writtenLinks.value,
                    self.writtenIntroduce.value
                )
            }
        
        return CreatorApplicationViewModel.Input(
            nextButtonTap: confirmButtonTapped
        )
    }
    
    func bind(_ output: CreatorApplicationViewModel.Output) {
        output.updateResult
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func bindViews() {
        Observable.merge(
            nextButton.rx.tap.map { true },
            backBarButtonItem.rx.tap.map { false }
        )
        .map { $0 ? self.currentStep.value.next : self.currentStep.value.previous }
        .asDriver(onErrorJustReturn: .category)
        .drive(currentStep)
        .disposed(by: disposeBag)
        
        childControllers.forEach { controller in
            controller.nextButtonEnable
                .bind(onNext: configureNextButtonAppear(_:))
                .disposed(by: disposeBag)
            
            bindChildViewController(to: controller)
        }
        
        currentStep.asDriver(onErrorJustReturn: .category)
            .filter { $0 != .confirm }
            .drive(onNext: self.changePageView)
            .disposed(by: disposeBag)
    }
    
    func bindChildViewController(to controller: CreatorApplicationChildController) {
        if let controller = controller as? CreatorJobCategoryPickerViewController {
            controller.selectedCategory
                .bind(to: selectedCategory)
                .disposed(by: disposeBag)
        }
        
        if let controller = controller as? CreatorLinksTableViewController {
            controller.writtenLinks
                .bind(to: writtenLinks)
                .disposed(by: disposeBag)
        }
        
        if let controller = controller as? CreatorIntroduceViewController {
            controller.writtenIntroduce
                .bind(to: writtenIntroduce)
                .disposed(by: disposeBag)
        }
    }
}

private extension CreatorApplicationViewController {
    func changePageView(_ currentStep: CreatorApplicationStep) {
        if currentStep.rawValue < .zero {
            navigationController?.popViewController(animated: true)
            return
        }
        
        guard let controller = childControllers[safe: currentStep.rawValue] else { return }
        stepView.configAppear(currentStep: currentStep)
        pageController.setViewControllers([controller], direction: .forward, animated: false)
    }
    
    func configureNextButtonAppear(_ isEnable: Bool) {
        print(isEnable)
        nextButton.isEnabled = isEnable
        let backgroundColor = isEnable ? UIColor(named: "AccentColor") : UIColor.systemGray5
        nextButton.backgroundColor = backgroundColor
        
        let title = isEnable ? (currentStep.value == .introduce ? "확인" : "다음") : "입력을 완료해주세요."
        nextButton.setTitle(title, for: .normal)
    }
}

// Configure UI
private extension CreatorApplicationViewController {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        configureNavigationItem()
    }
    
    func configureHierarchy() {
        addChild(pageController)
        pageController.didMove(toParent: self)
        [stepView, pageController.view, nextButton].forEach(view.addSubview)
    }
    
    func configureConstraints() {
        stepView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        pageController.view.snp.makeConstraints {
            $0.top.equalTo(stepView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(pageController.view.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
    
    func configureNavigationItem() {
        navigationItem.setLeftBarButton(backBarButtonItem, animated: false)
    }
}

// Constants
private extension CreatorApplicationViewController {
    enum Constants {
        static let backBarButtonItemImage = UIImage(systemName: "chevron.backward")
        static let nextButtonTitleToGoNext = NSAttributedString(
            string: "다음",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: UIColor.white]
        )
        static let nextButtonTitleToConform = NSAttributedString(
            string: "확인",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: UIColor.white]
        )
    }
}
