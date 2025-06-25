//
//  ExpandedView.swift
//  Peach
//
//  Created by Василий on 31.10.2023.
//

import SwiftUI

struct ExpandedView: View {

    // MARK: - Properties

    @EnvironmentObject var viewModel: CalendarViewModel

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(uiImage: AssetImage.close_button_icon.image)
                    .frame(width: 5, height: 5)
                    .padding(.trailing, 15)
            }
            InnerFrameView()
            HStack(spacing: 10) {
                Image(uiImage: AssetImage.add_symptoms_small.image)
                Text(AssetString.mark_symptoms.text)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.mainPink)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.mainPink, lineWidth: 2)
                    .frame(minWidth: 330, minHeight: 48)
            }
            .onTapGesture {
                viewModel.showSymptomsAction()
            }
            .padding()
        }
        .padding(20)
    }
}
