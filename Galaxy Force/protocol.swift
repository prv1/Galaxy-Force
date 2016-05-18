//
//  protocol.swift
//  Galaxy Force
//
//  Created by Phillip Viau on 5/18/16.
//  Copyright © 2016 phillipviau. All rights reserved.
//

import Foundation
import SpriteKit




protocol pWeapon {
    
    func shoot(target: pTargetable)
}

protocol pTargetable {
    
    var health: Float { get set }
    //var ships: Int { get set }
    func takeDamage(damage: Float)
}

class Gun: pWeapon {
    func shoot(target: pTargetable) {
        target.takeDamage(1.0)
    }
}