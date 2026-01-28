//
//  MingdalartResources.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/28/26.
//

import Foundation
import CoreText
import RswiftResources

typealias MingdalartFont = _R.font

extension MingdalartFont {
    static func register() throws {
        let filteredFonts = R.font.filter { $0.canBeLoaded() }
        guard !filteredFonts.isEmpty else { return }
        var errorArray = [Error]()
        errorArray.reserveCapacity(filteredFonts.count)
        let fontURLs: [URL] = filteredFonts.compactMap {
            guard let url = $0.bundle.url(forResource: $0.filename, withExtension: nil) else {
                errorArray.append(
                    CocoaError(
                        .fileNoSuchFile,
                        userInfo: [
                            NSLocalizedDescriptionKey: "\($0.filename)을 찾을 수 없습니다. \($0.bundle.bundlePath)에 해당 파일이 존재하지 않습니다."
                        ]
                    )
                )
                return nil
            }
            return url
        }

        for url in fontURLs {
            var registerError: Unmanaged<CFError>?
            let registered = CTFontManagerRegisterFontsForURL(url as CFURL, .process, &registerError)
            if !registered, let error = registerError?.takeRetainedValue() {
                errorArray.append(error)
            }
        }

        if let error = errorArray.first {
            throw error
        }
    }
}
