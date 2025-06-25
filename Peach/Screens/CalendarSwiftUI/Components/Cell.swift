//
//  Cell.swift
//  Peach
//
//  Created by Василий on 30.10.2023.
//

import SwiftUI

struct RKCell: View {

    // MARK: - Properties

    var rkDate: RKDate

    var cellWidth: CGFloat

    var body: some View {
        Text(rkDate.getText())
            .fontWeight(rkDate.getFontWeight())
            .foregroundColor(rkDate.getTextColor())
            .frame(width: cellWidth, height: cellWidth)
            .font(.system(size: 12))
            .background(rkDate.getBackgroundColor())
            .cornerRadius(cellWidth/2)
    }
}
