//
//  Extension + NSAttributedString.swift
//  Peach
//
//  Created by Ildar Garifullin on 15.07.2025.
//

import UIKit

extension NSAttributedString {
    
    /// Безопасный метод для расчета размера NSAttributedString с учетом максимальной ширины
    /// Предотвращает возникновение NaN значений в CoreGraphics
    func size(consideringWidth maxWidth: CGFloat) -> CGSize {
        // Проверяем на валидность входных параметров
        guard maxWidth > 0, maxWidth.isFinite, !maxWidth.isNaN else {
            print("⚠️ Warning: Invalid maxWidth provided to size(consideringWidth:): \(maxWidth)")
            return CGSize(width: 100, height: 20) // Возвращаем безопасный размер по умолчанию
        }
        
        // Проверяем, что строка не пустая
        guard !string.isEmpty else {
            return CGSize.zero
        }
        
        // Создаем ограничивающий прямоугольник
        let constraintRect = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        
        // Вычисляем размер с помощью boundingRect
        let boundingBox = boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        
        // Проверяем результат на валидность
        let width = boundingBox.width
        let height = boundingBox.height
        
        // Убеждаемся, что значения не являются NaN или бесконечными
        let safeWidth = width.isFinite && !width.isNaN ? width : 100
        let safeHeight = height.isFinite && !height.isNaN ? height : 20
        
        // Округляем до целых пикселей для избежания проблем с отрисовкой
        let finalSize = CGSize(
            width: ceil(max(0, safeWidth)),
            height: ceil(max(0, safeHeight))
        )
        
        // Дополнительная проверка на валидность результата
        if finalSize.width.isNaN || finalSize.height.isNaN ||
           !finalSize.width.isFinite || !finalSize.height.isFinite {
            print("⚠️ Warning: Invalid size calculated in NSAttributedString.size(consideringWidth:)")
            return CGSize(width: 100, height: 20)
        }
        
        return finalSize
    }
}
