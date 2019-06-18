//
//  CalendarViewController.swift
//  Latte1
//
//  Created by sw_studio1 on 2019. 5. 31..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseAuth
import FirebaseDatabase

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var showRealTerm: UILabel!
    
    @IBOutlet weak var SchedTable: UITableView!
    // 실시간 데이터베이스 root 참조 변수.
    var rootRef : DatabaseReference!
    var curruseruid : String!
    var dateFormatter = DateFormatter()
    fileprivate weak var calendar : FSCalendar!
    //var table : UITableView!
    var whatdate : String!
    var scheddata = [String]()
    var datestr = "2019년03월22일"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 달력 위치 설정.
        let calendar = FSCalendar(frame: CGRect(x:50,y:200,width:320,height:300))
        // Calendar에서 가져올 데이터 및 기능 대신 수행을 위해 사용
        calendar.dataSource = self
        calendar.delegate = self
        
        //Calendar cell id 이름 설정.
        calendar.register(FSCalendarCell.self, forCellReuseIdentifier: "Cell")
        
        //Calendar cell appearence.
        calendar.appearance.headerTitleColor = UIColor.brown
        calendar.appearance.todayColor = UIColor.lightGray

        calendar.appearance.titleDefaultColor = UIColor.black

        SchedTable.dataSource = self
        SchedTable.delegate = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        self.whatdate = dateFormatter.string(from: Date())
        
        let startDate = dateFormatter.date(from: datestr)!
        let endDate = dateFormatter.date(from:self.whatdate)!
        let interval = endDate.timeIntervalSince(startDate)+1
        let days = Int(interval / 86400)
        
        self.showRealTerm.text = "실제로 사귄지 \(days)일!!"
        view.addSubview(calendar)
        //view.addSubview(table)
        
        self.dateFormatter = dateFormatter
        self.calendar = calendar
        //self.table = table
        // Do any additional setup after loading the view.
        
        // 데이터 베이스 참조 연결
        rootRef = Database.database().reference()
        curruseruid = Auth.auth().currentUser?.uid
        // 여기 위치가 맞을까???
        
        // 예상 위치1
        
        rootRef.child("schedule").child(whatdate).child(curruseruid).observeSingleEvent(of: .value) { (snapshot) in
            //print("현재 날짜1 = "+self.whatdate)
            self.scheddata.removeAll()
            let snapchild = snapshot.children
            while let rest = snapchild.nextObject() as? DataSnapshot{
                let input = rest.value as! String
                self.scheddata.append(input)
            }
            self.SchedTable.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let calendarModal = segue.destination as? AddSchedViewController else {return}
        calendarModal.datevalue = self.whatdate
    }
    
}
extension CalendarViewController : FSCalendarDataSource, FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        // cell id = 위에서 설정
        let cell = calendar.dequeueReusableCell(withIdentifier: "Cell", for: date, at: position)
        return cell
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Date 국가 지정 설정.
        // 그 후 올바른 설정인지 확인 후 아래의 테이블 뷰에 데이터 삽입.
        let whatdate = dateFormatter.string(from:date)
        self.whatdate = whatdate
        let startDate = dateFormatter.date(from: datestr)!
        let endDate = dateFormatter.date(from:self.whatdate)!
        let interval = endDate.timeIntervalSince(startDate)+1
        let days = Int(interval / 86400)
        
        self.showRealTerm.text = "실제로 사귄지 \(days)일!!"
        //print("이날은 실.제.로 사귄지 \(days)일 되는날!")
        self.SchedTable.reloadData()
        //print("Date is "+whatdate )
        
    }
}

extension CalendarViewController: UITableViewDataSource ,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 예상 위치2
        //self.scheddata.removeAll()
        
        rootRef.child("schedule").child(whatdate).child(curruseruid).observeSingleEvent(of: .value) { (snapshot) in
            //print("현재 날짜2 = "+self.whatdate)
            self.scheddata.removeAll()
            let snapchild = snapshot.children
            while let rest = snapchild.nextObject() as? DataSnapshot{
                let input = rest.value as! String
                self.scheddata.append(input)
            }
            self.SchedTable.reloadData()
        }
        // 데이터 베이스에서 가져와 그 데이터를 집어넣은 배열의 개수 만큼 section 설정
        return scheddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SchedTable.dequeueReusableCell(withIdentifier: "SchedCell",for:indexPath)
        cell.textLabel?.text = scheddata[indexPath.row]
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //tableView.sectionIndexColor = UIColor.blue
        return self.whatdate
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "\(scheddata.count)"
    }
}

