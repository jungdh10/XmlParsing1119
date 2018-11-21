//
//  DetailViewController.swift
//  XmlNews
//
//  Created by 503-14 on 2018. 11. 20..
//  Copyright © 2018년 503-14. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    //웹 주소를 넘겨받을 변수
    //var address : [String] = [String]()
    var address : String?
    

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let addr = address{
            //URL 객체 생성
            let webURL = URL(string:addr)
            //Request 객체 생성
            let urlRequest = URLRequest(url:webURL!)
            //웹 뷰가 로딩
            webView.load(urlRequest)
        }
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
