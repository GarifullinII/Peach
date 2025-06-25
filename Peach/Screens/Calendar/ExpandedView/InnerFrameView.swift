//
//  InnerFrameView.swift
//  Peach
//
//  Created by Василий on 09.11.2023.
//

import SwiftUI

struct InnerFrameView: View {

    // MARK: - Properties

    @EnvironmentObject var viewModel: CalendarViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {
            Image(uiImage: viewModel.image) // Замените "backgroundImage" на имя своего изображения
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)

            VStack(alignment: .leading, spacing: 5) {
                Spacer().frame(height: 5)
                HStack(spacing: 0) {
                    Spacer().frame(width: 0)
                    Text(viewModel.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                }

                Text(viewModel.subTitle)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(viewModel.color)

                HStack(spacing: 0) {
                    Spacer().frame(width: 0)
                    Button(viewModel.buttonText) {
                        viewModel.isModelAreRefreshing.toggle()
                    }
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.all, 12)
                    .background(viewModel.color)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
