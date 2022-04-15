//
//  AG_UIGestureRecognizer_Extension.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/22.
//

import Foundation
import UIKit


public extension UITapGestureRecognizer {
    
    convenience init(actionClosures: @escaping () -> Void) {
        self.init()
        
        let tac = Ag_TapAction(actionClosures)
        objc_setAssociatedObject(self, &AssociatedKeys.agTapAssociatedKey, tac, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        addTarget(tac, action: #selector(Ag_TapAction.tapAcitonFunc))
        
        
    }
    
    private class Ag_TapAction{
        var __action:() -> Void
        init(_ action: @escaping () -> Void) {
            __action = action
        }
        
        @objc func tapAcitonFunc(){
            __action()
        }
    }
    
    private struct AssociatedKeys {
        static var agTapAssociatedKey = "agTapAssociatedKey"
    }
    
}
