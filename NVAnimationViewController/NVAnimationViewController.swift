//
//  ViewController.swift
//  AnimationScroller
//
//  Created by 馮仰靚 on 2017/12/29.
//  Copyright © 2017年 larvata.YC. All rights reserved.
//

import UIKit

protocol NVAnimationViewControllerDataSource {
  func AnimationTableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
}

open class NVAnimationViewController: UIViewController {

  @IBOutlet var tableViewTopSpace: NSLayoutConstraint!
  @IBOutlet open var tableview: UITableView!

  // Must Paramater
  @IBOutlet public var imageName: String?
  // Option Paramater
  @IBOutlet public var leftButton: UIButton?
  @IBOutlet public var rightButton: UIButton?
  // interParamater
  fileprivate var nvLeftButton: UIButton?
  fileprivate var nvRightButton: UIButton?
  // put button in referenceView and put referenceView in navigationBar
  fileprivate var referenceView: UIView!
  //table view first section height
  fileprivate var clearColorCellHeight: CGFloat = 0
  // for control navigation bar button paramaters
  fileprivate var leftIconDistance: CGFloat = 0
  fileprivate var leftIconHeight: CGFloat = 0
  fileprivate var leftIconFrame: CGRect!
  fileprivate var rightIconDistance: CGFloat = 0
  fileprivate var rightIconHeight: CGFloat = 0
  fileprivate var rightIconFrame: CGRect!
  // for control back button
  var backButton: UIButton!
  // main image
  open var mainImage: UIImageView!

  open override func viewDidLoad() {
    super.viewDidLoad()
    tableview.delegate = self
    tableview.dataSource = self
    // set main image
    setImageViewInVC(imageName: imageName ?? "img_restaurant02")
    // register clear color cell
    tableview.register(UINib(nibName: "ClearColorCell", bundle: Bundle(for: NVAnimationViewController.self)), forCellReuseIdentifier: "ClearColorCell")
    tableview.backgroundColor = .clear

    if #available(iOS 11.0, *) {
      self.tableview.contentInsetAdjustmentBehavior = .never
    } else {
      automaticallyAdjustsScrollViewInsets = false
      navigationController?.automaticallyAdjustsScrollViewInsets = false
    }
    setNavigationBar()
    setStatusBar()
    createReferenceView()
    clearColorCellHeight = mainImage.frame.height - (navigationController?.navigationBar.frame.height ?? 0)
  }

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if ( leftButton != nil && nvLeftButton == nil ) || ( rightButton != nil && nvRightButton == nil ){
      // get button location
      setButton()
    }
  }

  open override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

  }

  deinit {
    if referenceView != nil {
      self.referenceView.removeFromSuperview()
    }
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = nil
    UIApplication.shared.statusBarStyle = .default
  }

  open override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @objc open func back() {
    navigationController?.dismiss(animated: true, completion: nil)
  }

  func createReferenceView() {
    // create view for navigation to add button
    referenceView = UIView()
    referenceView.frame = CGRect(x: 100,
                                 y: 0,
                                 width: UIScreen.main.bounds.width - 100,
                                 height: (navigationController?.navigationBar.frame.height)!)
    referenceView.backgroundColor = .clear
    referenceView.clipsToBounds = true
  }

  func setButton() {
    // add button in referenceView
    if let leftButton = leftButton {
      nvLeftButton = UIButton()
      nvLeftButton?.frame = leftButton.frame
      nvLeftButton?.setImage(leftButton.imageView?.image, for: .normal)
      nvLeftButton?.addTarget(self, action: #selector(nvLeftButtonEvent), for: .touchDown)
      leftIconDistance = (nvLeftButton?.frame.origin.y)!
      leftIconHeight = (nvLeftButton?.frame.height)!
      leftIconFrame = nvLeftButton?.frame
      referenceView.addSubview(nvLeftButton!)
    }
    if let rightButton = rightButton {
      nvRightButton = UIButton()
      nvRightButton?.frame = rightButton.frame
      nvRightButton?.setImage(rightButton.imageView?.image, for: .normal)
      nvRightButton?.addTarget(self, action: #selector(nvRightButtonEvent), for: .touchDown)
      rightIconDistance = (nvRightButton?.frame.origin.y)!
      rightIconHeight = (nvRightButton?.frame.height)!
      rightIconFrame = nvRightButton?.frame
      referenceView.addSubview(nvRightButton!)
    }
    navigationController?.navigationBar.addSubview(referenceView)
  }

  @objc private func nvLeftButtonEvent() {
    if let leftButton = leftButton {
      leftButton.sendActions(for: .touchDown)
    }
  }

  @objc private func nvRightButtonEvent() {
    if let rightButton = rightButton {
      rightButton.sendActions(for: .touchDown)
    }
  }

  fileprivate func setNavigationBar() {
    // set navigation gradient color
    var colors = [UIColor]()
    colors.append(UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.6))
    colors.append(UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0))
    navigationController?.navigationBar.setGradientBackground(colors: colors)
    navigationController?.navigationBar.shadowImage = UIImage()
    // create a new button
    backButton = UIButton(type: .custom)
    // set image for button
    let whiteBackImage = UIImage(named: "icon_back_white", in: Bundle(for: NVAnimationViewController.self), compatibleWith: nil)
    backButton.setImage(whiteBackImage, for: UIControlState.normal)
    // add function for button
    backButton.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
    // set frame
    backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
    let barButton = UIBarButtonItem(customView: backButton)
    //    //assign button to navigationbar
    navigationItem.leftBarButtonItem = barButton
  }

  fileprivate func setStatusBar() {
    UIApplication.shared.statusBarStyle = .lightContent
  }

  public func setImageViewInVC(imageName: String? = nil, image: UIImage? = nil) {
    let fullScreenSize = UIScreen.main.bounds.size
    let mainImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 251))
    if let imageName = imageName {
      mainImageView.image = UIImage(named: imageName)
    } else if let image = image {
      mainImageView.image = image
    }
    mainImageView.contentMode = .scaleAspectFill
    mainImageView.clipsToBounds = true
    mainImage = mainImageView
    view.insertSubview(mainImage, at: 0)
  }

}

extension NVAnimationViewController: UITableViewDelegate, UITableViewDataSource {

  open func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.section {
    case 0:
      return clearColorCellHeight
    default:
      return UITableViewAutomaticDimension
    }
  }
  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ClearColorCell", for: indexPath)
    if let cell = cell as? ClearColorCell {
      cell.backgroundColor = .clear
    }
    return cell
  }

  fileprivate func whiteColors() -> [UIColor] {
    var colors = [UIColor]()
    colors.append(UIColor(red: 1, green: 1, blue: 1, alpha: 0.99))
    colors.append(UIColor(red: 1, green: 1, blue: 1, alpha: 1))
    return colors
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {

    let yPosition = tableview.contentOffset.y
    // control navigationBar color
    let fadeOutRange: CGFloat = 100
    switch yPosition {
    case CGFloat.leastNormalMagnitude..<(clearColorCellHeight - fadeOutRange):
      var colors = [UIColor]()
      colors.append(UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0.6))
      colors.append(UIColor(red: 0 / 255, green: 0 / 255, blue: 0 / 255, alpha: 0))
      navigationController?.navigationBar.setGradientBackground(colors: colors)
      if nvLeftButton != nil {
        nvLeftButton!.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
      }
      let whiteBackImage = UIImage(named: "icon_back_white", in: Bundle(for: NVAnimationViewController.self), compatibleWith: nil)
      backButton.setImage(whiteBackImage, for: .normal)
      UIApplication.shared.statusBarStyle = .lightContent
    // 開始變色
    case (clearColorCellHeight - fadeOutRange)..<CGFloat.greatestFiniteMagnitude:
      if yPosition <= clearColorCellHeight {
        var colors = [UIColor]()
        let rgbNum: CGFloat = 255.0 // (yPosition - imageHeight + fadeOutRange) * 255/fadeOutRange
        let bottomAlpha = (yPosition - clearColorCellHeight + fadeOutRange) / fadeOutRange
        colors.append(UIColor(red: rgbNum / 255, green: rgbNum / 255, blue: rgbNum / 255, alpha: 0 + bottomAlpha))
        colors.append(UIColor(red: rgbNum / 255, green: rgbNum / 255, blue: rgbNum / 255, alpha: 0 + bottomAlpha))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        let blackBackImage = UIImage(named: "icon_back", in: Bundle(for: NVAnimationViewController.self), compatibleWith: nil)
        backButton.setImage(blackBackImage, for: .normal)
        UIApplication.shared.statusBarStyle = .default
      } else if yPosition > 0 && yPosition > clearColorCellHeight {
        navigationController?.navigationBar.setGradientBackground(colors: whiteColors())
      }
      switch yPosition {
      case (clearColorCellHeight - 66)..<(clearColorCellHeight + leftIconDistance + leftIconHeight):
        if nvLeftButton != nil {
          nvLeftButton!.frame = CGRect(x: leftIconFrame.origin.x - referenceView.frame.origin.x,
                                       y: max((clearColorCellHeight + leftIconDistance) - yPosition + (navigationController?.navigationBar.frame.height ?? 0), 0),
                                       width: leftIconFrame.width,
                                       height: leftIconFrame.height)
        }
        if nvRightButton != nil {
          nvRightButton!.frame = CGRect(x: rightIconFrame.origin.x - referenceView.frame.origin.x,
                                        y: max((clearColorCellHeight + rightIconDistance) - yPosition + (navigationController?.navigationBar.frame.height ?? 0), 0),
                                        width: rightIconFrame.width,
                                        height: rightIconFrame.height)
        }
      default:
        if nvLeftButton != nil {
          nvLeftButton!.frame = CGRect(x: leftIconFrame.origin.x - referenceView.frame.origin.x,
                                       y: max((clearColorCellHeight + leftIconDistance) - yPosition + (navigationController?.navigationBar.frame.height ?? 0), 0),
                                       width: leftIconFrame.width,
                                       height: leftIconFrame.height)
        }
        if nvRightButton != nil {
          nvRightButton!.frame = CGRect(x: rightIconFrame.origin.x - referenceView.frame.origin.x,
                                        y: max((clearColorCellHeight + rightIconDistance) - yPosition + (navigationController?.navigationBar.frame.height ?? 0), 0),
                                        width: rightIconFrame.width,
                                        height: rightIconFrame.height)
        }
      }
    default:
      break
    }
    // 控制Navgation Bar 下方橘色分隔線顯示時機
    if yPosition > mainImage.frame.height {
      navigationController?.navigationBar.shadowImage = UIImage(color: UIColor(red: 213 / 255, green: 188 / 255, blue: 149 / 255, alpha: 1))
    } else {
      navigationController?.navigationBar.shadowImage = UIImage()
    }
    // 控制圖片
    let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)

    if mainImage.frame.height < 10 {
      mainImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 10)
    }
    if mainImage.frame.height > 9 {
      if translation.y > 0 {
        mainImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: max(clearColorCellHeight - yPosition + (navigationController?.navigationBar.frame.height ?? 0), 50))
      } else {
        mainImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: max(clearColorCellHeight - yPosition + (navigationController?.navigationBar.frame.height ?? 0), 50))
      }
    }
  }

}

public extension UIImage {
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 0.3)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}

extension CAGradientLayer {

  convenience init(frame: CGRect, colors: [UIColor]) {
    self.init()
    self.frame = frame
    self.colors = []
    for color in colors {
      self.colors?.append(color.cgColor)
    }
    startPoint = CGPoint(x: 0, y: 0)
    endPoint = CGPoint(x: 0, y: 1)
  }

  func creatGradientImage() -> UIImage? {

    var image: UIImage?
    UIGraphicsBeginImageContext(bounds.size)
    if let context = UIGraphicsGetCurrentContext() {
      render(in: context)
      image = UIGraphicsGetImageFromCurrentImageContext()
    }
    UIGraphicsEndImageContext()
    return image
  }

}

extension UINavigationBar {

  func setGradientBackground(colors: [UIColor]) {

    var updatedFrame = bounds
    updatedFrame.size.height += 20
    let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)

    setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
  }
}
