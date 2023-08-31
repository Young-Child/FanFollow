//
//  Constants.swift
//  FanFollow
//
//  Copyright (c) 2023 Minii All rights reserved.

import UIKit

enum Constants {
    enum Text {
        // Login Scene
        static let appleLoginButtonText = "Apple로 계속하기"
        static let onboardingMainText = NSMutableAttributedString()
            .regular("모든 ")
            .highlight("직군", to: Constants.Color.blue)
            .regular("의 이야기")
        static let onboardingSubText = "나와 같은 사람들의 생각, 기록, 네트워킹"
        static let onboardingInformation = "추후 더 많은 로그인 기능을 제공할 예정입니다."
        static let loginAlertTitle = "로그인 오류"
        static let loginAlertMessage = "로그인에 실패하였습니다. 잠시후 다시 시도해주세요."
        static let privacyFormat = "가입과 동시에 %@과 %@에 동의하게 됩니다."
        static let privacyName = "개인정보 처리 방침"
        static let agreementName = "서비스 이용정책"
        
        // Explore Scene
        static let categoryTitle = "카테고리로 보기"
        static let recommendCreatorTitleFormat = "추천 %@ 크리에이터"
        static let creatorFormat = " %@ 크리에이터"
        static let searchPlaceHolder = "크리에이터의 닉네임을 검색해보세요."
        static let noSearchResult = "검색 결과가 없습니다."
        static let noSubscribeResult = "구독 중인 크리에이터가 없습니다."

        // Setting Scene
        static let registerCreatorSectionTitle = "크리에이터 신청"
        static let customerServiceSectionTitle = "고객 센터"
        static let accountSectionTitle = "계정 설정"
        static let bugReportMenuTitle = "버그 제보하기"
        static let evaluationMenuTitle = "평가하기"
        static let privacyMenuTitle = "개인 정보 처리 방침"
        static let openSourceMenuTitle = "오픈 소스 라이센스 고지"
        static let logOutMenuTitle = "로그아웃"
        static let withdrawalMenuTitle = "탈퇴하기"
        static let withdrawalTitle = "회원탈퇴"
        static let withdrawalNotice = "탈퇴 시, 회원 정보 및 모든 서비스의 이용내역이 삭제됩니다. 삭제된 데이터는 복구가 불가능합니다."
        static let withdrawalAgree = "회원탈퇴에 관한 모든 내용을 숙지하였고, 회원탈퇴를 신청합니다."
        static let withdrawal = "회원탈퇴하기"
        static let logOutAlertMessage = "로그아웃하시겠습니까?"
        static let logOut = "로그아웃"
        static let introduceInputViewPlaceholder = "소개글을 작성해주세요."
        static let inputMessage = "입력을 완료해주세요."
        static let imageSelectTitle = "이미지 선택"
        static let nickNameInformationTitle = "닉네임은 공백 포함 10글자까지 입력할 수 있습니다."
        static let creatorInformationTitle = "소개 및 상세 정보는 크리에이터만 수정할 수 있습니다."
        static let introduce = "소개"
        static let profileEdit = "프로필 편집"
        static let developerEmails = [
            "dlrudals8899@gmail.com",
            "hyosing92@gmail.com",
            "junho_l@kakao.com"
        ]
        static let bugReportMailTitle = "<팬팔> 문의 및 버그 제보하기"
        static let mailErrorAlertTitle = "메일 앱 오류"
        static let mailErrorAlertMessage = "메일 앱을 설정해주세요."
        static let bugReportMailFormat = """
        팬팔 서비스를 이용하시는데 불편을 드려서 죄송합니다.
        발생하신 버그에 대해서 이곳에 작성해주세요.
        ---------------

        Device OS: %@
        App Version: %@

        ---------------
        """
        
        static let creatorAgreementInformation = """
        다음과 같은 내용을 포함하는 게시글을 작성하는 경우 해당 서비스를 이용할 수 없습니다.

        • 음란물을 포함하거나 매춘, 인신매매 및 착취를 조장하는 콘텐츠
        
        • 선동적인 종교적 논평 또는 부정확하거나 오해의 소지가 있는 종교적 텍스트를 인용하는 콘텐츠
        
        • 폭력적 분쟁, 테러 공격, 전염병 등 최근 또는 현재의 사건을 이용하여 이익을 얻으려는 유해한 콘텐츠
        
        • 불법적이고, 무모한 무기 및 위험한 물건의 사용을 조장하거나 총기 또는 탄약의 구매를 촉진하는 콘텐츠
        
        • 사람이나 동물이 살해, 불구, 고문, 학대당하는 모습을 사실적으로 묘사하거나 폭력을 조장하는 콘텐츠
        
        • 종교, 인종, 성적 지향, 성별, 국가/민족 출신 또는 기타 대상 그룹에 대한 언급이나 논평을 포함하여 명예를 훼손하거나 차별적인 콘텐츠
        
        사용자의 게시물은 신고에 따라 (팬팔)의 확인 후, 어떠한 안내도 없이 삭제 될 수 있으며, 계정이용에 제한이 있을 수 있습니다.
        """
        
        static let creatorAgreement = "위의 이용 약관에 동의합니다."
        
        // Feed Scene
        static let editMessage = "수정하기"
        static let deleteMessage = "삭제하기"
        static let declaration = "신고하기"
        static let declarationMailFormat = """
        서비스를 이용하시는데 불편을 드려서 죄송합니다.
        불쾌감을 느끼신 게시물에 대해서 이곳에 작성해주세요.
        
        • 신고 후 삭제는 최대 24시간이 소요될 수 있습니다.
        • 신고한 게시물의 내용이 부적절한 경우에만 삭제됩니다.
        ---------------

        %@ 고유 번호: %@

        ---------------
        """
        
        static let declarationMailTitle = "<팬팔> 게시글 신고하기"
        static let noFeedResult = "탐색으로 이동해서 크리에이터를 구독해보세요!"
        static let blockUserTitle = "사용자 차단"
        static let blockUserInformations: [String] = [
            "사용자의 게시물이 노출되지 않습니다.",
            "사용자가 노출되지 않습니다.",
            "설정에서 차단을 해제할 수 있습니다."
        ]
        
        // ProfileFeed Scene
        static let follower = "팔로워 "
        static let personUnit = "명"
        static let followButtonTitle = "팔로우"
        static let unfollowButtonTitle = "팔로잉"
        static let noProfileFeedResult = "등록된 게시물이 없습니다."
        
        // Upload Scene
        static let uploadTitle = "게시물 업로드"
        static let photo = "사진"
        static let linkPlaceholder = "링크를 입력해주세요."
        static let titlePlaceholder = "제목을 입력해주세요."
        static let contentPlaceholder = "내용을 입력해주세요."
        static let http = "https://"
        static let registerPost = "게시물 작성"
        static let link = "링크"
        static let title = "제목"
        static let content = "내용"

        // Common Scene
        static let confirm = "확인"
        static let cancel = "취소"
        static let jobCategory = "직군"
        static let hashTag = "#"
        static let recommand = "추천"
        static let complete = "완료"
        static let declare = "신고"
        static let block = "차단"
        static let next = "다음"
        static let nickName = "닉네임"
        static let setting = "설정"
        static let feed = "피드"
        static let feedManage = "피드 관리"
        static let explore = "탐색"
        static let mySubscribe = "나의 구독"
        static let photoAccessAlertTitle = "사진 권한을 변경해주세요."
        static let photoAccessAlertMessage = "설정 > 팬팔에서 사진 접근 권한을 변경해주세요"
        static let appStoreURL: String = "itms-apps://itunes.apple.com/app/6450774849"
        static let privacyInformationURL: String
        = "https://modacorp.notion.site/3d086d62036949888b408f0a3c2ab7d9?pvs=4"
        static let agreementInformationURL: String
        = "https://modacorp.notion.site/33c9516763224bbab348540998fec88f?pvs=4"
    }
    
    enum Image {
        // Asset Image
        static let logoImageSmall = UIImage(named: "iconImageSmall")
        static let logoImageMiddle = UIImage(named: "iconImageMiddle")
        static let logoImageLarge = UIImage(named: "iconIageLarge")
        static let appleLogo = UIImage(named: "Apple")
        
        // Tab Symbol Icon
        static let feed = UIImage(systemName: "newspaper")
        static let explore = UIImage(systemName: "binoculars")
        static let setting = UIImage(systemName: "gearshape.2")
        static let feedFill = UIImage(systemName: "newpaper.fill")
        static let exploreFill = UIImage(systemName: "binoculars.fill")
        static let settingFill = UIImage(systemName: "gearshape.2.fill")
        
        // SF Symbol Icon
        static let plus = UIImage(systemName: "plus")
        static let plusCircle = UIImage(systemName: "plus.circle")
        static let minusCircle = UIImage(systemName: "minus.circle")
        static let magnifyingGlass = UIImage(systemName: "magnifyingglass")
        static let back = UIImage(systemName: "chevron.backward")
        static let xmark = UIImage(systemName: "xmark")
        static let xmarkCircle = UIImage(systemName: "xmark.circle")
        static let heart = UIImage(systemName: "heart")
        static let heartFill = UIImage(systemName: "heart.fill")
        static let more = UIImage(systemName: "ellipsis")
        static let photo = UIImage(systemName: "photo.fill.on.rectangle.fill")
        static let link = UIImage(systemName: "link.badge.plus")
        static let checkMark = UIImage(systemName: "checkmark.square.fill")
        static let square = UIImage(systemName: "square")
    }
    
    enum Color {
        static let blue = UIColor.rgba(red: 6, green: 74, blue: 203, alpha: 1)
        static let blueDisabled = UIColor.rgba(red: 90, green: 129, blue: 203, alpha: 1)
        static let background = UIColor.systemBackground
        static let grayDark = UIColor.systemGray2
        static let gray = UIColor.systemGray5
        static let clear = UIColor.clear
        static let label = UIColor.label
        
        static let warningColor = UIColor(named: "AlertColor")
    }
    
    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 32
        static let xLarge: CGFloat = 64
    }
}
