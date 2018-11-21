//
//  DetailViewController.swift
//  XmlParsing1119
//
//  Created by 503-14 on 2018. 11. 19..
//  Copyright © 2018년 503-14. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblSummary: UILabel!
    
    //book을 넘겨받아야 하니까
    var book : Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblTitle.text = book.title
        lblAuthor.text = book.author
        lblSummary.text = book.summary
        
        self.title = book.title
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
