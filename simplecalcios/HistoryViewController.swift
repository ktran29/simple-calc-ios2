//
//  HistoryViewController.swift
//  simplecalcios
//
//  Created by Kevin Tran on 2/2/18.
//  Copyright © 2018 Kevin Tran. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var historyBank : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 30, width: 300, height: screenHeight / 2))
        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        
        if (historyBank.count > 0) {
            for index in 0...historyBank.count - 1 {
                let label = UILabel(frame: CGRect(x: 50, y: index * 25 + 50, width: 300, height: 40))
                label.text = historyBank[index]
                scrollView.addSubview(label)
            }
        }
        
        view.addSubview(scrollView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let calcView = segue.destination as! ViewController
        calcView.historyBank = historyBank
    }

}
