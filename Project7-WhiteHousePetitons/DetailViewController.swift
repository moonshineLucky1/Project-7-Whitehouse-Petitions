//
//  DetailViewController.swift
//  project7
//
//  Created by 李沐軒 on 2019/3/18.
//  Copyright © 2019 李沐軒. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webview: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webview = WKWebView()
        view = webview
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        body { font-size: 150%; }
        </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webview.loadHTMLString(html, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
