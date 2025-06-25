//
//  ExpandedSwiftUIView.swift
//  Peach
//
//  Created by Василий on 31.10.2023.
//

import SwiftUI

struct ExpandedSwiftUIView: View {

    @State var isExpanded: Bool = false

    @EnvironmentObject var viewModel: CalendarViewModelSwiftUI

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(uiImage: AssetImage.close_button_icon.image)
                    .frame(width: 5, height: 5)
                    .padding(.trailing, 15)
            }
            Image(uiImage: AssetImage.calendar_pink_frame.image)
            HStack {
                Image(uiImage: AssetImage.add_symptoms_small.image)
                    .padding(.leading)
                Button(AssetString.mark_symptoms.text) {
                    viewModel.buttonWasPressed()
                }
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color.mainPink)
                .padding(.trailing, 20)
                .frame(minWidth: 280, minHeight: 48)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.mainPink, lineWidth: 2)
            }
            .padding(.top, 10)
        }
        .padding(20)
    }
}
