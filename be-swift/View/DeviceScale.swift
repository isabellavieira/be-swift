//
//  DeviceScale.swift
//  be-swift
//
//  Created by Mariana Meireles on 11/10/17.
//  Copyright © 2017 Isabella Vieira. All rights reserved.
//

import Foundation
import UIKit

public extension UIScreen{
    
    class func changeScale(vector: CGRect) -> CGRect{
        
        //Referencia ao IphoneSE no Sketch
        let widhtiPhoneSE: CGFloat = 320
        let heightiPhoneSE: CGFloat = 568
        
        //Tamanho da tela
        let screenSize = UIScreen.main.bounds
        
        //Nova proporção
        let xScale = screenSize.width/widhtiPhoneSE
        let yScale = screenSize.height/heightiPhoneSE
        
        //Transformar o vetor do Input
        let newVector = CGRect(x: vector.origin.x*xScale, y: vector.origin.y*yScale, width: vector.width*xScale, height: vector.height*yScale)
        
        return newVector
    }
    
    class func changeScaleSize(vector: CGSize) -> CGSize{
        
        //Referencia ao IphoneSE no Sketch
        let widhtiPhoneSE: CGFloat = 320
        let heightiPhoneSE: CGFloat = 568
        
        //Tamanho da tela
        let screenSize = UIScreen.main.bounds
        
        //Nova proporção
        let xScale = screenSize.width/widhtiPhoneSE
        let yScale = screenSize.height/heightiPhoneSE
        
        //Transformar o vetor do Input
        let newVector = CGSize(width: vector.width*xScale, height: vector.height*yScale)
        
        return newVector
    }
}
