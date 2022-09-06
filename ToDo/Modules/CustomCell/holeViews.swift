//
//  holeViews.swift
//  ToDo
//
//  Created by Антон on 05.09.2022.
//

import Foundation
import UIKit

import UIKit

struct TransparentPart {
		var rect: CGRect
		var cornerRadius: CGFloat
}


class PartiallyTransparentView: UIView {
		var transparentParts: [TransparentPart] = []

		override func draw(_ rect: CGRect) {
				super.draw(rect)

				backgroundColor?.setFill()
				UIRectFill(rect)

				let clipPath = UIBezierPath(rect: self.bounds)

				for part in transparentParts {
						let holeRect = part.rect
						let radius = part.cornerRadius

						let path = UIBezierPath(roundedRect: holeRect, cornerRadius: radius)

						clipPath.append(path)
				}

				let layer = CAShapeLayer()
				layer.path = clipPath.cgPath
			  layer.fillRule = CAShapeLayerFillRule.evenOdd
				self.layer.mask = layer
				self.layer.masksToBounds = true
		}
}

//class PartialTransparentMaskView: UIView {
//		var transparentRects: Array<CGRect>?
//		var transparentCircles: Array<CGRect>?
//		weak var targetView: UIView?
//
//		init(frame: CGRect, backgroundColor: UIColor?, transparentRects: Array<CGRect>?, transparentCircles: Array<CGRect>?, targetView: UIView?) {
//				super.init(frame: frame)
//
//				if((backgroundColor) != nil){
//						self.backgroundColor = backgroundColor
//				}
//
//				self.transparentRects = transparentRects
//				self.transparentCircles = transparentCircles
//				self.targetView = targetView
//			  self.isOpaque = false
//		}
//
//		required init(coder aDecoder: NSCoder) {
//				fatalError("init(coder:) has not been implemented")
//		}
//
//	override func draw(_ rect: CGRect) {
//				backgroundColor?.setFill()
//				UIRectFill(rect)
//
//				// clear the background in the given rectangles
//				if let rects = transparentRects {
//						for aRect in rects {
//
//							let holeRectIntersection = aRect.intersection( rect )
//
//							UIColor.clear.setFill();
//								UIRectFill(holeRectIntersection);
//						}
//				}
//
//				if let circles = transparentCircles {
//						for aRect in circles {
//
//							let holeRectIntersection = aRect
//
//								let context = UIGraphicsGetCurrentContext();
//
//							if( holeRectIntersection.intersects( rect ) )
//								{
//								context!.addEllipse(in: holeRectIntersection)
//								context!.clip()
//								context!.clear(holeRectIntersection)
//								context!.setFillColor( UIColor.clear.cgColor)
//								context!.fill(holeRectIntersection)
//								}
//						}
//				}
//		}
//}
