//
//  SwiftUI+Extension.swift
//  Mingdalart
//
//  Created by YuSeongChoi on 1/28/26.
//

import SwiftUI

import RswiftResources

extension View {
    func dismissKeyboardOnTap() -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture {
                UIApplication.shared.sendAction(
                    #selector(UIResponder.resignFirstResponder),
                    to: nil,
                    from: nil,
                    for: nil
                )
            }
    }
}

extension Text {
    func notoSansReg(size: CGFloat) -> Text {
        self.font(R.font.notoSansCJKkrRegular.swiftFontOfSize(size))
    }

    func notoSansMid(size: CGFloat) -> Text {
        self.font(R.font.notoSansCJKkrMedium.swiftFontOfSize(size))
    }

    func notoSansBold(size: CGFloat) -> Text {
        self.font(R.font.notoSansCJKkrBold.swiftFontOfSize(size))
    }

    func latoReg(size: CGFloat) -> Text {
        self.font(R.font.latoRegular.swiftFontOfSize(size))
    }

    func latoBold(size: CGFloat) -> Text {
        self.font(R.font.latoBold.swiftFontOfSize(size))
    }

    func pretendBold(size: CGFloat) -> Text {
        self.font(R.font.pretendardBold.swiftFontOfSize(size))
    }

    func pretendSemiBold(size: CGFloat) -> Text {
        self.font(R.font.pretendardSemiBold.swiftFontOfSize(size))
    }

    func pretendMid(size: CGFloat) -> Text {
        self.font(R.font.pretendardMedium.swiftFontOfSize(size))
    }

    func pretendReg(size: CGFloat) -> Text {
        self.font(R.font.pretendardRegular.swiftFontOfSize(size))
    }
}

extension View {
    func notoSansReg(size: CGFloat) -> some View {
        self.font(R.font.notoSansCJKkrRegular.swiftFontOfSize(size))
    }

    func notoSansMid(size: CGFloat) -> some View {
        self.font(R.font.notoSansCJKkrMedium.swiftFontOfSize(size))
    }

    func notoSansBold(size: CGFloat) -> some View {
        self.font(R.font.notoSansCJKkrBold.swiftFontOfSize(size))
    }

    func latoReg(size: CGFloat) -> some View {
        self.font(R.font.latoRegular.swiftFontOfSize(size))
    }

    func latoBold(size: CGFloat) -> some View {
        self.font(R.font.latoBold.swiftFontOfSize(size))
    }

    func pretendSemiBold(size: CGFloat) -> some View {
        self.font(R.font.pretendardSemiBold.swiftFontOfSize(size))
    }

    func pretendBold(size: CGFloat) -> some View {
        self.font(R.font.pretendardBold.swiftFontOfSize(size))
    }

    func pretendMid(size: CGFloat) -> some View {
        self.font(R.font.pretendardMedium.swiftFontOfSize(size))
    }

    func pretendReg(size: CGFloat) -> some View {
        self.font(R.font.pretendardRegular.swiftFontOfSize(size))
    }
}
