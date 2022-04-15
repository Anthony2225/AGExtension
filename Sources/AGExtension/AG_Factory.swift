//
//  AG_Factory.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/26.
//

import Foundation
import UIKit
#if canImport(SnapKit)
import SnapKit
#endif
// MARK: ===================================工厂类:工厂初始化=========================================
public typealias ButtonClosure = (_ sender: UIButton) -> Void
typealias tapGestureClosure = (_ view: UIView) -> Void

// MARK: ===================================工厂类:button 初始化=========================================

public extension UIButton {
    #if canImport(SnapKit)
    /// 快速初始化UIButton 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView:  被添加的位置 有默认参数
    ///   - title: 标题 有默认参数
    ///   - font: 字体 有默认参数
    ///   - titleNorColor: 默认字体颜色 有默认参数
    ///   - titleHigColor: 高亮字体颜色 有默认参数
    ///   - norImage: 默认图片 有默认参数
    ///   - higImage: 高亮图片 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - touchUp: 点击Block 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func factoryButton(supView: UIView? = nil,
                         backColor: UIColor? = .clear,
                         title: String? = nil,
                         font: UIFont? = nil,
                         titleNorColor: UIColor? = nil,
                         titleHigColor: UIColor? = nil,
                         norImage: UIImage? = nil,
                         higImage: UIImage? = nil,
                         touchUp: ButtonClosure? = nil,
                         snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = backColor
        
        if title != nil {
            btn.setTitle(title, for: .normal)
        }
        
        if font != nil {
            btn.titleLabel?.font = font
        }else{
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
        }
        
        if titleNorColor != nil {
            btn.setTitleColor(titleNorColor, for: .normal)
        }else{
            btn.setTitleColor(.black, for: .normal)
        }
        
        if titleHigColor != nil {
            btn.setTitleColor(titleHigColor, for: .highlighted)
        }
        
        if norImage != nil {
            btn.setImage(norImage, for: .normal)
        }
        
        if higImage != nil {
            btn.setImage(higImage, for: .highlighted)
        }
        
        guard let sv = supView, let maker = snapKitMaker else {
            return btn
        }
        sv.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            maker(make)
        }
        guard let ges = touchUp else {
            return btn
        }
//        btn.addTouchUpInSideBtnAction(touchUp: ges)
        btn.tapActionClosures(ges)
        return btn
    }
    
    #else
    /// 快速初始化UIButton 不带 snapkiet  包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView:  被添加的位置 有默认参数
    ///   - title: 标题 有默认参数
    ///   - font: 字体 有默认参数
    ///   - titleNorColor: 默认字体颜色 有默认参数
    ///   - titleHigColor: 高亮字体颜色 有默认参数
    ///   - norImage: 默认图片 有默认参数
    ///   - higImage: 高亮图片 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - touchUp: 点击Block 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func factoryButton(supView: UIView? = nil,
                         backColor: UIColor? = .clear,
                         title: String? = nil,
                         font: UIFont? = nil,
                         titleNorColor: UIColor? = nil,
                         titleHigColor: UIColor? = nil,
                         norImage: UIImage? = nil,
                         higImage: UIImage? = nil,
                         touchUp: ButtonClosure? = nil) -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = backColor
        
        if title != nil {
            btn.setTitle(title, for: .normal)
        }
        
        if font != nil {
            btn.titleLabel?.font = font
        }else{
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
        }
        
        if titleNorColor != nil {
            btn.setTitleColor(titleNorColor, for: .normal)
        }else{
            btn.setTitleColor(.black, for: .normal)
        }
        
        if titleHigColor != nil {
            btn.setTitleColor(titleHigColor, for: .highlighted)
        }
        
        if norImage != nil {
            btn.setImage(norImage, for: .normal)
        }
        
        if higImage != nil {
            btn.setImage(higImage, for: .highlighted)
        }
        
        guard let sv = supView else {
            return btn
        }
        sv.addSubview(btn)

        guard let ges = touchUp else {
            return btn
        }
//        btn.addTouchUpInSideBtnAction(touchUp: ges)
        btn.tapActionClosures(ges)
        return btn
    }
    
    #endif
}

// MARK: ===================================工厂类: label 初始化=========================================

public extension UILabel {
    #if canImport(SnapKit)
    /// 快速初始化UILabel 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - font: 字体 有默认参数
    ///   - lines: 行数 有默认参数
    ///   - text: 内容 有默认参数
    ///   - textColor: 字体颜色 有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - textAlignment: textAlignment 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func factoruLabel(supView: UIView? = nil,
                        backColor: UIColor? = .clear,
                        font: UIFont = UIFont.systemFont(ofSize: 14),
                        lines: Int = 0,
                        text: String = "",
                        textColor: UIColor = .black,
                        textAlignment: NSTextAlignment = .left,
                        snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textAlignment = textAlignment
        label.backgroundColor = backColor
        label.textColor = textColor
        label.numberOfLines = lines

        guard let sv = supView, let maker = snapKitMaker else {
            return label
        }
        
        sv.addSubview(label)
        label.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return label
    }
    #else
    /// 快速初始化UILabel   不带 snapkiet  包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - font: 字体 有默认参数
    ///   - lines: 行数 有默认参数
    ///   - text: 内容 有默认参数
    ///   - textColor: 字体颜色 有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - textAlignment: textAlignment 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func factoryLabel(supView: UIView? = nil,
                        backColor: UIColor? = .clear,
                        font: UIFont = UIFont.systemFont(ofSize: 14),
                        lines: Int = 0,
                        text: String = "",
                        textColor: UIColor = .black,
                        textAlignment: NSTextAlignment = .left,
                        frame:CGRect = .zero) -> UILabel {
        
        let label = UILabel()
        label.text = text
        label.font = font
        label.textAlignment = textAlignment
        label.backgroundColor = backColor
        label.textColor = textColor
        label.numberOfLines = lines

        guard let sv = supView else {
            return label
        }
        label.frame = frame
        sv.addSubview(label)

        
        return label
    }
    #endif
}

// MARK: ===================================工厂类:iamgeview 初始化=========================================

public extension UIImageView {
    
    #if canImport(SnapKit)
    /// 快速初始化UIImageView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - image: 图片对象 有默认参数
    ///   - contentMode: contentMode 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func factoryImageView(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            image: UIImage? = nil,
                            contentMode: UIView.ContentMode  = .scaleAspectFill,
                            snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.backgroundColor = backColor
        imageView.contentMode = contentMode
        
        imageView.image = image
        
        guard let sv = supView, let maker = snapKitMaker else {
            return imageView
        }
        sv.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return imageView
    }
    #else
    /// 快速初始化UIImageView 不带 snapkiet  包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - image: 图片对象 有默认参数
    ///   - contentMode: contentMode 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func factoryImageView(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            image: UIImage? = nil,
                            contentMode: UIView.ContentMode  = .scaleAspectFill) -> UIImageView {
        
        let imageView = UIImageView()
        imageView.backgroundColor = backColor
        imageView.contentMode = contentMode
        
        imageView.image = image
        
        guard let sv = supView else {
            return imageView
        }
        sv.addSubview(imageView)
        
        return imageView
    }
    
    #endif
}

// MARK: ===================================工厂类:textfield 初始化=========================================

public extension UITextField {
    #if canImport(SnapKit)
    
    /// 快速初始化UITextField 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - holderFont: 占位字体 有默认参数
    ///   - holder: 占位文字 有默认参数
    ///   - holderColor: 占位文字颜色 有默认参数
    ///   - font: 输入字体 有默认参数
    ///   - text: 输入文字 有默认参数
    ///   - textColor: 输入文字颜色 有默认参数
    ///   - textAlignment: textAlignment 有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - delegate: 代理
    ///   - backColor: 背景色
    @discardableResult
    class func factoryTextField(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            agHolderFont: UIFont = UIFont.systemFont(ofSize: 14),
                            holder: String = "",
                            agHolderColor: UIColor = .black,
                            font: UIFont = UIFont.systemFont(ofSize: 14),
                            text: String = "",
                            textColor: UIColor = .black,
                            textAlignment: NSTextAlignment = .left,
                            delegate: UITextFieldDelegate? = nil,
                            snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UITextField {
        
        let field = UITextField()
        
        field.borderStyle = .none
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.spellCheckingType = .no

        if delegate != nil {
          field.delegate = delegate
        }
        
        field.attributedPlaceholder = NSAttributedString(string: holder, attributes: [NSAttributedString.Key.font: agHolderFont,NSAttributedString.Key.foregroundColor:agHolderColor])
        
        field.text = text
        field.font = font
        field.textColor = textColor
        field.textAlignment = textAlignment
        field.backgroundColor = backColor
        
        guard let sv = supView, let maker = snapKitMaker else {
            return field
        }
        
        sv.addSubview(field)
        field.snp.makeConstraints { (make) in
            maker(make)
        }
        return field
    }
    #else
    
    /// 快速初始化UITextField 不带 snapkiet 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - holderFont: 占位字体 有默认参数
    ///   - holder: 占位文字 有默认参数
    ///   - holderColor: 占位文字颜色 有默认参数
    ///   - font: 输入字体 有默认参数
    ///   - text: 输入文字 有默认参数
    ///   - textColor: 输入文字颜色 有默认参数
    ///   - textAlignment: textAlignment 有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - delegate: 代理
    ///   - backColor: 背景色
    @discardableResult
    class func snpTextField(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            holderFont: UIFont = UIFont.systemFont(ofSize: 14),
                            holder: String = "",
                            holderColor: UIColor = .black,
                            font: UIFont = UIFont.systemFont(ofSize: 14),
                            text: String = "",
                            textColor: UIColor = .black,
                            textAlignment: NSTextAlignment = .left,
                            delegate: UITextFieldDelegate? = nil) -> UITextField {
        
        let field = UITextField()
        
        field.borderStyle = .none
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.spellCheckingType = .no

        if delegate != nil {
          field.delegate = delegate
        }
        
        field.attributedPlaceholder = NSAttributedString(string: holder, attributes: [NSAttributedString.Key.font: holderFont,NSAttributedString.Key.foregroundColor:holderColor])
        
        field.text = text
        field.font = font
        field.textColor = textColor
        field.textAlignment = textAlignment
        field.backgroundColor = backColor
        
        guard let sv = supView else {
            return field
        }
        
        sv.addSubview(field)

        return field
    }
    
    #endif
}


// MARK: ===================================工厂类:textVIew 初始化=========================================

public extension UITextView {
    #if canImport(SnapKit)
    
    /// 快速初始化UITextView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - holderFont: 占位字体  有默认参数
    ///   - holder: 占位文字  有默认参数
    ///   - holderColor: 占位文字颜色  有默认参数
    ///   - font: 正文字体  有默认参数
    ///   - text: 正文  有默认参数
    ///   - textColor: 正文字体颜色  有默认参数
    ///   - textAlignment: textAlignment  有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - delegate: 代理
    ///   - backColor: 背景色
    @discardableResult
    class func snpTextView(supView: UIView? = nil,
                           backColor: UIColor? = .clear,
                           agHolderFont: UIFont = UIFont.systemFont(ofSize: 14),
                           holder: String = "",
                           agHolderColor: UIColor = .black,
                           font: UIFont = UIFont.systemFont(ofSize: 14),
                           text: String = "",
                           textColor: UIColor = .black,
                           textAlignment: NSTextAlignment = .left,
                           delegate: UITextViewDelegate? = nil,
                           snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UITextView {
        
        let textView = UITextView()
        textView.ag_HolderFont = agHolderFont
        textView.ag_HolderColor = agHolderColor
        textView.ag_Placeholder = holder
        
        textView.text = text
        textView.textColor = textColor
        textView.font = font
        
        textView.textAlignment = textAlignment
        
        if delegate != nil {
          textView.delegate = delegate
        }
        
        textView.backgroundColor = backColor
        
        guard let sv = supView, let maker = snapKitMaker else {
            return textView
        }
        sv.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return textView
    }
    #else
    /// 快速初始化UITextView 不带 snapKit 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - holderFont: 占位字体  有默认参数
    ///   - holder: 占位文字  有默认参数
    ///   - holderColor: 占位文字颜色  有默认参数
    ///   - font: 正文字体  有默认参数
    ///   - text: 正文  有默认参数
    ///   - textColor: 正文字体颜色  有默认参数
    ///   - textAlignment: textAlignment  有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - delegate: 代理
    ///   - backColor: 背景色
    @discardableResult
    class func snpTextView(supView: UIView? = nil,
                           backColor: UIColor? = .clear,
                           agHolderFont: UIFont = UIFont.systemFont(ofSize: 14),
                           holder: String = "",
                           agHolderColor: UIColor = .black,
                           font: UIFont = UIFont.systemFont(ofSize: 14),
                           text: String = "",
                           textColor: UIColor = .black,
                           textAlignment: NSTextAlignment = .left,
                           delegate: UITextViewDelegate? = nil) -> UITextView {
        
        let textView = UITextView()
        textView.ag_HolderFont = agHolderFont
        textView.ag_HolderColor = agHolderColor
        textView.ag_Placeholder = holder
        
        textView.text = text
        textView.textColor = textColor
        textView.font = font
        
        textView.textAlignment = textAlignment
        
        if delegate != nil {
          textView.delegate = delegate
        }
        
        textView.backgroundColor = backColor
        
        guard let sv = supView else {
            return textView
        }
        sv.addSubview(textView)
        return textView
    }
    
    #endif
    
    
}

// MARK: ===================================工厂类:UIStackView 初始化=========================================

public extension UIStackView {
    #if canImport(SnapKit)
    /// 快速创建UIStackView
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - backColor: 背景色
    ///   - cornerRadius: 圆角
    ///   - axis: 方向 横向或竖向
    ///   - spacing: 间距
    ///   - alignment: 主方向上以怎样的方式对齐
    ///   - distribution: 以怎样的方式存在
    ///   - autoLayout: 是否自适应大小
    ///   - snapKitMaker: 布局回调
    /// - Returns: UIStackView
    @discardableResult
    class func snpStackView(supView: UIView? = nil,
                            backColor: UIColor = .clear,
                            cornerRadius: CGFloat = 0.0,
                            axis: NSLayoutConstraint.Axis,
                            spacing: CGFloat = 0.0,
                            alignment: UIStackView.Alignment = .fill,
                            distribution: UIStackView.Distribution = .fill,
                            autoLayout: Bool = false,
                            snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UIView {
        
        let view = UIStackView(axis: axis, spacing: spacing, alignment: alignment, distribution: distribution, autoLayout: autoLayout)
        view.addBackground(color: backColor, cornerRadius: cornerRadius)
        
        guard let sv = supView, let maker = snapKitMaker else {
            return view
        }
        sv.addSubview(view)
        view.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return view
    }
    #else
    /// 快速创建UIStackView  不带 snap布局
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - backColor: 背景色
    ///   - cornerRadius: 圆角
    ///   - axis: 方向 横向或竖向
    ///   - spacing: 间距
    ///   - alignment: 主方向上以怎样的方式对齐
    ///   - distribution: 以怎样的方式存在
    ///   - autoLayout: 是否自适应大小
    /// - Returns: UIStackView
    @discardableResult
    class func snpStackView(supView: UIView? = nil,
                            backColor: UIColor = .clear,
                            cornerRadius: CGFloat = 0.0,
                            axis: NSLayoutConstraint.Axis,
                            spacing: CGFloat = 0.0,
                            alignment: UIStackView.Alignment = .fill,
                            distribution: UIStackView.Distribution = .fill,
                            autoLayout: Bool = false) -> UIView {
        
        let view = UIStackView(axis: axis, spacing: spacing, alignment: alignment, distribution: distribution, autoLayout: autoLayout)
        view.addBackground(color: backColor, cornerRadius: cornerRadius)
        
        guard let sv = supView else {
            return view
        }
        sv.addSubview(view)

        
        return view
    }
    
    #endif
}



// MARK: ===================================工厂类:tableView 初始化=========================================


public extension UITableView {
    
    
    #if canImport(SnapKit)
    /// 快速初始化UITableView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - style: 列表样式 有默认参数
    ///   - delegate: delegate
    ///   - dataSource: dataSource
    ///   - backColor: 背景色
    @discardableResult
    class func snpTableView(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            style: UITableView.Style = .plain,
                            delegate: UITableViewDelegate? = nil,
                            dataSource: UITableViewDataSource? = nil,
                            snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UITableView {
        
        let tableView = UITableView(frame: .zero, style: style)
        if delegate != nil {
          tableView.delegate = delegate
        }
        if dataSource != nil {
          tableView.dataSource = dataSource
        }

        tableView.backgroundColor = backColor
        
        tableView.separatorStyle = .none
        //        self.tableView?.separatorColor = .lightGray
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.delaysContentTouches = true
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .automatic
        }
        
        guard let sv = supView, let maker = snapKitMaker else {
            return tableView
        }
        
        sv.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return tableView
    }
    #else
    /// 快速初始化UITableView 包含默认参数 不带 snapkit
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - style: 列表样式 有默认参数
    ///   - delegate: delegate
    ///   - dataSource: dataSource
    ///   - backColor: 背景色
    @discardableResult
    class func snpTableView(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            style: UITableView.Style = .plain,
                            delegate: UITableViewDelegate? = nil,
                            dataSource: UITableViewDataSource? = nil) -> UITableView {
        
        let tableView = UITableView(frame: .zero, style: style)
        if delegate != nil {
          tableView.delegate = delegate
        }
        if dataSource != nil {
          tableView.dataSource = dataSource
        }

        tableView.backgroundColor = backColor
        
        tableView.separatorStyle = .none
        //        self.tableView?.separatorColor = .lightGray
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.delaysContentTouches = true
        tableView.contentInsetAdjustmentBehavior = .automatic
        
        guard let sv = supView else {
            return tableView
        }
        
        sv.addSubview(tableView)

        return tableView
    }
    
    #endif
}
