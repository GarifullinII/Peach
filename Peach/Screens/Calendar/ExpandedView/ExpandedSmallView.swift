//
//  ExpandedSmallView.swift
//  Peach
//
//  Created by Василий on 09.11.2023.
//

import SwiftUI

struct ExpandedSmallView: View {

    // MARK: - Properties

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(uiImage: AssetImage.close_button_icon.image)
                    .frame(width: 5, height: 5)
                    .padding(.trailing, 25)
            }
        }
    }
}
