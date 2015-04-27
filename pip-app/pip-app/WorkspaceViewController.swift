//
//  WorkspaceViewController.swift
//  pip-app
//
//  Created by Peter Slattery on 4/5/15.
//  Copyright (c) 2015 Peter Slattery. All rights reserved.
//

import UIKit

class WorkspaceViewController: UIViewController, UIScrollViewDelegate {
	
	@IBOutlet var scrollView: UIScrollView!
	
	var containerView: UIView!
	var staticScreenElements: [(view: UIView, pos: CGPoint)] = []
	var trashCanButton: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		_mainPipDirectory.registerViewController(self)
		
		/* -------------------
			Scroll View Setup
		   ------------------- */
	
		containerView = UIView(frame: CGRectMake(0, 0, 1440, 2880))
		scrollView.addSubview(containerView)
		containerView.setNeedsDisplay()
		
		var backgroundView = UIView(frame: CGRectMake(0, 0, 1440, 2880))
		backgroundView.backgroundColor = UIColor.whiteColor()
		containerView.addSubview(backgroundView)
		
		scrollView.contentSize = containerView.bounds.size
		
		/*  -------------------
			 Menu's Setup
			------------------- */
		
		// Add Menus
		// first so that they are under buttons
		let pipMenuPos = CGPoint(x: 0, y: 0)
		var pipMenu = CanvasMenuView.makePipMenu(pipMenuPos)
		let pipMenuTuple: (view: UIView, pos: CGPoint) = (view: pipMenu, pos: pipMenuPos)
		staticScreenElements.append(pipMenuTuple)
		
		
		scrollView.addSubview(pipMenu)
		
		/*  -------------------
			 Scroll View Setup
			------------------- */
		
		// Add Menu Buttons
		// second so that they are on top of menus
		
		// Pip Menu Button
		
		let pipMenuBtnPos = CGPoint(x: 0, y: 0)
		var pipMenuButton = UIButton(frame: CGRectMake(pipMenuBtnPos.x, pipMenuBtnPos.y, 120, 120))
		pipMenuButton.setImage(UIImage(named: "pipMenuButton"), forState: UIControlState.Normal)
		pipMenuButton.addTarget(pipMenu, action: "toggleActive:", forControlEvents: .TouchUpInside)
		let pipTuple: (view: UIView, pos: CGPoint) = (view: pipMenuButton, pos: pipMenuBtnPos)
		staticScreenElements.append(pipTuple)
		
		// User Data Button
		
		let userDataBtnPos = CGPoint(x: UIScreen.mainScreen().bounds.width - 120, y: 0)
		var userDataButton = UIButton(frame: CGRectMake(userDataBtnPos.x, userDataBtnPos.y, 120, 120))
		userDataButton.setImage(UIImage(named: "dataButton"), forState: .Normal)
		userDataButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let userTuple: (view: UIView, pos: CGPoint) = (view: userDataButton, pos: userDataBtnPos)
		staticScreenElements.append(userTuple)
		
		// Network Button
		
		let networkBtnPos = CGPoint(x: 0, y: UIScreen.mainScreen().bounds.height - 120)
		var networkButton = UIButton(frame: CGRectMake(networkBtnPos.x, networkBtnPos.y, 120, 120))
		networkButton.setImage(UIImage(named: "networkButton"), forState: .Normal)
		networkButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let netTuple: (view: UIView, pos: CGPoint) = (view: networkButton, pos: networkBtnPos)
		staticScreenElements.append(netTuple)
		
		// Settings Button
		
		let settingsBtnPos = CGPoint(x: UIScreen.mainScreen().bounds.width - 120,
			y: UIScreen.mainScreen().bounds.height - 120)
		var settingsButton = UIButton(frame: CGRectMake(settingsBtnPos.x, settingsBtnPos.y, 120, 120))
		settingsButton.setImage(UIImage(named: "settingsButton"), forState: .Normal)
		settingsButton.addTarget(self, action: "menuButtonPressed:", forControlEvents: .TouchUpInside)
		let settingsTuple: (view: UIView, pos: CGPoint) = (view: settingsButton, settingsBtnPos)
		staticScreenElements.append(settingsTuple)
		
		// Trash Can
		
		let trashCanPos = CGPoint(x: UIScreen.mainScreen().bounds.width/2 - 50,
			y: UIScreen.mainScreen().bounds.height - 110)
		trashCanButton = UIView(frame: CGRectMake(settingsBtnPos.x, settingsBtnPos.y, 100, 100))
		trashCanButton.backgroundColor = UIColor.blackColor()
		trashCanButton.hidden = true
		let trashTuple: (view: UIView, pos: CGPoint) = (view: trashCanButton, trashCanPos)
		staticScreenElements.append(trashTuple)
		
		// Add Buttons to scrollView
		
		scrollView.addSubview(pipMenuButton)
		scrollView.addSubview(userDataButton)
		scrollView.addSubview(networkButton)
		scrollView.addSubview(settingsButton)
		scrollView.addSubview(trashCanButton)
		
		
		/* ------------------------
			Tap Gesture Recognizer
		   ------------------------ */
		
		self.view.userInteractionEnabled = true;
		scrollView.userInteractionEnabled = true;
		
		var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
		doubleTapRecognizer.numberOfTapsRequired = 2
		doubleTapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(doubleTapRecognizer)
		
		var tapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewTapped:")
		tapRecognizer.numberOfTapsRequired = 1
		tapRecognizer.numberOfTouchesRequired = 1
		scrollView.addGestureRecognizer(tapRecognizer)
		
		let scrollViewFrame: CGRect = scrollView.frame
		let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
		let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
		let minScale: CGFloat = min(scaleWidth, scaleHeight)
		
		scrollView.minimumZoomScale = minScale
		scrollView.maximumZoomScale = 1.5
		scrollView.zoomScale = 0.5
		
		/* ------------------------
			Tap Gesture Recognizer
		   ------------------------ */

	}

	
	// BUILTIN - not sure what to use for
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	// scrollViewDoubleTapped: UITapGestureRecognizer -> nil
	// I/O: called when the background is double tapped
	//		zooms the view in by 1.5%
	
	func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
		let pointInView = recognizer.locationInView(containerView)
		
		var newZoomScale = min((scrollView.zoomScale * 1.5), scrollView.maximumZoomScale)
		
		let scrollViewSize = scrollView.bounds.size
		let w = scrollViewSize.width / newZoomScale
		let h = scrollViewSize.height / newZoomScale
		let x = pointInView.x - (w / 2.0)
		let y = pointInView.y - (h / 2.0)
		
		let rectToZoomTo = CGRectMake(x, y, w, h)
		
		scrollView.zoomToRect(rectToZoomTo, animated: true)
	}
	
	// scrollViewTapped: UITapGestureRecognizer -> nil
	// I/O: resets the state of active Pips, and closes all menus
	
	func scrollViewTapped(recognizer: UITapGestureRecognizer) {
		
		_mainPipDirectory.clearActiveInOut()
			
		for ele in staticScreenElements {
			if var menu = (ele.view as? CanvasMenuView) {
				if menu.viewIsActive {
					menu.toggleActive()
				}
			}
		}
		
	}
	
	// viewForZoomingInScrollView: UIScrollView -> UIView
	// I/O: returns containerView. Don't remember why.
	
	func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
		return containerView
	}
	
	// scrollViewDidZoom: UIScrollView -> ??
	// I/O: ???
	
	func scrollViewDidZoom(scrollView: UIScrollView) {
		return
	}
	
	// scrollViewDidScoll: UIScrollView -> nil
	// I/O: moves all static screen elements to stay relative to screen
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		let offset: CGPoint = scrollView.contentOffset
		
		for ele in staticScreenElements {
			if var menuView = (ele.view as? CanvasMenuView) {
				var basePos: CGPoint!
				if menuView.viewIsActive {
					basePos = menuView.baseLocation
				} else {
					basePos = menuView.offsetLocation
				}
				
				menuView.frame = CGRectMake(basePos.x + offset.x, basePos.y + offset.y,
					ele.view.frame.width, ele.view.frame.height)
			} else {
				ele.view.frame = CGRectMake(ele.pos.x + offset.x, ele.pos.y + offset.y, ele.view.frame.width, ele.view.frame.height)
			}
		}
	}
	
	// pipStartedBeingDragged: nil -> nil
	// I/O: called by a pip when it first starts being dragged
	//		makes the trash can visible
	func pipStartedBeingDragged() {
		trashCanButton.hidden = false
	}
	
	// pipStoppedBeingDragged: nil -> nil
	// I/O: called by a pip when touchesEnded
	//		hides the trash can 
	func pipStoppedBeingDragged(pip: BasePipView) {
		trashCanButton.hidden = true
		
		let pipRect: CGRect = scrollView.convertRect(pip.frame, fromView: containerView)
		
		if CGRectIntersectsRect(pipRect, trashCanButton.frame) {
			_mainPipDirectory.deletePip(pip.pipId)
		}
	}
	
	// menuButtonPressed: UIButton -> nil
	// I/O: unused for now, will be used to implement other menus
	
	func menuButtonPressed(sender: UIButton!){
		println("no menu to toggle yet")
	}
	
	/* --------------------------------------------------------
	 * THIS COMMENT IS UNDER NO CIRCUMSTANCES TO BE MODIFIED
	 * MOVED, DELETED, OR IN ANY WAY ALTERED
	 * FOR ALL TIME LET IT BE KNOWN THAT
	 * PETER SLATTERY IS PROGRAMMING GOD
	 * --------------------------------------------------------
	*/
	
	// addPipView: BasePipView -> nil
	// I/O: adds pipView to containerView
	//		called by PipDirectory.createPipOfType()
	
	func addPipView(pipView: BasePipView) {
		containerView.addSubview(pipView)
		containerView.bringSubviewToFront(pipView)
	}
	
	// addArmView: ArmView -> nil
	// I/O: Adds armView to containerView and moves it all the way to the back
	//		called by PipDirectory.makeConnection()
	
	func addArmView(armView: ArmView) {
		containerView.addSubview(armView)
		//scrollView.sendSubviewToBack(armView)
		armView.setNeedsDisplay()
	}
	
	// removeArmView: ArmView -> nil
	// I/O: Removes armView from containerView
	
	func removeArmView(armView: ArmView) {
		armView.removeFromSuperview()
	}
	
	// ------------
	//	Accessors
	// ------------
	
	func getContainerView() -> UIView {
		return containerView
	}
}

