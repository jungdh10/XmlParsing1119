

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //저자 이름과 제목을 저장할 배열
    var titles : [String] = [String]()
    var authors : [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //데이터를 다운받을 URL을 생성
        let url = URL(string:"https://dapi.kakao.com/v3/search/book?target=title\("query=java")")
        
        //\("Authorization: KakaoAK 9cca5b36b5804848cbb4b5ff3275559a")")
        print(url!)
        
        //웹의 데이터를 다운로드
        //try!: 예외를 처리하지 않겠다.
        let data = try! Data(contentsOf: url!)
        print(data)
        //다운로드 받을 데이터가 JSON 형식이라면 파싱해서 딕셔너리로 변환
        //[String:Any]를 NSDinctionary로 해도 된다. 둘다 딕셔너리니까
        let result = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
        print(result)
        
        
        //파싱을 하자 마자 출력하면 한글이 디코딩이 안되서 출력될 수 있습니다.
        //meta 키의 값을 디셔너리로 가져오기(무조건 형변환하기 as! NSDictionary)
        let meta = result["meta"] as! NSDictionary
        print(meta)
        //document 키의 값을 배열로 가져오기
        let document = meta["documents"] as! NSArray
        print(document)
        //배열은 반복문으로 순회
        for index in 0...(document.count-1){
            //데이터 가져오기
            let documents = document[index] as! NSDictionary
            //딕셔너리안의 String으로 된 title, authors 값 가져오기
            titles.append(documents["title"] as! String)
            authors.append(documents["authors"] as! String)
        }
        print(titles)
        print(authors)
        
        //데이터 소스 지정하고 extension 만들기
        tableView.dataSource = self
    }
}
//기능 확장 - extension
extension ViewController : UITableViewDataSource{
    //행의 개수를 설정하는 메소드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return titles.count
    }
    //셀을 만들어주는 메소드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //셀을 만들기
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //셀에 내용을 출력하고
        cell.textLabel?.text = "\(titles[indexPath.row]) - \(authors[indexPath.row])"
        return cell
    }
    
}

