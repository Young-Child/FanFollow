//
//  CreatorApplicationViewController.swift
//  FanFollow
//
//  Created by junho lee on 2023/08/01.
//

import UIKit
import RxSwift

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

    private let inputContentView = UIView()

    private let jobCategoryPickerView = JobCategoryPickerView()

    private let linkScrollView = UIScrollView().then { scrollView in
        scrollView.isHidden = true
    }

    private let linkStackView = UIStackView().then { stackView in
        stackView.axis = .vertical
        let linkTextFieldView = CreatorApplicationTextFieldView()
        linkTextFieldView.title = "링크1"
        linkTextFieldView.keyboardType = .URL
        stackView.addArrangedSubview(linkTextFieldView)
    }

    private let introduceTextView = PlaceholderTextView().then { textView in
        textView.isHidden = true
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.placeholder = Constants.introduceInputViewPlaceholder
    }

    private let addLinkButton = UIButton(type: .roundedRect).then { button in
        button.setAttributedTitle(Constants.addLinkButtonTitle, for: .normal)
    }

    private let nextButton = UIButton(type: .roundedRect).then { button in
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "AccentColor")
        button.setAttributedTitle(Constants.nextButtonTitleToGoNext, for: .normal)
    }

    // Properties
    weak var coordinator: CreatorApplicationCoordinator?
    private let disposeBag = DisposeBag()
    private let viewModel: CreatorApplicationViewModel

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
        binding()
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
    func binding() {
        let input = input()
        let output = viewModel.transform(input: input)
        bind(output)
    }

    func input() -> CreatorApplicationViewModel.Input {
        let creatorInformation = nextButton.rx.tap
            .withUnretained(self)
            .throttle(RxTimeInterval.milliseconds(100), scheduler: MainScheduler.instance)
            .flatMapFirst { _ -> Observable<CreatorApplicationViewModel.CreatorInformation> in
                let category = self.jobCategoryPickerView.selectedRow(inComponent: .zero)
                let links: [String] = self.linkStackView.arrangedSubviews.compactMap { view in
                    guard let view = view as? CreatorApplicationTextFieldView,
                          let text = view.text,
                          text.isEmpty == false else { return nil }
                    return text
                }
                let introduce = self.introduceTextView.text
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
                let isHidden: (Bool, Bool, Bool)
                let nextButtonTitle: NSAttributedString
                switch creatorApplicationStep {
                case .back:
                    self.navigationController?.popViewController(animated: true)
                    return
                case .category:
                    nextButtonTitle = Constants.nextButtonTitleToGoNext
                    isHidden = (false, true, true)
                case .links:
                    nextButtonTitle = Constants.nextButtonTitleToGoNext
                    isHidden = (true, false, true)
                case .introduce:
                    nextButtonTitle = Constants.nextButtonTitleToConform
                    isHidden = (true, true, false)
                }
                self.nextButton.setAttributedTitle(nextButtonTitle, for: .normal)
                self.jobCategoryPickerView.isHidden = isHidden.0
                self.linkScrollView.isHidden = isHidden.1
                self.introduceTextView.isHidden = isHidden.2
                self.stepView.configure(creatorApplicationStep)
            }
            .disposed(by: disposeBag)
    }
}

// Configure UI
private extension CreatorApplicationViewController {
    func configureUI() {
        configureHierarchy()
        configureConstraints()
        configureNavigationItem()
        configureAddButtonAction()
    }

    func configureHierarchy() {
        linkScrollView.addSubview(linkStackView)
        linkStackView.addArrangedSubview(addLinkButton)
        [jobCategoryPickerView, linkScrollView, introduceTextView].forEach(inputContentView.addSubview)

        [topLineView, stepView, inputContentView, nextButton].forEach(stackView.addArrangedSubview)
        view.addSubview(stackView)
    }

    func configureConstraints() {
        topLineView.snp.makeConstraints { $0.height.equalTo(1) }
        jobCategoryPickerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        [linkScrollView, introduceTextView].forEach { view in
            view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        introduceTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        linkStackView.snp.makeConstraints {
            $0.edges.equalTo(linkScrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
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

    func configureAddButtonAction() {
        addLinkButton.addAction(
            UIAction(handler: { [weak self] _ in
                guard let self else { return }
                let index = self.linkStackView.arrangedSubviews.count
                let linkTextFieldView = CreatorApplicationTextFieldView(
                    frame: CGRect(x: 0, y: 0, width: self.linkStackView.frame.width, height: 20)
                )
                linkTextFieldView.title = "링크\(index)"
                linkTextFieldView.keyboardType = .URL
                self.linkStackView.insertArrangedSubview(linkTextFieldView, at: index - 1)
            }),
            for: .touchUpInside
        )
    }
}

// Constants
private extension CreatorApplicationViewController {
    enum Constants {
        static let backBarButtonItemImage = UIImage(systemName: "chevron.backward")
        static let addLinkButtonTitle = NSAttributedString(
            string: "링크 추가하기",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
        )
        static let nextButtonTitleToGoNext = NSAttributedString(
            string: "다음",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: UIColor.white]
        )
        static let nextButtonTitleToConform = NSAttributedString(
            string: "확인",
            attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular), .foregroundColor: UIColor.white]
        )
        static let introduceInputViewPlaceholder = "소개글을 작성해주세요."
    }
}
