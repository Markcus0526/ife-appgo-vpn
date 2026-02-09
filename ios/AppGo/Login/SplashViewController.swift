//
//  SplashViewController.swift
//  AppGoPro
//
//  Created by Jadestar on 02/10/2017.
//  Copyright © 2017 TouchingApp. All rights reserved.
//

import UIKit

class SplashViewController: BaseViewController {
    @IBOutlet weak var viewPager: ViewPager!
    
    var langCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewPager.dataSource = self
        langCode = AppPref.getCurLanguageCode()        
        //viewPager.animationNext()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewPager.scrollToPage(0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SplashViewController: ViewPagerDataSource {
    func numberOfItems(_ viewPager:ViewPager) -> Int {
        return 3;
    }
    
    func viewAtIndex(_ viewPager:ViewPager, index:Int, view:UIView?) -> UIView {
        var newView = view;
        var backImage:UIImageView?
        if newView == nil {
            newView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
            
            backImage = UIImageView(frame: newView!.bounds)
            if index == 0 {
                if langCode == Localize.Chinese {
                    backImage?.image = UIImage(named: "im_splash_1_zh")
                } else {
                    backImage?.image = UIImage(named: "im_splash_1_en")
                }
            } else if index == 1 {
                if langCode == Localize.Chinese {
                    backImage?.image = UIImage(named: "im_splash_2_zh")
                } else {
                    backImage?.image = UIImage(named: "im_splash_2_en")
                }
            } else if index == 2 {
                if langCode == Localize.Chinese {
                    backImage?.image = UIImage(named: "im_splash_3_zh")
                } else {
                    backImage?.image = UIImage(named: "im_splash_3_en")
                }
            }
            
            newView?.addSubview(backImage!)
            
            if index == 2 {
                let buttonEnter = UIButton(frame: CGRect(x: newView!.frame.size.width*0.25, y: newView!.frame.size.height*0.8, width: newView!.frame.size.width*0.5, height: newView!.frame.size.height*0.06))
                buttonEnter.layer.borderWidth = 1.0
                buttonEnter.layer.borderColor = Color.BackBlue.cgColor
                buttonEnter.layer.backgroundColor = Color.BackBlue.cgColor
                buttonEnter.layer.cornerRadius = buttonEnter.frame.size.height / 2
                buttonEnter.setTitle("start now".localizedString(), for: .normal)
                buttonEnter.addTarget(self, action: #selector(enterClicked), for: .touchUpInside)
                
                newView?.addSubview(buttonEnter)
            }
            
        } else {
            if index == 0 {
                viewPager.pageControl.isHidden = false
            } else if index == 1 {
                viewPager.pageControl.isHidden = false
            } else if index == 2 {
                viewPager.pageControl.isHidden = true
            }
        }
        
        return newView!
    }
    
    func enterClicked(_ sender: UIButton!) {
        AppPref.setSplashHidden(hidden: true)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabViewController")
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
}
