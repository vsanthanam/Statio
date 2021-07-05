//
// Statio
// Varun Santhanam
//

import CoreGraphics
import Foundation
import UIKit

/// @mockable
protocol MonitorIconProviding: AnyObject {
    func drawIcon(forIdentifier identifier: MonitorIdentifier,
                  targetFrame: CGRect,
                  color: UIColor,
                  resizing: MonitorIconProvider.ResizingBehavior)
    func image(forIdentifier identifier: MonitorIdentifier,
               size: CGSize,
               color: UIColor) -> UIImage
}

extension MonitorIconProviding {

    func drawIcon(forIdentifier identifier: MonitorIdentifier,
                  targetFrame: CGRect,
                  color: UIColor = .label,
                  resizing: MonitorIconProvider.ResizingBehavior = .aspectFit) {
        drawIcon(forIdentifier: identifier,
                 targetFrame: targetFrame,
                 color: color,
                 resizing: resizing)
    }

    func image(forIdentifier identifier: MonitorIdentifier,
               size: CGSize,
               color: UIColor = .label) -> UIImage {
        image(forIdentifier: identifier,
              size: size,
              color: color)
    }
}

final class MonitorIconProvider: MonitorIconProviding {

    // MARK: - MonitorIconProviding

    func drawIcon(forIdentifier identifier: MonitorIdentifier,
                  targetFrame: CGRect,
                  color: UIColor,
                  resizing: ResizingBehavior) {
        switch identifier {
        case .memory:
            drawMemory(color: color,
                       targetFrame: targetFrame,
                       resizing: resizing)
        case .carrier:
            drawPhone(color: color,
                      targetFrame: targetFrame,
                      resizing: resizing)
        case .identity:
            drawSmartPhone(color: color,
                           targetFrame: targetFrame,
                           resizing: resizing)
        case .battery:
            drawBattery(color: color,
                        targetFrame: targetFrame,
                        resizing: resizing)
        case .disk:
            drawDisk(color: color,
                     targetFrame: targetFrame,
                     resizing: resizing)
        case .processor:
            drawChip(color: color,
                     targetFrame: targetFrame,
                     resizing: resizing)
        case .cellular:
            drawCellularTower(color: color,
                              targetFrame: targetFrame,
                              resizing: resizing)
        case .wifi:
            drawWifi(color: color,
                     targetFrame: targetFrame,
                     resizing: resizing)
        default:
            drawMemory(color: color, targetFrame: targetFrame, resizing: resizing)
        }
    }

    func image(forIdentifier identifier: MonitorIdentifier,
               size: CGSize,
               color: UIColor) -> UIImage {
        var hasher = Hasher()

        hasher.combine(identifier)
        hasher.combine(color)
        hasher.combine(size.height)
        hasher.combine(size.width)

        let key = hasher.finalize()

        if let image = cache[key] {
            return image
        }

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        drawIcon(forIdentifier: identifier, targetFrame: .init(origin: .zero, size: size), color: color, resizing: .aspectFit)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        cache[key] = image

        return image
    }

    // MARK: - API

    public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }

    // MARK: - Private

    private var cache = [Int: UIImage]()

    private func drawMemory(color: UIColor,
                            targetFrame: CGRect,
                            resizing: ResizingBehavior) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = UIColor(red: 0.000, green: 0.000, blue: 0.000, alpha: 1.000)

        context.saveGState()
        context.translateBy(x: 35, y: 301)
        context.rotate(by: -45 * CGFloat.pi / 180)

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: -52, y: 46.85))
        bezierPath.addLine(to: CGPoint(x: -47.91, y: 50.87))
        bezierPath.addCurve(to: CGPoint(x: -47.91, y: 86.35), controlPoint1: CGPoint(x: -37.94, y: 60.65), controlPoint2: CGPoint(x: -37.94, y: 76.57))
        bezierPath.addLine(to: CGPoint(x: -52, y: 90.37))
        bezierPath.addLine(to: CGPoint(x: -52, y: 192.11))
        bezierPath.addLine(to: CGPoint(x: 425, y: 192.11))
        bezierPath.addLine(to: CGPoint(x: 425, y: 90.37))
        bezierPath.addLine(to: CGPoint(x: 420.91, y: 86.35))
        bezierPath.addCurve(to: CGPoint(x: 420.91, y: 50.87), controlPoint1: CGPoint(x: 410.94, y: 76.57), controlPoint2: CGPoint(x: 410.94, y: 60.65))
        bezierPath.addLine(to: CGPoint(x: 425, y: 46.85))
        bezierPath.addLine(to: CGPoint(x: 425, y: 0))
        bezierPath.addLine(to: CGPoint(x: -52, y: 0))
        bezierPath.addLine(to: CGPoint(x: -52, y: 46.85))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 312.27, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 340.22, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 340.22, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 312.27, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 312.27, y: 54.89))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 256.37, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 284.32, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 284.32, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 256.37, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 256.37, y: 54.89))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 200.47, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 228.42, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 228.42, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 200.47, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 200.47, y: 54.89))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 144.58, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 172.53, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 172.53, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 144.58, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 144.58, y: 54.89))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 88.68, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 116.63, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 116.63, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 88.68, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 88.68, y: 54.89))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 32.78, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 60.73, y: 54.89))
        bezierPath.addLine(to: CGPoint(x: 60.73, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 32.78, y: 137.22))
        bezierPath.addLine(to: CGPoint(x: 32.78, y: 54.89))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        let rectanglePath = UIBezierPath(rect: CGRect(x: -23, y: 219, width: 139, height: 28))
        fillColor.setFill()
        rectanglePath.fill()

        let rectangle2Path = UIBezierPath(rect: CGRect(x: 144, y: 219, width: 253, height: 28))
        fillColor.setFill()
        rectangle2Path.fill()

        context.restoreGState()

        context.restoreGState()
    }

    private func drawPhone(color: UIColor,
                           targetFrame: CGRect,
                           resizing: ResizingBehavior) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = color

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 388.92, y: 338.41))
        bezierPath.addCurve(to: CGPoint(x: 334.74, y: 338.41), controlPoint1: CGPoint(x: 372.21, y: 321.91), controlPoint2: CGPoint(x: 351.35, y: 321.91))
        bezierPath.addCurve(to: CGPoint(x: 296.95, y: 376.3), controlPoint1: CGPoint(x: 322.07, y: 350.97), controlPoint2: CGPoint(x: 309.4, y: 363.53))
        bezierPath.addCurve(to: CGPoint(x: 286.52, y: 378.22), controlPoint1: CGPoint(x: 293.54, y: 379.82), controlPoint2: CGPoint(x: 290.67, y: 380.56))
        bezierPath.addCurve(to: CGPoint(x: 261.71, y: 365.23), controlPoint1: CGPoint(x: 278.32, y: 373.75), controlPoint2: CGPoint(x: 269.59, y: 370.13))
        bezierPath.addCurve(to: CGPoint(x: 166.97, y: 279.01), controlPoint1: CGPoint(x: 224.99, y: 342.13), controlPoint2: CGPoint(x: 194.22, y: 312.43))
        bezierPath.addCurve(to: CGPoint(x: 133.01, y: 224.61), controlPoint1: CGPoint(x: 153.45, y: 262.4), controlPoint2: CGPoint(x: 141.42, y: 244.62))
        bezierPath.addCurve(to: CGPoint(x: 134.93, y: 214.6), controlPoint1: CGPoint(x: 131.31, y: 220.57), controlPoint2: CGPoint(x: 131.63, y: 217.9))
        bezierPath.addCurve(to: CGPoint(x: 172.4, y: 177.24), controlPoint1: CGPoint(x: 147.6, y: 202.36), controlPoint2: CGPoint(x: 159.95, y: 189.8))
        bezierPath.addCurve(to: CGPoint(x: 172.29, y: 121.78), controlPoint1: CGPoint(x: 189.75, y: 159.78), controlPoint2: CGPoint(x: 189.75, y: 139.34))
        bezierPath.addCurve(to: CGPoint(x: 142.59, y: 91.97), controlPoint1: CGPoint(x: 162.39, y: 111.77), controlPoint2: CGPoint(x: 152.49, y: 101.98))
        bezierPath.addCurve(to: CGPoint(x: 111.94, y: 61.32), controlPoint1: CGPoint(x: 132.38, y: 81.75), controlPoint2: CGPoint(x: 122.26, y: 71.43))
        bezierPath.addCurve(to: CGPoint(x: 57.75, y: 61.42), controlPoint1: CGPoint(x: 95.22, y: 45.03), controlPoint2: CGPoint(x: 74.36, y: 45.03))
        bezierPath.addCurve(to: CGPoint(x: 19.75, y: 99.21), controlPoint1: CGPoint(x: 44.98, y: 73.98), controlPoint2: CGPoint(x: 32.74, y: 86.86))
        bezierPath.addCurve(to: CGPoint(x: 0.38, y: 140.83), controlPoint1: CGPoint(x: 7.72, y: 110.6), controlPoint2: CGPoint(x: 1.65, y: 124.55))
        bezierPath.addCurve(to: CGPoint(x: 14, y: 216.73), controlPoint1: CGPoint(x: -1.65, y: 167.34), controlPoint2: CGPoint(x: 4.85, y: 192.36))
        bezierPath.addCurve(to: CGPoint(x: 95.86, y: 353.1), controlPoint1: CGPoint(x: 32.74, y: 267.19), controlPoint2: CGPoint(x: 61.27, y: 312.01))
        bezierPath.addCurve(to: CGPoint(x: 263.63, y: 484.35), controlPoint1: CGPoint(x: 142.59, y: 408.66), controlPoint2: CGPoint(x: 198.38, y: 452.63))
        bezierPath.addCurve(to: CGPoint(x: 356.56, y: 511.39), controlPoint1: CGPoint(x: 293.01, y: 498.62), controlPoint2: CGPoint(x: 323.46, y: 509.58))
        bezierPath.addCurve(to: CGPoint(x: 415, y: 489.14), controlPoint1: CGPoint(x: 379.34, y: 512.67), controlPoint2: CGPoint(x: 399.14, y: 506.92))
        bezierPath.addCurve(to: CGPoint(x: 449.6, y: 454.33), controlPoint1: CGPoint(x: 425.86, y: 477.01), controlPoint2: CGPoint(x: 438.1, y: 465.94))
        bezierPath.addCurve(to: CGPoint(x: 449.81, y: 399.19), controlPoint1: CGPoint(x: 466.63, y: 437.09), controlPoint2: CGPoint(x: 466.74, y: 416.22))
        bezierPath.addCurve(to: CGPoint(x: 388.92, y: 338.41), controlPoint1: CGPoint(x: 429.59, y: 378.86), controlPoint2: CGPoint(x: 409.25, y: 358.63))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 368.59, y: 253.57))
        bezier2Path.addLine(to: CGPoint(x: 407.87, y: 246.86))
        bezier2Path.addCurve(to: CGPoint(x: 358.8, y: 152.12), controlPoint1: CGPoint(x: 401.7, y: 210.77), controlPoint2: CGPoint(x: 384.66, y: 178.09))
        bezier2Path.addCurve(to: CGPoint(x: 258.73, y: 102.19), controlPoint1: CGPoint(x: 331.44, y: 124.76), controlPoint2: CGPoint(x: 296.84, y: 107.52))
        bezier2Path.addLine(to: CGPoint(x: 253.2, y: 141.69))
        bezier2Path.addCurve(to: CGPoint(x: 330.69, y: 180.33), controlPoint1: CGPoint(x: 282.68, y: 145.84), controlPoint2: CGPoint(x: 309.51, y: 159.14))
        bezier2Path.addCurve(to: CGPoint(x: 368.59, y: 253.57), controlPoint1: CGPoint(x: 350.71, y: 200.34), controlPoint2: CGPoint(x: 363.8, y: 225.68))
        bezier2Path.close()
        fillColor.setFill()
        bezier2Path.fill()

        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 430.01, y: 82.82))
        bezier3Path.addCurve(to: CGPoint(x: 263.95, y: 0), controlPoint1: CGPoint(x: 384.66, y: 37.47), controlPoint2: CGPoint(x: 327.29, y: 8.84))
        bezier3Path.addLine(to: CGPoint(x: 258.41, y: 39.49))
        bezier3Path.addCurve(to: CGPoint(x: 401.91, y: 111.03), controlPoint1: CGPoint(x: 313.13, y: 47.16), controlPoint2: CGPoint(x: 362.74, y: 71.96))
        bezier3Path.addCurve(to: CGPoint(x: 472.27, y: 246.75), controlPoint1: CGPoint(x: 439.06, y: 148.18), controlPoint2: CGPoint(x: 463.44, y: 195.12))
        bezier3Path.addLine(to: CGPoint(x: 511.55, y: 240.05))
        bezier3Path.addCurve(to: CGPoint(x: 430.01, y: 82.82), controlPoint1: CGPoint(x: 501.23, y: 180.22), controlPoint2: CGPoint(x: 473.02, y: 125.93))
        bezier3Path.close()
        fillColor.setFill()
        bezier3Path.fill()
        context.restoreGState()
    }

    private func drawSmartPhone(color: UIColor,
                                targetFrame: CGRect,
                                resizing: ResizingBehavior) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = color

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 402.75, y: 14.34))
        bezierPath.addLine(to: CGPoint(x: 402.75, y: 14.29))
        bezierPath.addCurve(to: CGPoint(x: 368.49, y: 0), controlPoint1: CGPoint(x: 393.68, y: 5.15), controlPoint2: CGPoint(x: 381.35, y: 0.01))
        bezierPath.addLine(to: CGPoint(x: 143.46, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 95, y: 48.57), controlPoint1: CGPoint(x: 116.73, y: 0.09), controlPoint2: CGPoint(x: 95.09, y: 21.78))
        bezierPath.addLine(to: CGPoint(x: 95, y: 463.57))
        bezierPath.addCurve(to: CGPoint(x: 109.25, y: 497.91), controlPoint1: CGPoint(x: 95.01, y: 476.46), controlPoint2: CGPoint(x: 100.13, y: 488.82))
        bezierPath.addCurve(to: CGPoint(x: 143.46, y: 512.2), controlPoint1: CGPoint(x: 118.31, y: 507.04), controlPoint2: CGPoint(x: 130.62, y: 512.18))
        bezierPath.addLine(to: CGPoint(x: 368.54, y: 512.2))
        bezierPath.addCurve(to: CGPoint(x: 402.75, y: 497.91), controlPoint1: CGPoint(x: 381.38, y: 512.18), controlPoint2: CGPoint(x: 393.69, y: 507.04))
        bezierPath.addCurve(to: CGPoint(x: 417, y: 463.63), controlPoint1: CGPoint(x: 411.85, y: 488.83), controlPoint2: CGPoint(x: 416.98, y: 476.5))
        bezierPath.addLine(to: CGPoint(x: 417, y: 48.63))
        bezierPath.addCurve(to: CGPoint(x: 402.75, y: 14.34), controlPoint1: CGPoint(x: 416.98, y: 35.75), controlPoint2: CGPoint(x: 411.85, y: 23.42))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 256, y: 479.24))
        bezierPath.addLine(to: CGPoint(x: 256, y: 479.24))
        bezierPath.addCurve(to: CGPoint(x: 242.91, y: 466.11), controlPoint1: CGPoint(x: 248.77, y: 479.24), controlPoint2: CGPoint(x: 242.91, y: 473.36))
        bezierPath.addCurve(to: CGPoint(x: 256, y: 452.99), controlPoint1: CGPoint(x: 242.91, y: 458.86), controlPoint2: CGPoint(x: 248.77, y: 452.99))
        bezierPath.addCurve(to: CGPoint(x: 269.09, y: 466.11), controlPoint1: CGPoint(x: 263.23, y: 452.99), controlPoint2: CGPoint(x: 269.09, y: 458.86))
        bezierPath.addCurve(to: CGPoint(x: 256, y: 479.24), controlPoint1: CGPoint(x: 269.09, y: 473.36), controlPoint2: CGPoint(x: 263.23, y: 479.24))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 378.52, y: 396.85))
        bezierPath.addCurve(to: CGPoint(x: 346.85, y: 428.6), controlPoint1: CGPoint(x: 378.52, y: 414.38), controlPoint2: CGPoint(x: 364.34, y: 428.6))
        bezierPath.addLine(to: CGPoint(x: 165.1, y: 428.6))
        bezierPath.addCurve(to: CGPoint(x: 133.43, y: 396.85), controlPoint1: CGPoint(x: 147.61, y: 428.6), controlPoint2: CGPoint(x: 133.43, y: 414.38))
        bezierPath.addLine(to: CGPoint(x: 133.43, y: 87.57))
        bezierPath.addCurve(to: CGPoint(x: 165.1, y: 55.82), controlPoint1: CGPoint(x: 133.43, y: 70.04), controlPoint2: CGPoint(x: 147.61, y: 55.82))
        bezierPath.addLine(to: CGPoint(x: 346.9, y: 55.82))
        bezierPath.addCurve(to: CGPoint(x: 378.57, y: 87.57), controlPoint1: CGPoint(x: 364.39, y: 55.82), controlPoint2: CGPoint(x: 378.57, y: 70.04))
        bezierPath.addLine(to: CGPoint(x: 378.52, y: 396.85))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        context.restoreGState()
    }

    private func drawBattery(color: UIColor,
                             targetFrame: CGRect,
                             resizing: ResizingBehavior) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = color

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 352, y: 64))
        bezierPath.addLine(to: CGPoint(x: 320, y: 64))
        bezierPath.addLine(to: CGPoint(x: 320, y: 16))
        bezierPath.addCurve(to: CGPoint(x: 304, y: 0), controlPoint1: CGPoint(x: 320, y: 7.17), controlPoint2: CGPoint(x: 312.83, y: 0))
        bezierPath.addLine(to: CGPoint(x: 208, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 192, y: 16), controlPoint1: CGPoint(x: 199.17, y: 0), controlPoint2: CGPoint(x: 192, y: 7.17))
        bezierPath.addLine(to: CGPoint(x: 192, y: 64))
        bezierPath.addLine(to: CGPoint(x: 160, y: 64))
        bezierPath.addCurve(to: CGPoint(x: 128, y: 96), controlPoint1: CGPoint(x: 142.37, y: 64), controlPoint2: CGPoint(x: 128, y: 78.37))
        bezierPath.addLine(to: CGPoint(x: 128, y: 480))
        bezierPath.addCurve(to: CGPoint(x: 160, y: 512), controlPoint1: CGPoint(x: 128, y: 497.95), controlPoint2: CGPoint(x: 142.05, y: 512))
        bezierPath.addLine(to: CGPoint(x: 352, y: 512))
        bezierPath.addCurve(to: CGPoint(x: 384, y: 480), controlPoint1: CGPoint(x: 369.95, y: 512), controlPoint2: CGPoint(x: 384, y: 497.95))
        bezierPath.addLine(to: CGPoint(x: 384, y: 96))
        bezierPath.addCurve(to: CGPoint(x: 352, y: 64), controlPoint1: CGPoint(x: 384, y: 78.05), controlPoint2: CGPoint(x: 369.95, y: 64))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 256, y: 416))
        bezierPath.addLine(to: CGPoint(x: 256, y: 320))
        bezierPath.addLine(to: CGPoint(x: 192, y: 320))
        bezierPath.addLine(to: CGPoint(x: 256, y: 160))
        bezierPath.addLine(to: CGPoint(x: 256, y: 256))
        bezierPath.addLine(to: CGPoint(x: 320, y: 256))
        bezierPath.addLine(to: CGPoint(x: 256, y: 416))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        context.restoreGState()
    }

    private func drawDisk(color: UIColor,
                          targetFrame: CGRect,
                          resizing: ResizingBehavior) {

        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = color

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 474.03, y: 344))
        bezierPath.addCurve(to: CGPoint(x: 506.61, y: 353.97), controlPoint1: CGPoint(x: 486.09, y: 344), controlPoint2: CGPoint(x: 497.31, y: 347.68))
        bezierPath.addLine(to: CGPoint(x: 442.41, y: 48.37))
        bezierPath.addCurve(to: CGPoint(x: 402.49, y: 16), controlPoint1: CGPoint(x: 438.66, y: 30.49), controlPoint2: CGPoint(x: 420.78, y: 16))
        bezierPath.addLine(to: CGPoint(x: 109.95, y: 16))
        bezierPath.addCurve(to: CGPoint(x: 70.03, y: 48.37), controlPoint1: CGPoint(x: 91.66, y: 16), controlPoint2: CGPoint(x: 73.79, y: 30.49))
        bezierPath.addLine(to: CGPoint(x: 5.84, y: 353.97))
        bezierPath.addCurve(to: CGPoint(x: 38.41, y: 344), controlPoint1: CGPoint(x: 15.14, y: 347.68), controlPoint2: CGPoint(x: 26.36, y: 344))
        bezierPath.addLine(to: CGPoint(x: 474.03, y: 344))
        bezierPath.addLine(to: CGPoint(x: 474.03, y: 344))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 38.42, y: 496.85))
        bezier2Path.addLine(to: CGPoint(x: 474.04, y: 496.85))
        bezier2Path.addCurve(to: CGPoint(x: 512.46, y: 458.48), controlPoint1: CGPoint(x: 495.26, y: 496.85), controlPoint2: CGPoint(x: 512.46, y: 479.67))
        bezier2Path.addLine(to: CGPoint(x: 512.46, y: 402.21))
        bezier2Path.addCurve(to: CGPoint(x: 506.5, y: 381.75), controlPoint1: CGPoint(x: 512.46, y: 394.68), controlPoint2: CGPoint(x: 510.26, y: 387.68))
        bezier2Path.addCurve(to: CGPoint(x: 474.04, y: 363.85), controlPoint1: CGPoint(x: 499.69, y: 371), controlPoint2: CGPoint(x: 487.71, y: 363.85))
        bezier2Path.addLine(to: CGPoint(x: 38.42, y: 363.85))
        bezier2Path.addCurve(to: CGPoint(x: 5.96, y: 381.75), controlPoint1: CGPoint(x: 24.75, y: 363.85), controlPoint2: CGPoint(x: 12.77, y: 371.01))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: 402.21), controlPoint1: CGPoint(x: 2.21, y: 387.68), controlPoint2: CGPoint(x: 0, y: 394.69))
        bezier2Path.addLine(to: CGPoint(x: 0, y: 458.48))
        bezier2Path.addCurve(to: CGPoint(x: 38.42, y: 496.85), controlPoint1: CGPoint(x: 0, y: 479.68), controlPoint2: CGPoint(x: 17.2, y: 496.85))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 446.12, y: 425.11))
        bezier2Path.addLine(to: CGPoint(x: 362.44, y: 425.11))
        bezier2Path.addCurve(to: CGPoint(x: 352.5, y: 415.19), controlPoint1: CGPoint(x: 356.95, y: 425.11), controlPoint2: CGPoint(x: 352.5, y: 420.68))
        bezier2Path.addCurve(to: CGPoint(x: 362.44, y: 405.27), controlPoint1: CGPoint(x: 352.5, y: 409.71), controlPoint2: CGPoint(x: 356.95, y: 405.27))
        bezier2Path.addLine(to: CGPoint(x: 446.12, y: 405.27))
        bezier2Path.addCurve(to: CGPoint(x: 456.06, y: 415.19), controlPoint1: CGPoint(x: 451.61, y: 405.27), controlPoint2: CGPoint(x: 456.06, y: 409.71))
        bezier2Path.addCurve(to: CGPoint(x: 446.12, y: 425.11), controlPoint1: CGPoint(x: 456.06, y: 420.68), controlPoint2: CGPoint(x: 451.61, y: 425.11))
        bezier2Path.close()
        fillColor.setFill()
        bezier2Path.fill()

        context.restoreGState()
    }

    private func drawChip(color: UIColor,
                          targetFrame: CGRect,
                          resizing: ResizingBehavior) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = color

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 500.69, y: 197.95))
        bezierPath.addCurve(to: CGPoint(x: 512.33, y: 186.3), controlPoint1: CGPoint(x: 507.13, y: 197.95), controlPoint2: CGPoint(x: 512.33, y: 192.74))
        bezierPath.addCurve(to: CGPoint(x: 500.69, y: 174.66), controlPoint1: CGPoint(x: 512.33, y: 179.87), controlPoint2: CGPoint(x: 507.13, y: 174.66))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 174.66))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 128.08))
        bezierPath.addLine(to: CGPoint(x: 500.69, y: 128.08))
        bezierPath.addCurve(to: CGPoint(x: 512.33, y: 116.44), controlPoint1: CGPoint(x: 507.13, y: 128.08), controlPoint2: CGPoint(x: 512.33, y: 122.87))
        bezierPath.addCurve(to: CGPoint(x: 500.69, y: 104.8), controlPoint1: CGPoint(x: 512.33, y: 110), controlPoint2: CGPoint(x: 507.13, y: 104.8))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 104.8))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 93.15))
        bezierPath.addCurve(to: CGPoint(x: 419.18, y: 46.58), controlPoint1: CGPoint(x: 465.76, y: 67.46), controlPoint2: CGPoint(x: 444.87, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 407.54, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 407.54, y: 11.64))
        bezierPath.addCurve(to: CGPoint(x: 395.89, y: 0), controlPoint1: CGPoint(x: 407.54, y: 5.21), controlPoint2: CGPoint(x: 402.33, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 384.25, y: 11.64), controlPoint1: CGPoint(x: 389.46, y: 0), controlPoint2: CGPoint(x: 384.25, y: 5.21))
        bezierPath.addLine(to: CGPoint(x: 384.25, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 337.67, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 337.67, y: 11.64))
        bezierPath.addCurve(to: CGPoint(x: 326.03, y: 0), controlPoint1: CGPoint(x: 337.67, y: 5.21), controlPoint2: CGPoint(x: 332.47, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 314.39, y: 11.64), controlPoint1: CGPoint(x: 319.6, y: 0), controlPoint2: CGPoint(x: 314.39, y: 5.21))
        bezierPath.addLine(to: CGPoint(x: 314.39, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 267.81, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 267.81, y: 11.64))
        bezierPath.addCurve(to: CGPoint(x: 256.17, y: 0), controlPoint1: CGPoint(x: 267.81, y: 5.21), controlPoint2: CGPoint(x: 262.6, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 244.52, y: 11.64), controlPoint1: CGPoint(x: 249.73, y: 0), controlPoint2: CGPoint(x: 244.52, y: 5.21))
        bezierPath.addLine(to: CGPoint(x: 244.52, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 197.95, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 197.95, y: 11.64))
        bezierPath.addCurve(to: CGPoint(x: 186.3, y: 0), controlPoint1: CGPoint(x: 197.95, y: 5.21), controlPoint2: CGPoint(x: 192.74, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 174.66, y: 11.64), controlPoint1: CGPoint(x: 179.87, y: 0), controlPoint2: CGPoint(x: 174.66, y: 5.21))
        bezierPath.addLine(to: CGPoint(x: 174.66, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 128.08, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 128.08, y: 11.64))
        bezierPath.addCurve(to: CGPoint(x: 116.44, y: 0), controlPoint1: CGPoint(x: 128.08, y: 5.21), controlPoint2: CGPoint(x: 122.87, y: 0))
        bezierPath.addCurve(to: CGPoint(x: 104.8, y: 11.64), controlPoint1: CGPoint(x: 110, y: 0), controlPoint2: CGPoint(x: 104.8, y: 5.21))
        bezierPath.addLine(to: CGPoint(x: 104.8, y: 46.58))
        bezierPath.addLine(to: CGPoint(x: 93.15, y: 46.58))
        bezierPath.addCurve(to: CGPoint(x: 46.58, y: 93.15), controlPoint1: CGPoint(x: 67.46, y: 46.58), controlPoint2: CGPoint(x: 46.58, y: 67.46))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 104.8))
        bezierPath.addLine(to: CGPoint(x: 11.64, y: 104.8))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 116.44), controlPoint1: CGPoint(x: 5.21, y: 104.8), controlPoint2: CGPoint(x: 0, y: 110))
        bezierPath.addCurve(to: CGPoint(x: 11.64, y: 128.08), controlPoint1: CGPoint(x: 0, y: 122.88), controlPoint2: CGPoint(x: 5.21, y: 128.08))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 128.08))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 174.66))
        bezierPath.addLine(to: CGPoint(x: 11.64, y: 174.66))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 186.3), controlPoint1: CGPoint(x: 5.21, y: 174.66), controlPoint2: CGPoint(x: 0, y: 179.87))
        bezierPath.addCurve(to: CGPoint(x: 11.64, y: 197.95), controlPoint1: CGPoint(x: 0, y: 192.74), controlPoint2: CGPoint(x: 5.21, y: 197.95))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 197.95))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 244.52))
        bezierPath.addLine(to: CGPoint(x: 11.64, y: 244.52))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 256.17), controlPoint1: CGPoint(x: 5.21, y: 244.52), controlPoint2: CGPoint(x: 0, y: 249.73))
        bezierPath.addCurve(to: CGPoint(x: 11.64, y: 267.81), controlPoint1: CGPoint(x: 0, y: 262.6), controlPoint2: CGPoint(x: 5.21, y: 267.81))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 267.81))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 314.39))
        bezierPath.addLine(to: CGPoint(x: 11.64, y: 314.39))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 326.03), controlPoint1: CGPoint(x: 5.21, y: 314.39), controlPoint2: CGPoint(x: 0, y: 319.59))
        bezierPath.addCurve(to: CGPoint(x: 11.64, y: 337.67), controlPoint1: CGPoint(x: 0, y: 332.47), controlPoint2: CGPoint(x: 5.21, y: 337.67))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 337.67))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 384.25))
        bezierPath.addLine(to: CGPoint(x: 11.64, y: 384.25))
        bezierPath.addCurve(to: CGPoint(x: 0, y: 395.89), controlPoint1: CGPoint(x: 5.21, y: 384.25), controlPoint2: CGPoint(x: 0, y: 389.46))
        bezierPath.addCurve(to: CGPoint(x: 11.64, y: 407.54), controlPoint1: CGPoint(x: 0, y: 402.33), controlPoint2: CGPoint(x: 5.21, y: 407.54))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 407.54))
        bezierPath.addLine(to: CGPoint(x: 46.58, y: 419.18))
        bezierPath.addCurve(to: CGPoint(x: 93.15, y: 465.76), controlPoint1: CGPoint(x: 46.58, y: 444.87), controlPoint2: CGPoint(x: 67.46, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 104.8, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 104.8, y: 500.69))
        bezierPath.addCurve(to: CGPoint(x: 116.44, y: 512.33), controlPoint1: CGPoint(x: 104.8, y: 507.13), controlPoint2: CGPoint(x: 110, y: 512.33))
        bezierPath.addCurve(to: CGPoint(x: 128.08, y: 500.69), controlPoint1: CGPoint(x: 122.88, y: 512.33), controlPoint2: CGPoint(x: 128.08, y: 507.13))
        bezierPath.addLine(to: CGPoint(x: 128.08, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 174.66, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 174.66, y: 500.69))
        bezierPath.addCurve(to: CGPoint(x: 186.3, y: 512.33), controlPoint1: CGPoint(x: 174.66, y: 507.13), controlPoint2: CGPoint(x: 179.87, y: 512.33))
        bezierPath.addCurve(to: CGPoint(x: 197.95, y: 500.69), controlPoint1: CGPoint(x: 192.74, y: 512.33), controlPoint2: CGPoint(x: 197.95, y: 507.13))
        bezierPath.addLine(to: CGPoint(x: 197.95, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 244.52, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 244.52, y: 500.69))
        bezierPath.addCurve(to: CGPoint(x: 256.17, y: 512.33), controlPoint1: CGPoint(x: 244.52, y: 507.13), controlPoint2: CGPoint(x: 249.73, y: 512.33))
        bezierPath.addCurve(to: CGPoint(x: 267.81, y: 500.69), controlPoint1: CGPoint(x: 262.6, y: 512.33), controlPoint2: CGPoint(x: 267.81, y: 507.13))
        bezierPath.addLine(to: CGPoint(x: 267.81, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 314.39, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 314.39, y: 500.69))
        bezierPath.addCurve(to: CGPoint(x: 326.03, y: 512.33), controlPoint1: CGPoint(x: 314.39, y: 507.13), controlPoint2: CGPoint(x: 319.59, y: 512.33))
        bezierPath.addCurve(to: CGPoint(x: 337.67, y: 500.69), controlPoint1: CGPoint(x: 332.47, y: 512.33), controlPoint2: CGPoint(x: 337.67, y: 507.13))
        bezierPath.addLine(to: CGPoint(x: 337.67, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 384.25, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 384.25, y: 500.69))
        bezierPath.addCurve(to: CGPoint(x: 395.89, y: 512.33), controlPoint1: CGPoint(x: 384.25, y: 507.13), controlPoint2: CGPoint(x: 389.46, y: 512.33))
        bezierPath.addCurve(to: CGPoint(x: 407.54, y: 500.69), controlPoint1: CGPoint(x: 402.33, y: 512.33), controlPoint2: CGPoint(x: 407.54, y: 507.13))
        bezierPath.addLine(to: CGPoint(x: 407.54, y: 465.76))
        bezierPath.addLine(to: CGPoint(x: 419.18, y: 465.76))
        bezierPath.addCurve(to: CGPoint(x: 465.76, y: 419.18), controlPoint1: CGPoint(x: 444.87, y: 465.76), controlPoint2: CGPoint(x: 465.76, y: 444.87))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 407.54))
        bezierPath.addLine(to: CGPoint(x: 500.69, y: 407.54))
        bezierPath.addCurve(to: CGPoint(x: 512.33, y: 395.89), controlPoint1: CGPoint(x: 507.13, y: 407.54), controlPoint2: CGPoint(x: 512.33, y: 402.33))
        bezierPath.addCurve(to: CGPoint(x: 500.69, y: 384.25), controlPoint1: CGPoint(x: 512.33, y: 389.46), controlPoint2: CGPoint(x: 507.13, y: 384.25))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 384.25))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 337.67))
        bezierPath.addLine(to: CGPoint(x: 500.69, y: 337.67))
        bezierPath.addCurve(to: CGPoint(x: 512.33, y: 326.03), controlPoint1: CGPoint(x: 507.13, y: 337.67), controlPoint2: CGPoint(x: 512.33, y: 332.46))
        bezierPath.addCurve(to: CGPoint(x: 500.69, y: 314.39), controlPoint1: CGPoint(x: 512.33, y: 319.59), controlPoint2: CGPoint(x: 507.13, y: 314.39))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 314.39))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 267.81))
        bezierPath.addLine(to: CGPoint(x: 500.69, y: 267.81))
        bezierPath.addCurve(to: CGPoint(x: 512.33, y: 256.17), controlPoint1: CGPoint(x: 507.13, y: 267.81), controlPoint2: CGPoint(x: 512.33, y: 262.6))
        bezierPath.addCurve(to: CGPoint(x: 500.69, y: 244.52), controlPoint1: CGPoint(x: 512.33, y: 249.73), controlPoint2: CGPoint(x: 507.13, y: 244.52))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 244.52))
        bezierPath.addLine(to: CGPoint(x: 465.76, y: 197.95))
        bezierPath.addLine(to: CGPoint(x: 500.69, y: 197.95))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 419.18, y: 407.54))
        bezierPath.addCurve(to: CGPoint(x: 407.54, y: 419.18), controlPoint1: CGPoint(x: 419.18, y: 413.97), controlPoint2: CGPoint(x: 413.97, y: 419.18))
        bezierPath.addLine(to: CGPoint(x: 104.8, y: 419.18))
        bezierPath.addCurve(to: CGPoint(x: 93.15, y: 407.54), controlPoint1: CGPoint(x: 98.36, y: 419.18), controlPoint2: CGPoint(x: 93.15, y: 413.97))
        bezierPath.addLine(to: CGPoint(x: 93.15, y: 104.8))
        bezierPath.addCurve(to: CGPoint(x: 104.8, y: 93.15), controlPoint1: CGPoint(x: 93.15, y: 98.36), controlPoint2: CGPoint(x: 98.36, y: 93.15))
        bezierPath.addLine(to: CGPoint(x: 407.54, y: 93.15))
        bezierPath.addCurve(to: CGPoint(x: 419.18, y: 104.8), controlPoint1: CGPoint(x: 413.97, y: 93.15), controlPoint2: CGPoint(x: 419.18, y: 98.36))
        bezierPath.addLine(to: CGPoint(x: 419.18, y: 407.54))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        let rectanglePath = UIBezierPath(rect: CGRect(x: 116.67, y: 116.67, width: 279, height: 279))
        fillColor.setFill()
        rectanglePath.fill()

        context.restoreGState()
    }

    private func drawCellularTower(color: UIColor,
                                   targetFrame: CGRect,
                                   resizing: ResizingBehavior) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = color

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 170.87, y: 177.65))
        bezierPath.addCurve(to: CGPoint(x: 182.87, y: 183.63), controlPoint1: CGPoint(x: 173.82, y: 181.56), controlPoint2: CGPoint(x: 178.31, y: 183.63))
        bezierPath.addCurve(to: CGPoint(x: 191.87, y: 180.62), controlPoint1: CGPoint(x: 186, y: 183.63), controlPoint2: CGPoint(x: 189.17, y: 182.65))
        bezierPath.addCurve(to: CGPoint(x: 194.84, y: 159.62), controlPoint1: CGPoint(x: 198.49, y: 175.64), controlPoint2: CGPoint(x: 199.82, y: 166.23))
        bezierPath.addCurve(to: CGPoint(x: 179.48, y: 113.62), controlPoint1: CGPoint(x: 184.94, y: 146.44), controlPoint2: CGPoint(x: 179.48, y: 130.11))
        bezierPath.addCurve(to: CGPoint(x: 196.81, y: 65.12), controlPoint1: CGPoint(x: 179.48, y: 95.99), controlPoint2: CGPoint(x: 185.63, y: 78.76))
        bezierPath.addCurve(to: CGPoint(x: 194.71, y: 44.01), controlPoint1: CGPoint(x: 202.06, y: 58.72), controlPoint2: CGPoint(x: 201.12, y: 49.26))
        bezierPath.addCurve(to: CGPoint(x: 173.61, y: 46.11), controlPoint1: CGPoint(x: 188.31, y: 38.77), controlPoint2: CGPoint(x: 178.86, y: 39.7))
        bezierPath.addCurve(to: CGPoint(x: 149.48, y: 113.62), controlPoint1: CGPoint(x: 158.05, y: 65.1), controlPoint2: CGPoint(x: 149.48, y: 89.07))
        bezierPath.addCurve(to: CGPoint(x: 170.87, y: 177.65), controlPoint1: CGPoint(x: 149.48, y: 136.57), controlPoint2: CGPoint(x: 157.08, y: 159.31))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 138.84, y: 223.88))
        bezier2Path.addCurve(to: CGPoint(x: 148.29, y: 220.52), controlPoint1: CGPoint(x: 142.17, y: 223.88), controlPoint2: CGPoint(x: 145.51, y: 222.78))
        bezier2Path.addCurve(to: CGPoint(x: 150.47, y: 199.42), controlPoint1: CGPoint(x: 154.72, y: 215.3), controlPoint2: CGPoint(x: 155.69, y: 205.85))
        bezier2Path.addCurve(to: CGPoint(x: 119.99, y: 113.62), controlPoint1: CGPoint(x: 130.81, y: 175.25), controlPoint2: CGPoint(x: 119.99, y: 144.78))
        bezier2Path.addCurve(to: CGPoint(x: 153.01, y: 24.79), controlPoint1: CGPoint(x: 119.99, y: 81.03), controlPoint2: CGPoint(x: 131.72, y: 49.48))
        bezier2Path.addCurve(to: CGPoint(x: 151.44, y: 3.64), controlPoint1: CGPoint(x: 158.41, y: 18.52), controlPoint2: CGPoint(x: 157.71, y: 9.05))
        bezier2Path.addCurve(to: CGPoint(x: 130.29, y: 5.2), controlPoint1: CGPoint(x: 145.17, y: -1.76), controlPoint2: CGPoint(x: 135.7, y: -1.07))
        bezier2Path.addCurve(to: CGPoint(x: 90, y: 113.62), controlPoint1: CGPoint(x: 104.31, y: 35.33), controlPoint2: CGPoint(x: 90, y: 73.84))
        bezier2Path.addCurve(to: CGPoint(x: 127.2, y: 218.35), controlPoint1: CGPoint(x: 90, y: 151.65), controlPoint2: CGPoint(x: 103.21, y: 188.84))
        bezier2Path.addCurve(to: CGPoint(x: 138.84, y: 223.88), controlPoint1: CGPoint(x: 130.16, y: 221.99), controlPoint2: CGPoint(x: 134.48, y: 223.88))
        bezier2Path.close()
        fillColor.setFill()
        bezier2Path.fill()

        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 332.56, y: 113.62))
        bezier3Path.addCurve(to: CGPoint(x: 317.19, y: 159.62), controlPoint1: CGPoint(x: 332.56, y: 130.11), controlPoint2: CGPoint(x: 327.11, y: 146.44))
        bezier3Path.addCurve(to: CGPoint(x: 320.17, y: 180.62), controlPoint1: CGPoint(x: 312.22, y: 166.24), controlPoint2: CGPoint(x: 313.55, y: 175.64))
        bezier3Path.addCurve(to: CGPoint(x: 329.17, y: 183.63), controlPoint1: CGPoint(x: 322.87, y: 182.65), controlPoint2: CGPoint(x: 326.03, y: 183.63))
        bezier3Path.addCurve(to: CGPoint(x: 341.17, y: 177.65), controlPoint1: CGPoint(x: 333.72, y: 183.63), controlPoint2: CGPoint(x: 338.22, y: 181.56))
        bezier3Path.addCurve(to: CGPoint(x: 362.55, y: 113.62), controlPoint1: CGPoint(x: 354.96, y: 159.31), controlPoint2: CGPoint(x: 362.55, y: 136.57))
        bezier3Path.addCurve(to: CGPoint(x: 338.43, y: 46.11), controlPoint1: CGPoint(x: 362.55, y: 89.07), controlPoint2: CGPoint(x: 353.99, y: 65.1))
        bezier3Path.addCurve(to: CGPoint(x: 317.32, y: 44.01), controlPoint1: CGPoint(x: 333.18, y: 39.7), controlPoint2: CGPoint(x: 323.73, y: 38.77))
        bezier3Path.addCurve(to: CGPoint(x: 315.23, y: 65.12), controlPoint1: CGPoint(x: 310.92, y: 49.26), controlPoint2: CGPoint(x: 309.98, y: 58.71))
        bezier3Path.addCurve(to: CGPoint(x: 332.56, y: 113.62), controlPoint1: CGPoint(x: 326.41, y: 78.76), controlPoint2: CGPoint(x: 332.56, y: 95.99))
        bezier3Path.close()
        fillColor.setFill()
        bezier3Path.fill()

        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 392.04, y: 113.62))
        bezier4Path.addCurve(to: CGPoint(x: 361.57, y: 199.42), controlPoint1: CGPoint(x: 392.04, y: 144.78), controlPoint2: CGPoint(x: 381.22, y: 175.25))
        bezier4Path.addCurve(to: CGPoint(x: 363.75, y: 220.52), controlPoint1: CGPoint(x: 356.34, y: 205.85), controlPoint2: CGPoint(x: 357.32, y: 215.3))
        bezier4Path.addCurve(to: CGPoint(x: 373.2, y: 223.88), controlPoint1: CGPoint(x: 366.53, y: 222.78), controlPoint2: CGPoint(x: 369.87, y: 223.88))
        bezier4Path.addCurve(to: CGPoint(x: 384.84, y: 218.34), controlPoint1: CGPoint(x: 377.55, y: 223.88), controlPoint2: CGPoint(x: 381.88, y: 221.99))
        bezier4Path.addCurve(to: CGPoint(x: 422.04, y: 113.62), controlPoint1: CGPoint(x: 408.83, y: 188.84), controlPoint2: CGPoint(x: 422.04, y: 151.65))
        bezier4Path.addCurve(to: CGPoint(x: 381.75, y: 5.2), controlPoint1: CGPoint(x: 422.04, y: 73.83), controlPoint2: CGPoint(x: 407.73, y: 35.33))
        bezier4Path.addCurve(to: CGPoint(x: 360.59, y: 3.64), controlPoint1: CGPoint(x: 376.34, y: -1.07), controlPoint2: CGPoint(x: 366.87, y: -1.77))
        bezier4Path.addCurve(to: CGPoint(x: 359.03, y: 24.79), controlPoint1: CGPoint(x: 354.32, y: 9.05), controlPoint2: CGPoint(x: 353.63, y: 18.52))
        bezier4Path.addCurve(to: CGPoint(x: 392.04, y: 113.62), controlPoint1: CGPoint(x: 380.32, y: 49.48), controlPoint2: CGPoint(x: 392.04, y: 81.03))
        bezier4Path.close()
        fillColor.setFill()
        bezier4Path.fill()

        let bezier5Path = UIBezierPath()
        bezier5Path.move(to: CGPoint(x: 397, y: 481.67))
        bezier5Path.addLine(to: CGPoint(x: 354.9, y: 481.67))
        bezier5Path.addLine(to: CGPoint(x: 278.27, y: 155.04))
        bezier5Path.addCurve(to: CGPoint(x: 303.03, y: 113.62), controlPoint1: CGPoint(x: 293, y: 147.08), controlPoint2: CGPoint(x: 303.03, y: 131.5))
        bezier5Path.addCurve(to: CGPoint(x: 256, y: 66.59), controlPoint1: CGPoint(x: 303.03, y: 87.69), controlPoint2: CGPoint(x: 281.93, y: 66.59))
        bezier5Path.addCurve(to: CGPoint(x: 208.97, y: 113.62), controlPoint1: CGPoint(x: 230.07, y: 66.59), controlPoint2: CGPoint(x: 208.97, y: 87.69))
        bezier5Path.addCurve(to: CGPoint(x: 233.72, y: 155.04), controlPoint1: CGPoint(x: 208.97, y: 131.5), controlPoint2: CGPoint(x: 219, y: 147.08))
        bezier5Path.addLine(to: CGPoint(x: 157.09, y: 481.67))
        bezier5Path.addLine(to: CGPoint(x: 115.08, y: 481.67))
        bezier5Path.addCurve(to: CGPoint(x: 100.08, y: 496.67), controlPoint1: CGPoint(x: 106.79, y: 481.67), controlPoint2: CGPoint(x: 100.08, y: 488.39))
        bezier5Path.addCurve(to: CGPoint(x: 115.08, y: 511.66), controlPoint1: CGPoint(x: 100.08, y: 504.95), controlPoint2: CGPoint(x: 106.79, y: 511.66))
        bezier5Path.addLine(to: CGPoint(x: 397, y: 511.66))
        bezier5Path.addCurve(to: CGPoint(x: 412, y: 496.67), controlPoint1: CGPoint(x: 405.28, y: 511.66), controlPoint2: CGPoint(x: 412, y: 504.95))
        bezier5Path.addCurve(to: CGPoint(x: 397, y: 481.67), controlPoint1: CGPoint(x: 412, y: 488.39), controlPoint2: CGPoint(x: 405.28, y: 481.67))
        bezier5Path.close()
        bezier5Path.move(to: CGPoint(x: 295.79, y: 361.03))
        bezier5Path.addLine(to: CGPoint(x: 238.45, y: 326.84))
        bezier5Path.addLine(to: CGPoint(x: 281.81, y: 301.43))
        bezier5Path.addLine(to: CGPoint(x: 295.79, y: 361.03))
        bezier5Path.close()
        bezier5Path.move(to: CGPoint(x: 256, y: 96.59))
        bezier5Path.addCurve(to: CGPoint(x: 273.04, y: 113.62), controlPoint1: CGPoint(x: 265.39, y: 96.59), controlPoint2: CGPoint(x: 273.04, y: 104.23))
        bezier5Path.addCurve(to: CGPoint(x: 256, y: 130.66), controlPoint1: CGPoint(x: 273.04, y: 123.02), controlPoint2: CGPoint(x: 265.39, y: 130.66))
        bezier5Path.addCurve(to: CGPoint(x: 238.96, y: 113.62), controlPoint1: CGPoint(x: 246.61, y: 130.66), controlPoint2: CGPoint(x: 238.96, y: 123.02))
        bezier5Path.addCurve(to: CGPoint(x: 256, y: 96.59), controlPoint1: CGPoint(x: 238.96, y: 104.23), controlPoint2: CGPoint(x: 246.61, y: 96.59))
        bezier5Path.close()
        bezier5Path.move(to: CGPoint(x: 256, y: 191.4))
        bezier5Path.addLine(to: CGPoint(x: 274.64, y: 270.87))
        bezier5Path.addLine(to: CGPoint(x: 231.41, y: 296.2))
        bezier5Path.addLine(to: CGPoint(x: 256, y: 191.4))
        bezier5Path.close()
        bezier5Path.move(to: CGPoint(x: 218.78, y: 350.04))
        bezier5Path.addLine(to: CGPoint(x: 288.98, y: 391.89))
        bezier5Path.addLine(to: CGPoint(x: 196.07, y: 446.85))
        bezier5Path.addLine(to: CGPoint(x: 218.78, y: 350.04))
        bezier5Path.close()
        bezier5Path.move(to: CGPoint(x: 196.11, y: 481.67))
        bezier5Path.addLine(to: CGPoint(x: 308.5, y: 415.19))
        bezier5Path.addLine(to: CGPoint(x: 324.09, y: 481.67))
        bezier5Path.addLine(to: CGPoint(x: 196.11, y: 481.67))
        bezier5Path.close()
        fillColor.setFill()
        bezier5Path.fill()

        context.restoreGState()
    }

    private func drawWifi(color: UIColor,
                          targetFrame: CGRect,
                          resizing: ResizingBehavior) {
        let context = UIGraphicsGetCurrentContext()!

        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 512, height: 512), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 512, y: resizedFrame.height / 512)

        let fillColor = color

        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 186.3, y: 369.81))
        bezierPath.addLine(to: CGPoint(x: 256.17, y: 439.6))
        bezierPath.addLine(to: CGPoint(x: 326.03, y: 369.81))
        bezierPath.addCurve(to: CGPoint(x: 186.3, y: 369.81), controlPoint1: CGPoint(x: 287.49, y: 331.32), controlPoint2: CGPoint(x: 224.84, y: 331.32))
        bezierPath.close()
        fillColor.setFill()
        bezierPath.fill()

        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 93.15, y: 276.77))
        bezier2Path.addLine(to: CGPoint(x: 139.73, y: 323.29))
        bezier2Path.addCurve(to: CGPoint(x: 372.61, y: 323.29), controlPoint1: CGPoint(x: 204, y: 259.09), controlPoint2: CGPoint(x: 308.33, y: 259.09))
        bezier2Path.addLine(to: CGPoint(x: 419.18, y: 276.77))
        bezier2Path.addCurve(to: CGPoint(x: 93.15, y: 276.77), controlPoint1: CGPoint(x: 329.17, y: 186.86), controlPoint2: CGPoint(x: 183.16, y: 186.86))
        bezier2Path.close()
        fillColor.setFill()
        bezier2Path.fill()

        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 0, y: 183.72))
        bezier3Path.addLine(to: CGPoint(x: 46.58, y: 230.24))
        bezier3Path.addCurve(to: CGPoint(x: 465.76, y: 230.24), controlPoint1: CGPoint(x: 162.32, y: 114.63), controlPoint2: CGPoint(x: 350.02, y: 114.63))
        bezier3Path.addLine(to: CGPoint(x: 512.33, y: 183.72))
        bezier3Path.addCurve(to: CGPoint(x: 0, y: 183.72), controlPoint1: CGPoint(x: 370.86, y: 42.4), controlPoint2: CGPoint(x: 141.47, y: 42.4))
        bezier3Path.close()
        fillColor.setFill()
        bezier3Path.fill()

        context.restoreGState()
    }

}
