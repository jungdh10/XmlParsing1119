
import UIKit

class Book{
    var id:String!
    var title:String!
    var author:String!
    var summary:String!
}

class RootViewController: UITableViewController, XMLParserDelegate {

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
        let url = URL(string:"http://sites.google.com/site/iphonesdktutorials/xml/Books.xml")
        //데이터를 다운로드 받아서 파싱할 객체 만들기
        let xmlParser = XMLParser(contentsOf: url!)
        //파싱을 수행할 객체 지정
        xmlParser!.delegate = self
        //파싱을 요청하고 결과 받기
        let success = xmlParser!.parse()
        if success == true{
            self.title="파싱 성공"
        }else{
            self.title="파싱 실패"
        }
    }
    
    //여는 태그를 만났을 때 호출되는 메소드
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]){
        
        //하나의 객체 여는 태그를 만났을 때 객체를 생성(태그이름 Book)
        //태그들 중에서 속성을 가진 태그가 있으면(Book에만 속성(id)이 있었음) 그 속성을 찾아와서 저장
        if elementName == "Book"{
            book=Book()
            //Book 태그에 있는 id 속성의 값을 찾아서 book에 저장
            var dic = attributeDict as Dictionary
            book.id=dic["id"]
        }
    }
    
    //닫는 태그를 만났을 때 호출되는 메소드
    //하나의 객체를 닫는 태그를 만나면 객체를 배열이나 리스트에 저장하고
    //객체 내의 태그를 만나면 그 태그에 해당하는 프로퍼티에 데이터를 저장
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        //하나의 객체를 닫는 태그를 만난 경우
        if elementName == "Book"{
            books.append(book)
        }
        //title의 닫는 태그를 만나면 값을 title에 저장
        else if elementName == "title"{
            book.title = elementValue
        }
        else if elementName == "author"{
            book.author = elementValue
        }
        else if elementName == "summary"{
            book.summary = elementValue
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
        //accessoryView는 UIView니까 아무거나 만들어서 버튼이나 이미지뷰 등, accessoryType은 만들어진걸 사용
        //cell.accessoryView
        

        return cell
    }
    
    //UITableView의 메소드 가져와서 override 붙이기
    //셀을 선택했을 때 호출되는 메소드
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //하위 뷰 컨트롤러 만들기
        let detailViewController =
            self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        //데이터 넘기기
        detailViewController.book = books[indexPath.row]
        //출력
        self.navigationController?.pushViewController(detailViewController, animated: true)
        //간격 조정해주기 안하면 내용이 셀에 잘려보임
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
