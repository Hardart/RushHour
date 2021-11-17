//
//  UIView anchors.swift
//  RushHour
//
//  Created by Артем Шакиров on 12.11.2021.
//

import Foundation
import UIKit

extension UIView {
    public var width: CGFloat {
        return self.frame.width
    }
    public var height: CGFloat {
        return self.frame.height
    }
    public var top: CGFloat {
        return self.frame.origin.y
    }
    public var bottom: CGFloat {
        return self.frame.height + self.frame.origin.y
    }
    public var left: CGFloat {
        return self.frame.origin.x
    }
    public var right: CGFloat {
        return self.frame.width + self.frame.origin.x
    }
    
    func anchors(centerX: NSLayoutXAxisAnchor? = nil,
                centerY: NSLayoutYAxisAnchor? = nil,
                top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: NSLayoutDimension? = nil,
                height: NSLayoutDimension? = nil,
                widthConst: CGFloat? = nil,
                heightConst: CGFloat? = nil,
                widthMultiplayer: CGFloat = 1,
                heightMultiplayer: CGFloat = 1)
    {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalTo: width, multiplier: widthMultiplayer).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalTo: height, multiplier: heightMultiplayer).isActive = true
        }
        
        if let widthConst = widthConst {
            widthAnchor.constraint(equalToConstant: widthConst).isActive = true
        }
        
        if let heightConst = heightConst {
            heightAnchor.constraint(equalToConstant: heightConst).isActive = true
        }
        
    }
}

