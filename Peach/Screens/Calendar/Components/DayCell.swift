//
//  DayCell.swift
//  Peach
//
//  Created by Василий on 08.11.2023.
//

import SwiftUI

struct DayCell: View {

    // MARK: - Properties

    var day: DayModel

    var cellWidth: CGFloat

    var body: some View {
        switch day.state {
        case .isMenstrual:
            if day.isSelected {
                if isSymptomsContains() {
                    VStack(alignment: .center, spacing: -6) {
                        Text(day.getText())
                            .fontWeight(Font.Weight.medium)
                            .frame(width: cellWidth, height: cellWidth)
                            .foregroundColor(day.getTextColor())
                            .font(.system(size: 12))
                            .background(day.getBackgroundColor())
                            .cornerRadius(cellWidth/2)
                            .overlay(
                                RoundedRectangle(cornerRadius: (cellWidth/2))
                                    .stroke(Color.mainGray, lineWidth: 3)
                            )
                        Circle()
                            .frame(width: 4, height: 4)
                            .foregroundColor(.white)
                    }
                    .frame(width: cellWidth, height: cellWidth)
                } else {
                    Text(day.getText())
                        .fontWeight(Font.Weight.medium)
                        .frame(width: cellWidth, height: cellWidth)
                        .foregroundColor(day.getTextColor())
                        .font(.system(size: 12))
                        .background(day.getBackgroundColor())
                        .cornerRadius(cellWidth/2)
                        .overlay(
                            RoundedRectangle(cornerRadius: (cellWidth/2))
                                .stroke(Color.mainGray, lineWidth: 3)
                        )
                }
            } else {
                if isSymptomsContains() {
                    VStack(alignment: .center, spacing: -6) {
                        Text(day.getText())
                            .fontWeight(Font.Weight.medium)
                            .frame(width: cellWidth, height: cellWidth)
                            .foregroundColor(day.getTextColor())
                            .font(.system(size: 12))
                            .background(day.getBackgroundColor())
                            .cornerRadius(cellWidth/2)
                        Circle()
                            .frame(width: 4, height: 4)
                            .foregroundColor(.white)
                    }
                    .frame(width: cellWidth, height: cellWidth)
                } else {
                    Text(day.getText())
                        .fontWeight(Font.Weight.medium)
                        .frame(width: cellWidth, height: cellWidth)
                        .foregroundColor(day.getTextColor())
                        .font(.system(size: 12))
                        .background(day.getBackgroundColor())
                        .cornerRadius(cellWidth/2)
                }
            }
        case .isOvulation:
            if isSymptomsContains() {
                VStack(alignment: .center, spacing: -6) {
                    Text(day.getText())
                        .fontWeight(Font.Weight.medium)
                        .frame(width: cellWidth, height: cellWidth)
                        .foregroundColor(day.getTextColor())
                        .font(.system(size: 12))
                        .background(day.getBackgroundColor())
                        .cornerRadius(cellWidth/2)
                        .overlay(
                            RoundedRectangle(cornerRadius: cellWidth/2)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1]))
                        )
                    Circle()
                        .foregroundColor(.dotGray)
                        .frame(width: 4, height: 4)
                }
                .frame(width: cellWidth, height: cellWidth)
            } else {
                Text(day.getText())
                    .fontWeight(Font.Weight.medium)
                    .frame(width: cellWidth, height: cellWidth)
                    .foregroundColor(day.getTextColor())
                    .font(.system(size: 12))
                    .background(day.getBackgroundColor())
                    .cornerRadius(cellWidth/2)
                    .overlay(
                        RoundedRectangle(cornerRadius: cellWidth/2)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1]))
                    )
            }
        case .isMenstruationForecast:
            if isSymptomsContains() {
                VStack(alignment: .center, spacing: -6) {
                    Text(day.getText())
                        .fontWeight(Font.Weight.medium)
                        .frame(width: cellWidth, height: cellWidth)
                        .foregroundColor(day.getTextColor())
                        .font(.system(size: 12))
                        .background(day.getBackgroundColor())
                        .cornerRadius(cellWidth/2)
                        .overlay(
                            RoundedRectangle(cornerRadius: cellWidth/2)
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1]))
                                .foregroundColor(.mainPink)
                        )
                    Circle()
                        .foregroundColor(.dotGray)
                        .frame(width: 4, height: 4)
                }
                .frame(width: cellWidth, height: cellWidth)
                
            } else {
                Text(day.getText())
                    .fontWeight(Font.Weight.medium)
                    .frame(width: cellWidth, height: cellWidth)
                    .foregroundColor(day.getTextColor())
                    .font(.system(size: 12))
                    .background(day.getBackgroundColor())
                    .cornerRadius(cellWidth/2)
                    .overlay(
                        RoundedRectangle(cornerRadius: cellWidth/2)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1]))
                            .foregroundColor(.mainPink)
                    )
            }
        case .default:
            if day.isSelected {
                if isSymptomsContains() {
                    VStack(alignment: .center, spacing: -6) {
                        Text(day.getText())
                            .fontWeight(Font.Weight.medium)
                            .frame(width: cellWidth, height: cellWidth)
                            .foregroundColor(day.getTextColor())
                            .font(.system(size: 12))
                            .background(Color.mainGray)
                            .cornerRadius(cellWidth/2)
                        Circle()
                            .foregroundColor(.dotGray)
                            .frame(width: 4, height: 4)
                    }
                    .frame(width: cellWidth, height: cellWidth)
                } else {
                    Text(day.getText())
                        .fontWeight(Font.Weight.medium)
                        .frame(width: cellWidth, height: cellWidth)
                        .foregroundColor(day.getTextColor())
                        .font(.system(size: 12))
                        .background(Color.mainGray)
                        .cornerRadius(cellWidth/2)
                }
            } else {
                if isSymptomsContains() {
                    VStack(alignment: .center, spacing: -6) {
                        Text(day.getText())
                            .fontWeight(Font.Weight.medium)
                            .frame(width: cellWidth, height: cellWidth)
                            .foregroundColor(day.getTextColor())
                            .font(.system(size: 12))
                            .background(day.getBackgroundColor())
                            .cornerRadius(cellWidth/2)
                        Circle()
                            .frame(width: 4, height: 4)
                            .foregroundColor(.dotGray)
                    }
                    .frame(width: cellWidth, height: cellWidth)
                } else {
                    Text(day.getText())
                        .fontWeight(Font.Weight.medium)
                        .frame(width: cellWidth, height: cellWidth)
                        .foregroundColor(day.getTextColor())
                        .font(.system(size: 12))
                        .background(day.getBackgroundColor())
                        .cornerRadius(cellWidth/2)
                }
            }
        }
    }

    private func isSymptomsContains() -> Bool {
        return day.symptoms != nil
    }
}
