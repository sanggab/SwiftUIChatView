//
//  Model.swift
//  SwiftUIChatView
//
//  Created by Gab on 2024/04/19.
//

import SwiftUI
import SwiftyJSON

@frozen
public enum MessageTabType: Hashable {
    case chat
    case profile
}

@frozen
public enum MessageType: Int, Codable, Hashable {
    case text = 0
    case gif = 10
    case stt = 12
    case like = 13
    case up = 14
    case expired = -999
}

@frozen
public enum MessageSendType: Int, Codable, Hashable {
    case send = 0
    case receive = 1
}

/// 좋아요 구분
public enum LikeSlct: String, Codable, Equatable, Hashable {
    /// 사진
    case picture    = "b"
    /// 동영상
    case video      = "c"
    /// 소개글
    case aboutMe    = "d"
}

/// 좋아요 콘텐츠 ( 코멘트 / 사진 URL / 영상 URL 등 )
public struct LikeConts: Codable, Equatable, Hashable {
    
    public static let empty = LikeConts(likeSlct: .picture, comment: "", commentYn: "n", aboutMe: "", delYn: "n", delChrgrYn: "n", memLang: "ko", transYn: "n")
    
    /// 좋아요 구분 [b: 사진, c: 동영상, d:소개글]
    public var likeSlct: LikeSlct
    /// 코멘트
    public var comment: String
    /// 코멘트 작성 여부 (작성: y / 미작성: n)
    public var commentYn: String
    /// 자기소개글
    public var aboutMe: String
    /// 좋아요 미디어 정보
    public var media: MediaModel?
    /// 사진,영상,자기소개글 삭제 여부
    public var delYn: String
    /// 관리자 삭제 여부 ["y"일 경우 대체이미지 출력]
    public var delChrgrYn: String
    /// 사용자 언어코드
    public var memLang: String
    /// 번역된 값 유무 [ "y" : 번역 코멘트 존재 / "n" : 번역 코멘트 없음 ]
    public var transYn: String
    /// 번역된 코멘트 값
    public var transComment: String?
    
    public init(likeSlct: LikeSlct,
                comment: String,
                commentYn: String,
                aboutMe: String,
                media: MediaModel? = nil,
                delYn: String,
                delChrgrYn: String,
                memLang: String,
                transYn: String,
                transComment: String? = nil) {
        self.likeSlct = likeSlct
        self.comment = comment
        self.commentYn = commentYn
        self.aboutMe = aboutMe
        self.media = media
        self.delYn = delYn
        self.delChrgrYn = delChrgrYn
        self.memLang = memLang
        self.transYn = transYn
        self.transComment = transComment
    }
    
    enum CodingKeys: CodingKey {
        case likeSlct
        case comment
        case commentYn
        case aboutMe
        case media
        case delYn
        case delChrgrYn
        case memLang
        case transYn
        case transComment
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<LikeConts.CodingKeys> = try decoder.container(keyedBy: LikeConts.CodingKeys.self)
        
        self.likeSlct = try container.decode(LikeSlct.self, forKey: LikeConts.CodingKeys.likeSlct)
        self.comment = try container.decode(String.self, forKey: LikeConts.CodingKeys.comment)
        self.commentYn = try container.decode(String.self, forKey: LikeConts.CodingKeys.commentYn)
        self.aboutMe = try container.decode(String.self, forKey: LikeConts.CodingKeys.aboutMe)
        self.media = try container.decodeIfPresent(MediaModel.self, forKey: LikeConts.CodingKeys.media)
        self.delYn = try container.decode(String.self, forKey: LikeConts.CodingKeys.delYn)
        self.delChrgrYn = try container.decode(String.self, forKey: LikeConts.CodingKeys.delChrgrYn)
        self.memLang = try container.decode(String.self, forKey: LikeConts.CodingKeys.memLang)
        self.transYn = try container.decode(String.self, forKey: LikeConts.CodingKeys.transYn)
        self.transComment = try container.decodeIfPresent(String.self, forKey: LikeConts.CodingKeys.transComment)
    }
}

public extension LikeConts {
    func getComment() -> String {
        if commentYn == "y" {
            return comment
        } else {
            switch likeSlct {
            case .picture:
                return "Liked your Photo"
            case .video:
                return "Liked your Video"
            case .aboutMe:
                return "Liked your \"About me\""
            }
        }
    }
}

public struct MediaModel: Codable, Hashable, Identifiable {
    
    public init(id: MediaModel.ID, mediaUrl: String, thumbnailUrl: String? = nil, mediaType: MediaModel.MediaType, verificationYn: String, representativeYn: String) {
        self.id = id
        self.mediaUrl = mediaUrl
        self.thumbnailUrl = thumbnailUrl
        self.mediaType = mediaType
        self.verificationYn = verificationYn
        self.representativeYn = representativeYn
    }
    
    public typealias ID = Int
    
    public var id: ID
    /// url
    public var mediaUrl: String
    /// 썸네일 (사진일 경우 빈스트링 혹은 null)
    public var thumbnailUrl: String?
    /// video | photo | audio
    public var mediaType: MediaType
    /// 인증여부
    public var verificationYn: String
    /// 대표사진 여부
    public var representativeYn: String
    
    public enum MediaType: Codable, Equatable, Hashable {
        case video
        case photo
        case audio
        case none
    }
}


@frozen
public struct MessageChatListModel: Codable, Hashable {
    public static let empty = MessageChatListModel(msgNo: 0, memNo: 0, ptrMemNo: 0, msgType: .text, sendType: .send, msgCont: "", insDate: 0, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n", resendYn: false)
    
    public var msgNo: Int
    public var memNo: Int
    public var ptrMemNo: Int
    public var msgType: MessageType
    public var sendType: MessageSendType
    public var msgCont: String
    public var insDate: Int
    public var readYn: String
    public var msgLang: String
    public var myMsgCont: String
    public var msgEtc: MessageEtcModel
    public var delYn: String
    public var resendYn: Bool = false
    
    public init(msgNo: Int,
                memNo: Int,
                ptrMemNo: Int,
                msgType: MessageType,
                sendType: MessageSendType,
                msgCont: String,
                insDate: Int,
                readYn: String,
                msgLang: String,
                myMsgCont: String,
                msgEtc: MessageEtcModel,
                delYn: String,
                resendYn: Bool = false) {
        self.msgNo = msgNo
        self.memNo = memNo
        self.ptrMemNo = ptrMemNo
        self.msgType = msgType
        self.sendType = sendType
        self.msgCont = msgCont
        self.insDate = insDate
        self.readYn = readYn
        self.msgLang = msgLang
        self.myMsgCont = myMsgCont
        self.msgEtc = msgEtc
        self.delYn = delYn
        self.resendYn = resendYn
    }
}

public extension MessageChatListModel {
    
    static func makeList() -> [MessageChatListModel] {
        return [
            MessageChatListModel(msgNo: 0, memNo: 7, ptrMemNo: 293, msgType: .like, sendType: .send, msgCont: "", insDate: 1710311216, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .init(gifModel: .empty, likeConts: .init(likeSlct: .picture, comment: "당신의 사진이 매우 맘에 들어요!!", commentYn: "y", aboutMe: "", media: MediaModel(id: 0, mediaUrl: "https://image.fmkorea.com/files/attach/new2/20211014/1378413927/3362411706/3991669528/2edea53c4c5aba0b373f10f419e7e48d.png", mediaType: .photo, verificationYn: "", representativeYn: ""), delYn: "n", delChrgrYn: "n", memLang: "ko", transYn: "n", transComment: "")), delYn: "n"),
            
            MessageChatListModel(msgNo: 1, memNo: 7, ptrMemNo: 293, msgType: .like, sendType: .receive, msgCont: "", insDate: 1710311322, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .init(gifModel: .empty, likeConts: .init(likeSlct: .picture, comment: "", commentYn: "n", aboutMe: "", media: MediaModel(id: 1, mediaUrl: "https://blog.kakaocdn.net/dn/bc7cmf/btrokpKKQUS/K656VyWoFsasEd0FxwXTu0/img.png", mediaType: .photo, verificationYn: "", representativeYn: ""), delYn: "n", delChrgrYn: "n", memLang: "ko", transYn: "n", transComment: "")), delYn: "n"),
            
            MessageChatListModel(msgNo: 2, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .send, msgCont: "안녕하세요 반갑습니다", insDate: 1710311342, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
//
            MessageChatListModel(msgNo: 3, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .receive, msgCont: "네 저도 반가워요", insDate: 1710311348, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
//
            MessageChatListModel(msgNo: 4, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .send, msgCont: "실패하면 반역", insDate: 1710311364, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 5, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .send, msgCont: "성공하면 혁명 아입니까", insDate: 1710311364, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 6, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .receive, msgCont: "퇴근 47분전", insDate: 1710311370, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 7, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .receive, msgCont: "아 퇴근하고싶다", insDate: 1710311370, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 8, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .send, msgCont: "UI테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용테스트용", insDate: 1710311374, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 9, memNo: 7, ptrMemNo: 293, msgType: .text, sendType: .receive, msgCont: "하잇", insDate: 1710311376, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 10, memNo: 7, ptrMemNo: 293, msgType: .stt, sendType: .send, msgCont: "이것은 내가 보낸 STT 메시지다.", insDate: 1710311386, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 11, memNo: 7, ptrMemNo: 293, msgType: .stt, sendType: .receive, msgCont: "이것은 상대방이 보낸 STT 메시지다.", insDate: 1710311400, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
            
            MessageChatListModel(msgNo: 12, memNo: 7, ptrMemNo: 293, msgType: .gif, sendType: .receive, msgCont: "", insDate: 1710311422, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .init(gifModel: .init(gifUrl: "https://cdn-lostark.game.onstove.com/uploadfiles/user/2022/08/24/637969463546229330.gif", gifWidth: 200, gifHeight: 200), likeConts: .empty), delYn: "n"),
            
            MessageChatListModel(msgNo: 13, memNo: 7, ptrMemNo: 293, msgType: .gif, sendType: .send, msgCont: "", insDate: 1710311423, readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .init(gifModel: .init(gifUrl: "https://blog.kakaocdn.net/dn/cGMWdA/btroIUuSPIG/0KzZcEXLhUS49sr8LVkDY1/img.gif", gifWidth: 200, gifHeight: 200), likeConts: .empty), delYn: "n"),
            
            MessageChatListModel(msgNo: 14, memNo: 7, ptrMemNo: 293, msgType: .stt, sendType: .receive, msgCont: "이것은 날짜 다르게 가져가", insDate: Int(Date().timeIntervalSince1970), readYn: "n", msgLang: "ko", myMsgCont: "", msgEtc: .empty, delYn: "n"),
        ]
    }
}

public struct MessageEtcModel: Codable, Hashable {
    public static let empty = MessageEtcModel(gifModel: .empty, likeConts: .empty)
    
    public var gifModel: MessageGifModel
    public var likeConts: LikeConts
    
    public init(gifModel: MessageGifModel,
                likeConts: LikeConts) {
        self.gifModel = gifModel
        self.likeConts = likeConts
    }
}

public struct MessageGifModel: Codable, Hashable {
    public static let empty = MessageGifModel(gifUrl: "", gifWidth: 0, gifHeight: 0)
    
    public var gifUrl: String
    public var gifWidth: Int
    public var gifHeight: Int
    
    public init(gifUrl: String,
                gifWidth: Int,
                gifHeight: Int) {
        self.gifUrl = gifUrl
        self.gifWidth = gifWidth
        self.gifHeight = gifHeight
    }
}

