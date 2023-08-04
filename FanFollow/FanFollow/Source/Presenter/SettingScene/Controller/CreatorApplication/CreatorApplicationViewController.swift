//
//  CreatorApplicationViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/01.
//

import UIKit
import RxSwift
import RxRelay

final class CreatorApplicationViewController: UIViewController {
    // View Properties
    private let backBarButtonItem = UIBarButtonItem(image: Constants.backBarButtonItemImage)

    private let topLineView = UIView().then { view in
        view.backgroundColor = UIColor.systemGray4
    }

    private let stackView = UIStackView().then { stackView in
        stackView.axis = .vertical
    }

    private let stepView = CreatorApplicationStepView()

    private let creatorApplicationPageViewController = CreatorApplicationPageViewController()

    private let nextButton = UIButton(type: .roundedRect).then { button in
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setAttributedTitle(Constants.nextButtonTitleToGoNext, for: .normal)
    }

    // Properties
    weak var coordinator: CreatorApplicationCoordinator?
    private let disposeBag = DisposeBag()
    private let viewModel: CreatorApplicationViewModel
    private let category = BehaviorRelay(value: 0)
    private let links = BehaviorRelay(value: [String]())
    private let introduce = BehaviorRelay(value: "")

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
        creatorApplicationPageViewController.updatedJobCategoryIndex
            .subscribe(onNext: { [weak self] category in
                guard let self else { return }
                self.category.accept(category)
                self.configureNextButton(for: .category)
            })
            .disposed(by: disposeBag)

        creatorApplicationPageViewController.updatedLinks
            .subscribe(onNext: { [weak self] links in
                guard let self else { return }
                self.links.accept(links)
                self.configureNextButton(for: .links)
            })
            .disposed(by: disposeBag)

        creatorApplicationPageViewController.updatedIntroduce
            .subscribe(onNext: { [weak self] introduce in
                guard let self else { return }
                self.introduce.accept(introduce)
                self.configureNextButton(for: .introduce)
            })
            .disposed(by: disposeBag)
    }

    func bindingViewModel() {
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
        output.creatorApplicationStep
            .asDriver(onErrorJustReturn: .back)
            .drive { [weak self] creatorApplicationStep in
                guard let self else { return }
                if case .back = creatorApplicationStep {
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.creatorApplicationPageViewController.setViewController(
                    for: creatorApplicationStep,
                    direction: .forward
                )
                self.configureNextButton(for: creatorApplicationStep)
                self.stepView.configure(creatorApplicationStep)
            }
            .disposed(by: disposeBag)
    }

    func configureNextButton(for creatorApplicationStep: CreatorApplicationStep) {
        switch creatorApplicationStep {
        case .category:
            nextButton.setAttributedTitle(Constants.nextButtonTitleToGoNext, for: .normal)
            nextButton.isEnabled = true
        case .links:
            nextButton.setAttributedTitle(Constants.nextButtonTitleToGoNext, for: .normal)
            let someLinksAreEmpty = links.value.filter { $0.isEmpty }.count > 0
            nextButton.isEnabled = someLinksAreEmpty == false
        case .introduce:
            nextButton.setAttributedTitle(Constants.nextButtonTitleToConform, for: .normal)
            let introduceIsEmpty = introduce.value.isEmpty
            nextButton.isEnabled = introduceIsEmpty == false
        default:
            return
        }
        if nextButton.isEnabled {
            nextButton.backgroundColor = UIColor(named: "AccentColor")
        } else {
            nextButton.backgroundColor = UIColor(named: "SecondaryColor")
        }
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
        addChild(creatorApplicationPageViewController)
        [topLineView, stepView, creatorApplicationPageViewController.view, nextButton].forEach(stackView.addArrangedSubview)
        creatorApplicationPageViewController.didMove(toParent: self)
        view.addSubview(stackView)
    }

    func configureConstraints() {
        topLineView.snp.makeConstraints { $0.height.equalTo(1) }
        nextButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        stackView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide).inset(16)
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
