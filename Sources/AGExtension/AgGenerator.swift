//
//  AgGenerator.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/24.
//  来自:https://github.com/WorldDownTown/TapticEngine

import Foundation
import UIKit

// MARK: ===================================工具类:震动反馈 =========================================

/// 震动反馈
public class AgGenerator{
    
    // Triggers an impact feedback between small, light user interface elements. (`UIImpactFeedbackStyle.light`)
    /// 触发小而轻的用户界面元素之间的冲击反馈
    public static func ag_Light() {
        TapticEngine.impact.feedback(.light)
    }
    
    // Triggers an impact feedback between moderately sized user interface elements. (`UIImpactFeedbackStyle.medium`)
    /// 触发中等大小的用户界面元素之间的影响反馈
    public static func ag_Medium() {
        TapticEngine.impact.feedback(.medium)
    }
    
    // Triggers an impact feedback between large, heavy user interface elements.  (`UIImpactFeedbackStyle.heavy`)
    /// 触发大型、繁重的用户界面元素之间的冲击反馈
    public static func ag_Heavy() {
        TapticEngine.impact.feedback(.heavy)
    }
    
    
    
    public static func ag_Soft() {
        if #available(iOS 13.0, *) {
            TapticEngine.impact.feedback(.soft)
        }else {
            return
        }
    }
    public static func ag_Rigid() {
        if #available(iOS 13.0, *) {
            TapticEngine.impact.feedback(.rigid)
        }else {
            return
        }
    }
    
    
    
    // Triggers a selection feedback to communicate movement through a series of discrete values.
    /// 触发选择反馈，通过一系列离散值传达移动
    public static func ag_Selection() {
        TapticEngine.selection.feedback()
    }
    
    // Triggers a notification feedback, indicating that a task has completed successfully. (`UINotificationFeedbackType.success`)
    // 触发通知反馈，指示任务已成功完成
    public static func ag_Success() {
        TapticEngine.notification.feedback(.success)
    }
    
    // Triggers a notification feedback, indicating that a task has produced a warning. (`UINotificationFeedbackType.warning`)
    /// 触发通知反馈，指示任务已生成警告
    public static func ag_Warning() {
        TapticEngine.notification.feedback(.warning)
    }
    
    // Triggers a notification feedback, indicating that a task has failed. (`UINotificationFeedbackType.error`)
    /// 触发通知反馈，指示任务已失败
    public static func ag_Error() {
        TapticEngine.notification.feedback(.error)
    }
}

public class TapticEngine {
    public static let impact: Impact = .init()
    public static let selection: Selection = .init()
    public static let notification: Notification = .init()
    
    /// Wrapper of `UIImpactFeedbackGenerator`
    public class Impact {
        /// Impact feedback styles
        ///
        /// - light: A impact feedback between small, light user interface elements.
        /// - medium: A impact feedback between moderately sized user interface elements.
        /// - heavy: A impact feedback between large, heavy user interface elements.
        public enum ImpactStyle {
            case light
            case medium
            case heavy
            
            @available(iOS 13.0, *)
            case soft

            @available(iOS 13.0, *)
            case rigid
        }
        
        private var style: ImpactStyle = .light
        private var generator: Any? = Impact.makeGenerator(.light)
        
        private static func makeGenerator(_ style: ImpactStyle) -> Any? {
            let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
            switch style {
            case .light:
                feedbackStyle = .light
            case .medium:
                feedbackStyle = .medium
            case .heavy:
                feedbackStyle = .heavy
            case .soft:
                if #available(iOS 13.0, *) {
                    feedbackStyle = .soft
                } else {
                    feedbackStyle = .medium
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    feedbackStyle = .rigid
                } else {
                    feedbackStyle = .medium
                }
            }
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.prepare()
            return generator
        }
        
        private func updateGeneratorIfNeeded(_ style: ImpactStyle) {
            guard self.style != style else { return }
            generator = Impact.makeGenerator(style)
            self.style = style
        }
        
        public func feedback(_ style: ImpactStyle) {
            updateGeneratorIfNeeded(style)
            guard let generator = generator as? UIImpactFeedbackGenerator else { return }
            generator.impactOccurred()
            generator.prepare()
        }
        
        public func prepare(_ style: ImpactStyle) {
            updateGeneratorIfNeeded(style)
            guard let generator = generator as? UIImpactFeedbackGenerator else { return }
            generator.prepare()
        }
    }
    
    
    /// Wrapper of `UISelectionFeedbackGenerator`
    public class Selection {
        private var generator: Any? = {
            let generator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
            generator.prepare()
            return generator
        }()
        
        public func feedback() {
            guard let generator = generator as? UISelectionFeedbackGenerator else { return }
            generator.selectionChanged()
            generator.prepare()
        }
        
        public func prepare() {
            guard let generator = generator as? UISelectionFeedbackGenerator else { return }
            generator.prepare()
        }
    }
    
    
    /// Wrapper of `UINotificationFeedbackGenerator`
    public class Notification {
        /// Notification feedback types
        ///
        /// - success: A notification feedback, indicating that a task has completed successfully.
        /// - warning: A notification feedback, indicating that a task has produced a warning.
        /// - error: A notification feedback, indicating that a task has failed.
        public enum NotificationType {
            case success, warning, error
        }
        
        private var generator: Any? = {
            let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
            generator.prepare()
            return generator
        }()
        
        public func feedback(_ type: NotificationType) {
            guard let generator = generator as? UINotificationFeedbackGenerator else { return }
            let feedbackType: UINotificationFeedbackGenerator.FeedbackType
            switch type {
            case .success:
                feedbackType = .success
            case .warning:
                feedbackType = .warning
            case .error:
                feedbackType = .error
            }
            generator.notificationOccurred(feedbackType)
            generator.prepare()
        }
        
        public func prepare() {
            guard let generator = generator as? UINotificationFeedbackGenerator else { return }
            generator.prepare()
        }
    }
}
