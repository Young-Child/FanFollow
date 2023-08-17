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
        
        // Explore Scene
        static let categoryTitle = "카테고리로 보기"
        static let recommendCreatorTitleFormat = "추천 %@ 크리에이터"
        static let creatorFormat = " %@ 크리에이터"
        static let searchPlaceHolder = "크리에이터의 닉네임을 검색해보세요."
        static let noSearchResult = "검색 결과가 없습니다."

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
        static let creatorInformationTitle = "소개 및 상세 정보는 크리에이터만 수정할 수 있습니다."
        static let introduce = "소개"
        static let profileEdit = "프로필 편집"
        static let developerEmails = ["dlrudals8899@gmail.com", "hyosing92@gmail.com", "junho_l@kakao.com"]
        static let bugReportMailTitle = "<팬팔> 문의 및 버그 제보하기"
        static let bugReportErrorAlertTitle = "메일 앱 오류"
        static let bugReportErrorAlertMessage = "메일 앱을 설정해주세요."
        static let bugReportMailFormat = """
        서비스를 이용하시는데 불편을 드려서 죄송합니다.
        발생하신 버그에 대해서 이곳에 작성해주세요.
        ---------------

        Device OS: %@
        App Version: %@

        ---------------
        """

        // Feed Scene
        static let editMessage = "수정하기"
        static let deleteMessage = "삭제하기"
        
        // ProfileFeed Scene
        static let follower = "팔로워 "
        static let personUnit = "명"
        static let followButtonTitle = "팔로우"
        static let unfollowButtonTitle = "팔로잉"
        
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
