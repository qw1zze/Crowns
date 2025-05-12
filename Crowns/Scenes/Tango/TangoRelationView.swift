import UIKit

final class TangoRelationView: UIView {
    enum RelationType {
        case equal, cross
    }
    var type: RelationType = .equal {
        didSet { setNeedsDisplay() }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    required init?(coder: NSCoder) { fatalError() }
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let w = rect.width, h = rect.height
        ctx.setLineCap(.round)
        ctx.setLineWidth(min(w, h) * 0.18)
        ctx.setStrokeColor(UIColor.label.cgColor)
        switch type {
        case .equal:
            let y1 = h * 0.35, y2 = h * 0.65
            ctx.move(to: CGPoint(x: w * 0.2, y: y1))
            ctx.addLine(to: CGPoint(x: w * 0.8, y: y1))
            ctx.move(to: CGPoint(x: w * 0.2, y: y2))
            ctx.addLine(to: CGPoint(x: w * 0.8, y: y2))
            ctx.strokePath()
        case .cross:
            ctx.move(to: CGPoint(x: w * 0.2, y: h * 0.2))
            ctx.addLine(to: CGPoint(x: w * 0.8, y: h * 0.8))
            ctx.move(to: CGPoint(x: w * 0.8, y: h * 0.2))
            ctx.addLine(to: CGPoint(x: w * 0.2, y: h * 0.8))
            ctx.strokePath()
        }
    }
} 