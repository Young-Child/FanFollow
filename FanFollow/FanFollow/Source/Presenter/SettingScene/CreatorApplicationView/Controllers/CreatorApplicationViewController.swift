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
    private let navigationBar = FFNavigationBar()
    
    private let stepView = CreatorApplicationStepView()
    
    private let pageController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    
    private let nextButton = UIButton(type: .roundedRect).then { button in
        button.titleLabel?.font = .coreDreamFont(ofSize: 16, weight: .regular)
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.layer.cornerRadius = 4
        button.setTitleColor(Constants.Color.background, for: .normal)
        button.setTitleColor(Constants.Color.label, for: .disabled)
    }
    
    private let childControllers = CreatorApplicationStep.allInstance
    
    // Properties
    weak var coordinator: CreatorApplicationCoordinator?
    private let disposeBag = DisposeBag()
    private let viewModel: CreatorApplicationViewModel
    
    private var currentStep = BehaviorRelay<CreatorApplicationStep>(value: .agreement)
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
                self.coordinator?.close(to: self)
            })
            .disposed(by: disposeBag)
    }
    
    func bindViews() {
        Observable.merge(
            nextButton.rx.tap.map { true },
            navigationBar.leftBarButton.rx.tap.map { false }
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
            coordinator?.close(to: self)
            return
        }
        
        guard let controller = childControllers[safe: currentStep.rawValue] else { return }
        stepView.configAppear(currentStep: currentStep)
        pageController.setViewControllers([controller], direction: .forward, animated: false)
    }
    
    func configureNextButtonAppear(_ isEnable: Bool) {
        nextButton.isEnabled = isEnable
        let backgroundColor = isEnable ? Constants.Color.blue : Constants.Color.gray
        nextButton.backgroundColor = backgroundColor
        
        if isEnable == false {
            nextButton.setTitle(Constants.Text.inputMessage, for: .normal)
            return
        }
        
        let title = currentStep.value == .introduce ? Constants.Text.complete : Constants.Text.next
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
        [navigationBar, stepView, pageController.view, nextButton].forEach(view.addSubview)
    }
    
    func configureConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.Spacing.xLarge)
        }
        
        stepView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        pageController.view.snp.makeConstraints {
            $0.top.equalTo(stepView.snp.bottom).offset(Constants.Spacing.medium)
            $0.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(pageController.view.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(Constants.Spacing.small)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-Constants.Spacing.medium)
        }
    }
    
    func configureNavigationItem() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 22)
        let image = Constants.Image.back?.withConfiguration(configuration)
        navigationBar.leftBarButton.setImage(image, for: .normal)
    }
}
