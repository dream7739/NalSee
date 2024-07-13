//
//  Error.swift
//  NalSee
//
//  Created by 홍정민 on 7/13/24.
//

import Foundation

enum JsonParseError: Error {
    case failFileLocation
    case failDataParse
    case failDataDecoding
}

extension JsonParseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failFileLocation:
            return "파일을 찾을 수 없습니다."
        case .failDataParse:
            return "데이터를 변환하지 못했습니다."
        case .failDataDecoding:
            return "데이터 디코딩에 실패하였습니다."
        }
    }
}
