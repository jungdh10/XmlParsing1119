
import UIKit

class Book{
    var title:String!
    var link:String!
}

class NewsViewController: UITableViewController, XMLParserDelegate {
    
    //파일에 필요한 변수
    //태그 하나 하나의 값을 저장할 변수
    var elementValue:String!
    //Book 1개를 저장할 변수
    var book:Book!
    //전체 데이터를 저장할 변수(Book의 배열)
    var books=[Book]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //데이터를 다운로드 받을 주소를 URL 인스턴스로 생성
        let url = URL(string:"http://rss.ohmynews.com/rss/book.xml")
        //데이터를 다운로드 받아서 파싱할 객체 만들기
        let xmlParser = XMLParser(contentsOf: url!)
        //파싱을 수행할 객체 지정
        xmlParser!.delegate = self
        //파싱을 요청하고 결과 받기
        let success = xmlParser!.parse( )
        if success == true{
            self.title="Book News"
        }else{
            self.title="파싱 실패"
        }
    }
    
    //여는 태그를 만났을 때 호출되는 메소드
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
       
        if elementName == "item"{
           book=Book()
        }
        
    }
    
    //닫는 태그를 만났을 때 호출되는 메소드
    //하나의 객체를 닫는 태그를 만나면 객체를 배열이나 리스트에 저장하고
    //객체 내의 태그를 만나면 그 태그에 해당하는 프로퍼티에 데이터를 저장
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        //하나의 객체를 닫는 태그를 만난 경우
        if elementName == "item"{
            books.append(book)
        }
        //title의 닫는 태그를 만나면 값을 title에 저장
        else if elementName == "title"{
            if book != nil{
            book.title = elementValue
            }
        }
        else if elementName == "link"{
            if book != nil{
                book.link = elementValue
            }
        }
        elementValue = nil
    }
    
    //여는 태그와 닫는 태그 사이의 내용을 만났을 때 호출되는 메소드
    //이 메소드는 유일하게 동일한 데이터를 가지고 두 번 이상 호출될 수 있는 메소드이기 때문에
    //elementValue의 값이 nil이면 바로 저장하고 그렇지 않으면 이전 데이터에 추가해햐 합니다.
    //태그에 적는 내용은 하나의 패킷 이하로 만들어지기 때문에 한번에 전송되지만
    //여는 태그와 닫는태그 사이에 작성하는 내용은 하나의 패킷 이상이 될 수 있어서 입니다.
    //이 부분은 다른 네트워크 프로그램을 만들 떄도 기억해야 합니다.
    func parser(_ parser: XMLParser, foundCharacters string: String){
        if elementValue == nil{
            elementValue = string
        }
        else{
            elementValue = "\(elementValue!)\(string)"
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //데이터 배열의 count를 리턴
        return books.count
    }
    
    //셀 만들어주는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //출력할 내용
        //books에서 필요한 내용의 인덱스를 찾고.필요한 내용
        cell.textLabel?.text=books[indexPath.row].title
        
        return cell
    }
    

    //didSelectRowAt 셀 선택시 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let detailViewController = self.storyboard?.instantiateViewController(
            withIdentifier: "DetailViewController") as! DetailViewController
        
        detailViewController.address = books[indexPath.row].link
        
        self.navigationController?.pushViewController(
            detailViewController, animated: true)

    }

}

