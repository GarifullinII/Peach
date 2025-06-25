//
//  Extension + UICollectionView.swift
//  Peach
//
//  Created by Василий on 13.09.2023.
//

import UIKit

extension UICollectionView {

    // MARK: - Nested types

    enum Kind {
        case header
        case footer

        var viewType: String {
            switch self {
            case .header:
                return "UICollectionElementKindSectionHeader"
            case .footer:
                return "UICollectionElementKindSectionFooter"
            }
        }
    }

    func registerCell(type: UICollectionViewCell.Type, for reuseIdentifier: String? = nil) {
        let cellID = type.reuseIdentifier
        register(type, forCellWithReuseIdentifier: reuseIdentifier ?? cellID)
    }

    func dequeueCell<T: UICollectionViewCell>(withType type: T.Type = T.self, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: type.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(type.reuseIdentifier) matching type \(type.self).")
        }
        return cell
    }

    // MARK: - Header/Footer

    func register<T: UICollectionReusableView>(view: T.Type) {
        register(T.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableView<T: Reusable>(for indexPath: IndexPath, viewType: T.Type = T.self, kind: Kind) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind.viewType,
            withReuseIdentifier: viewType.reuseIdentifier,
            for: indexPath) as? T else {
            fatalError("Failed to dequeue a view with identifier \(viewType.reuseIdentifier) matching type \(viewType.self).")
        }
        return view
    }
}
