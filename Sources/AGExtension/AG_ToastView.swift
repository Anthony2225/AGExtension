//
//  AG_ToastView.swift
//  AGWheel
//
//  Created by Anthony on 2022/3/29.
//

import UIKit
/// 文字排列
@available(iOSApplicationExtension,unavailable)
public enum TextAlignment {case left,center,right}
/// 方向
@available(iOSApplicationExtension,unavailable)
public enum Position{case top,bottom}

@available(iOSApplicationExtension,unavailable)
public enum AgToastHaptic {
    case light
    case medium
    case heavy
    case success
    case warning
    case error
    @available(iOS 13.0, *)
    case soft

    @available(iOS 13.0, *)
    case rigid

    public  func haptic(){
        switch self {
        case .light:
            AgGenerator.ag_Light()
        case .medium:
            AgGenerator.ag_Medium()
        case .heavy:
            AgGenerator.ag_Heavy()
        case .success:
            AgGenerator.ag_Success()
        case .warning:
            AgGenerator.ag_Warning()
        case .error:
            AgGenerator.ag_Error()
        case .soft:
            AgGenerator.ag_Soft()
        case .rigid:
            AgGenerator.ag_Rigid()
        }
    }

}

@available(iOSApplicationExtension,unavailable)
public class AgToast {
    fileprivate  var isShowed: Bool = false
    public var haptic: UINotificationFeedbackGenerator.FeedbackType? = nil
    
    static let shared = AgToast()
    var toast:AgToastView?
    
    public enum IconType:String {
        case warning = "exclamationmark.triangle"
        case error = "xmark.octagon.fill"
        case success = "hands.clap"
    }

    
    @available(iOS 10.0, *)
    public func haptic(_ haptic: AgToastHaptic? = nil) -> AgToast{
        if haptic == nil {
            return AgToast.shared
        }
        haptic?.haptic()
//        AgGenerator.success()
        return AgToast.shared
    }
    
    
    public func showMessage(_ message: String,keepSingle: Bool = false, tapAction: ((AgToastView)  -> ())? = nil) {
        toast = self.loadToadt(title: message,onTap: {
            guard self.toast != nil else {return}
            tapAction?(self.toast!)
        })
        
        show(keepSingle)
    }
    
    public func showMsgWithIcon(_ message:String,_ icon: String = IconType.success.rawValue ,keepSingle: Bool = false, tapAction: ((AgToastView)  -> ())? = nil){
        
        toast = self.loadToadt(title:message,icon: UIImage(named: icon),onTap: {
            guard self.toast != nil else {return}
            tapAction?(self.toast!)
        })
        show(keepSingle)
    }
    
    /// 显示仿系统弹窗
    /// - Parameters:
    ///   - title: 标题内容
    ///   - titleFont: 标题字号 默认 13
    ///   - subtitle: 描述内容
    ///   - subtitleFont: 描述字号默认 11
    ///   - icon: icon
    ///   - iconSpacing: icon 和标题间距 默认 16
    ///   - position: 弹窗位置 ,上下
    ///   - keepSingle:是否要求 前个弹窗未消失之前不再弹出新的
    ///   - tapAction: 点击弹窗回调
    public func showToast(title: String,
                          titleFont: UIFont = .systemFont(ofSize: 13, weight: .regular),
                          subtitle: String? = nil,
                          subtitleFont: UIFont = .systemFont(ofSize: 11, weight: .light),
                          icon: String = IconType.success.rawValue,
                          iconSpacing: CGFloat = 16, position: Position = .top,
                          keepSingle: Bool = false,
                          tapAction: ((AgToastView)  -> ())? = nil) {
        toast = AgToastView.init(title: title, titleFont: titleFont, subtitle: subtitle, subtitleFont: subtitleFont, icon: UIImage(named: icon), iconSpacing: iconSpacing, position: position, onTap:{
            guard self.toast != nil else {return}
            tapAction?(self.toast!)
        })
        show(keepSingle)

    }
    
    
    private func loadToadt(title: String, titleFont: UIFont = .systemFont(ofSize: 13, weight: .regular),
                           subtitle: String? = nil, subtitleFont: UIFont = .systemFont(ofSize: 11, weight: .light),
                           icon: UIImage? = nil, iconSpacing: CGFloat = 16, position: Position = .top, onTap: (() -> ())? = nil,atomic: Bool = false) -> AgToastView{
        return AgToastView.init(title: title, titleFont: titleFont, subtitle: subtitle, subtitleFont: subtitleFont, icon: icon, iconSpacing: iconSpacing, position: position, onTap: onTap)
        
        
    }
    
    
    /// 展示弹窗
    /// - Parameter keepSingle: 是否要求 前一个弹窗未消失之前不允许下一个弹窗
    private  func show(_ keepSingle: Bool){
        if keepSingle == true {
            if  isShowed == true  {
                return
            }
            toast?.showWithSingle()
        }else {
            toast?.show()
        }

    }
}


@available(iOSApplicationExtension,unavailable)
public class AgToastView: UIView {

    
    fileprivate var ato: AgToast?
    
    public override var bounds: CGRect{
        didSet {
            setupShadow()
        }
    }
    
    private let position: Position
    /// 位移动画,
    private var initialTransform: CGAffineTransform {
        switch position {
        case .top:
            return CGAffineTransform(translationX: 0, y: -100)
        case .bottom:
            return CGAffineTransform(translationX: 0, y: 100)
        }
    }
    
    /// stackview 布局
    private let hStackView:UIStackView =  {
        let stackView = UIStackView()
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var  vStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical //垂直
        stackView.alignment = .center
        return stackView
    }()
    
    
    private let titleLabel: UILabel = {
        let  label = UILabel()
        label.numberOfLines = 1
        if #available(iOS 13.0, *) {
            label.textColor = .label
        }else{
            label.textColor = .black
        }
        return label
    }()
    
    private var viewBackgroundColor: UIColor? {
        if #available(iOS 12.0, *) {
            return traitCollection.userInterfaceStyle == .dark ? darkBackgroundColor : lightBackgroundColor
        }else {
            return lightBackgroundColor
        }
    }
    
    
    
    private var vStackAlignment: UIStackView.Alignment {
        switch textAlignment{
        case .left:
            return .leading
        case .right:
            return .trailing
        case .center:
            return .center
        }
    }
    
    public var onTap: (() -> ())?
    
    /// 在展示之后是否自动隐藏  / Hide the view automatically after showing ?
    public var autoHide: Bool = true
    
    /// 视图显示时间  单位: 秒  /Display time for the notification view in seconds
    public var displayTime: TimeInterval = 1.3
    
    /// 动画展示用时    / Appearence animation duration
    public var showAnimationDuration = 0.3
    
    /// 动画消失用时      / Disappearence animation duration
    public var hideAnimationDuration = 0.3
    
    /// 点击时自动隐藏视图
    public var hideOnTap: Bool = true
        
    /// 标题和副标题的 排版  / Title and subtitle text alignment

    public var textAlignment: TextAlignment = .center {
        didSet {
            vStackView.alignment = vStackAlignment
        }
    }
    
    /// 标题文字颜色 Title text color
    public var titleTextColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleTextColor
        }
    }
    
    /// 暗黑模式的背景色   Background color in dark mode
    public var darkBackgroundColor: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00){
        didSet{
            backgroundColor = viewBackgroundColor
        }
    }
    
    /// 普通模式下的背景颜色 Background color in normal mode
    public var lightBackgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00) {
        didSet {
            backgroundColor = viewBackgroundColor
        }
    }
    
    private var overlayWindow: AgToastViewWindow?

    public init(title: String, titleFont: UIFont = .systemFont(ofSize: 13, weight: .regular),
                subtitle: String? = nil, subtitleFont: UIFont = .systemFont(ofSize: 11, weight: .light),
                icon: UIImage? = nil, iconSpacing: CGFloat = 16, position: Position = .top, onTap: (() -> ())? = nil) {
        self.position = position

        super.init(frame: .zero)

        backgroundColor = viewBackgroundColor

        hStackView.spacing = iconSpacing

        titleLabel.font = titleFont
        titleLabel.text = title
        vStackView.addArrangedSubview(titleLabel)

        if let icon = icon {
            let iconImageView = UIImageView()
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                iconImageView.widthAnchor.constraint(equalToConstant: 28),
                iconImageView.heightAnchor.constraint(equalToConstant: 28)
            ])
            if #available(iOS 13.0, *) {
                iconImageView.tintColor = .label
            } else {
                iconImageView.tintColor = .black
            }
            iconImageView.image = icon
            hStackView.addArrangedSubview(iconImageView)
        }

        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            if #available(iOS 13.0, *) {
                subtitleLabel.textColor = .secondaryLabel
            } else {
                subtitleLabel.textColor = .lightGray
            }
            subtitleLabel.numberOfLines = 0
            subtitleLabel.font = subtitleFont
            subtitleLabel.text = subtitle
            vStackView.addArrangedSubview(subtitleLabel)
        }

        self.onTap = onTap
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGestureRecognizer)

        hStackView.addArrangedSubview(vStackView)
        addSubview(hStackView)

        transform = initialTransform
        clipsToBounds = true
    }

    func prepareForShowing() {
        overlayWindow = AgToastViewWindow(toastView: self)
        setupConstraints(position: position)
        setupStackViewConstraints()
        overlayWindow?.isHidden = false
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    @available(iOS 10.0, *)
    public func show(haptic: UINotificationFeedbackGenerator.FeedbackType? = nil) {
        if let hapticType = haptic {
            UINotificationFeedbackGenerator().notificationOccurred(hapticType)
        }
        show()
    }

    
    /// 保证每次只显示一个
    public func  showWithSingle() {
        AgToast.shared.isShowed = true
        show()
    }
    
    
    public func show() {

        if overlayWindow == nil {
            // We don't have a window we need to recreate one
            prepareForShowing()
        } else {
            // We are still showing an alert with current window so we do nothing
            return
        }
        UIView.animate(withDuration: showAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.transform = .identity
        }) { [self] _ in
            if autoHide {
                hide(after: displayTime)
            }
        }
    }

    public func hide(after time: TimeInterval = 0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            UIView.animate(withDuration: self.hideAnimationDuration, delay: 0, options: .curveEaseIn, animations: { [self] in
                transform = initialTransform
            }) { [self] _ in
                removeFromSuperview()
                AgToast.shared.isShowed = false
                overlayWindow = nil
            }
        }
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        backgroundColor = viewBackgroundColor
    }

    private func setupConstraints(position: Position) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        var constraints = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 8),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -8),
            heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ]

        switch position {
        case .top:
            constraints += [
                topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: 8),
                bottomAnchor.constraint(lessThanOrEqualTo: superview.layoutMarginsGuide.bottomAnchor, constant: -8)
            ]
        case .bottom:
            constraints += [
                bottomAnchor.constraint(equalTo: superview.layoutMarginsGuide.bottomAnchor, constant: -8),
                topAnchor.constraint(greaterThanOrEqualTo: superview.layoutMarginsGuide.topAnchor, constant: 8)
            ]
        }

        NSLayoutConstraint.activate(constraints)
    }

    private func setupStackViewConstraints() {
        hStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            hStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            hStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            hStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            hStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    fileprivate func setupShadow() {
        layer.masksToBounds = true
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowRadius = 8
        layer.shadowOpacity = 1
    }
    
    @objc private func didTap() {
        if hideOnTap {
            hide()
        }
        onTap?()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





@available(iOSApplicationExtension, unavailable)
class AgToastViewWindow: UIWindow {
    init(toastView: AgToastView) {
        if #available(iOS 13.0, *) {
            if let activeForegroundScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                super.init(windowScene: activeForegroundScene)
            } else if let inactiveForegroundScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundInactive }) as? UIWindowScene {
                super.init(windowScene: inactiveForegroundScene)
            } else {
                super.init(frame: UIScreen.main.bounds)
            }
        } else {
            super.init(frame: UIScreen.main.bounds)
        }
        rootViewController = UIViewController()
        windowLevel = .alert
        rootViewController?.view.addSubview(toastView)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if let rootViewController = self.rootViewController,
           let toastView = rootViewController.view.subviews.first as? AgToastView {
            return toastView.frame.contains(point)
        }
        return false
    }
}

