import UIKit
import PlaygroundSupport

class TestView: UIView, CAAnimationDelegate {

  let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))


  override func willMove(toWindow newWindow: UIWindow?) {
    super.willMove(toWindow: newWindow)
    self.backgroundColor = UIColor.gray

    for i in 0..<2 {
      let red = TestCircleLayer(frame: self.frame, color: UIColor.red)
      red.startAnim()
      self.layer.addSublayer(red)

      let blue = TestCircleLayer(frame: self.frame, color: UIColor.blue)
      blue.startAnim()
      self.layer.addSublayer(blue)

      let green = TestCircleLayer(frame: self.frame, color: UIColor.green)
      green.startAnim()
      self.layer.addSublayer(green)

      let white = TestCircleLayer(frame: self.frame, color: UIColor.white)
      white.startAnim()
      self.layer.addSublayer(white)
    }

    effectView.frame = self.frame
    self.addSubview(effectView)
  }
}

class TestCircleLayer: CAShapeLayer, CAAnimationDelegate {
  let radius: CGFloat = 20.0 + CGFloat(arc4random_uniform(50))
  var superFrame: CGRect = CGRect()
  var circleColor: UIColor = UIColor.white

  init(frame: CGRect, color: UIColor) {
    super.init()
    self.superFrame = frame
    self.circleColor = color

    self.position = CGPoint(x: -superFrame.maxX, y: 0)
    path = UIBezierPath(arcCenter: CGPoint(x:0 , y: 0), radius: radius, startAngle: 0, endAngle: 360, clockwise: true).cgPath

    fillColor = circleColor.withAlphaComponent(1).cgColor
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  func startAnim() {
    addAnim()
  }

  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    addAnim()
  }

  private func addAnim() {
    let posX = CGFloat(arc4random_uniform(UInt32(superFrame.width)))

    let delay = Double(arc4random_uniform(24))

    self.removeAnimation(forKey: "fadeinCircle")
    self.removeAnimation(forKey: "riseUpCircle")
    let anim = CABasicAnimation(keyPath: "position")
    anim.fromValue = CGPoint(x: posX, y: superFrame.maxY)
    anim.toValue = CGPoint(x: posX, y: 0 - superFrame.midY)
    anim.duration = 25 + Double(arc4random_uniform(10))
    anim.delegate = self
    anim.beginTime = CACurrentMediaTime() + delay

    let fadein = CABasicAnimation(keyPath: "opacity")
    fadein.fromValue = 0
    fadein.toValue = 1
    fadein.repeatCount = 1
    fadein.duration = 3
    fadein.beginTime = CACurrentMediaTime() + delay

    self.add(fadein, forKey: "fadeinCircle")
    self.add(anim, forKey: "riseUpCircle")
  }
}

let vc = TestView(frame: CGRect(x: 0, y: 0, width: 768, height: 1024))
PlaygroundPage.current.liveView = vc
