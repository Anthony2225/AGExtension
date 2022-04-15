//
//  AG_UIImageView_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/22.
//

import Foundation
import UIKit

// MARK: ===================================工具类:UIiamgeView 类的拓展和补充=========================================


public extension UIImageView {
    
    convenience init(image: UIImage? = nil , contentMede: ContentMode = .scaleAspectFill) {
        self.init(frame: .zero)
        self.image = image
        self.contentMode = contentMode
    }
    
    
    
}
