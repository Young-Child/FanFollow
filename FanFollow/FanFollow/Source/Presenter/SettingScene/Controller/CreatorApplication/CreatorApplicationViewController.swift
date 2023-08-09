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
    private let category = BehaviorRelay(value: 0)
    private let links = BehaviorRelay(value: [String]())
    private let introduce = BehaviorRelay(value: "")
    
    private var currentStep = BehaviorRelay<CreatorApplicationStep>(value: .category)
    
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
        bindingView()
        bindingViewModel()
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
    func bindingView() {
        //        creatorApplicationPageViewController.updatedJobCategoryIndex
        //            .subscribe(onNext: { [weak self] category in
        //                guard let self else { return }
        //                self.category.accept(category)
        //                self.configureNextButton(for: .category)
        //            })
        //            .disposed(by: disposeBag)
        //
        //        creatorApplicationPageViewController.updatedLinks
        //            .subscribe(onNext: { [weak self] links in
        //                guard let self else { return }
        //                self.links.accept(links)
        //                self.configureNextButton(for: .links)
        //            })
        //            .disposed(by: disposeBag)
        //
        //        creatorApplicationPageViewController.updatedIntroduce
        //            .subscribe(onNext: { [weak self] introduce in
        //                guard let self else { return }
        //                self.introduce.accept(introduce)
        //                self.configureNextButton(for: .introduce)
        //            })
        //            .disposed(by: disposeBag)
    }
    
    func bindingViewModel() {
        bindViews()
        let input = input()
        let output = viewModel.transform(input: input)
        bind(output)
    }
    
    func input() -> CreatorApplicationViewModel.Input {
        let creatorInformation = nextButton.rx.tap
            .withUnretained(self)
            .throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .flatMapFirst { _ -> Observable<CreatorApplicationViewModel.CreatorInformation> in
                let category = self.category.value
                let links = self.links.value
                let introduce = self.introduce.value
                return .just((category, links, introduce))
            }
        
        return CreatorApplicationViewModel.Input(
            viewWillAppear: rx.methodInvoked(#selector(viewWillAppear)).map { _ in }.asObservable(),
            backButtonTap: backBarButtonItem.rx.tap
                .throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
                .map { _ in }.asObservable(),
            nextButtonTap: creatorInformation
        )
    }
    
    func bind(_ output: CreatorApplicationViewModel.Output) {
        //        output.creatorApplicationStep
        //            .observe(on: MainScheduler.asyncInstance)
        //            .asDriver(onErrorJustReturn: .back)
        //            .drive { [weak self] creatorApplicationStep in
        //                guard let self else { return }
        //                if case .back = creatorApplicationStep {
        //                    self.navigationController?.popViewController(animated: true)
        //                    return
        //                }
        //                self.creatorApplicationPageViewController.setViewController(
        //                    for: creatorApplicationStep,
        //                    direction: .forward
        //                )
        //                self.configureNextButton(for: creatorApplicationStep)
        ////                self.stepView.configure(creatorApplicationStep)
        //            }
        //            .disposed(by: disposeBag)
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
                .debug()
                .bind(onNext: configureNextButtonAppear(_:))
                .disposed(by: disposeBag)
        }
        
        currentStep.asDriver(onErrorJustReturn: .category)
            .map(\.rawValue)
            .drive(onNext: self.changePageView)
            .disposed(by: disposeBag)
    }
    
    func configureNextButton(for creatorApplicationStep: CreatorApplicationStep) {
//        switch creatorApplicationStep {
//        case .category:
//            nextButton.setAttributedTitle(Constants.nextButtonTitleToGoNext, for: .normal)
//            nextButton.isEnabled = true
//        case .links:
//            nextButton.setAttributedTitle(Constants.nextButtonTitleToGoNext, for: .normal)
//            let someLinksAreEmpty = links.value.filter { $0.isEmpty }.count > 0
//            nextButton.isEnabled = someLinksAreEmpty == false
//        case .introduce:
//            nextButton.setAttributedTitle(Constants.nextButtonTitleToConform, for: .normal)
//            let introduceIsEmpty = introduce.value.isEmpty
//            nextButton.isEnabled = introduceIsEmpty == false
//        default:
//            return
//        }
//        if nextButton.isEnabled {
//            nextButton.backgroundColor = UIColor(named: "AccentColor")
//        } else {
//            nextButton.backgroundColor = UIColor(named: "SecondaryColor")
//        }
    }
}

private extension CreatorApplicationViewController {
    func changePageView(_ index: Int) {
        guard let controller = childControllers[safe: index] else { return }
        pageController.setViewControllers([controller], direction: .forward, animated: false)
    }
    
    func configureNextButtonAppear(_ isEnable: Bool) {
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
