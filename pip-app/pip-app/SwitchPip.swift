//
//  SwitchPip.swift
//  pip-app
//
//  Created by Peter Slattery on 4/8/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import Foundation

class SwitchPip: BasePip {
	
	private var output = true
	
	init(vc: ViewController, id: Int){
		super.init(vc: vc, pipType: .Switch, id: id)
	}
	
	func switchStateChange() -> Bool{
		output = !output
		updateReliantPips()
		return output
	}
	
	func getOutput() -> Bool{
		return output
	}
	
}