//
//  CalendarViewController.swift
//  Latte1
//
//  Created by sw_studio1 on 2019. 5. 31..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {

    // 실시간 데이터베이스 root 참조 변수.
    //let rootRef = Database.database().reference()
    
    var dateFormatter = DateFormatter()
    fileprivate weak var calendar : FSCalendar!
    var table : UITableView!
    var whatdate : String!
    var data : [String:[String]] = ["2019년05월15일":["영화"],"2019년05월19일":["카페","영화"],"2019년05월24일":["2박3일부산"],"2019년05월31일":["공연","영화"]]
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
        //calendar.appearance.titleDefaultColor = UIColor.green
        //calendar.appearance.subtitleDefaultColor = UIColor.green
        calendar.appearance.titleDefaultColor = UIColor.black
        
        let table = UITableView(frame: CGRect(x:50, y: 550,width:320,height:200))
        
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell1")
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy년MM월dd일"
        self.whatdate = dateFormatter.string(from: Date())
        
        view.addSubview(calendar)
        view.addSubview(table)
        
        self.dateFormatter = dateFormatter
        self.calendar = calendar
        self.table = table
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let calendarModal = segue.destination as? AddSchedViewController else {return}
        calendarModal.datevalue = self.whatdate;
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
        self.table.reloadData()
        print("Date is "+whatdate )
        
    }
}

extension CalendarViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(data[self.whatdate] == nil){
            return 0 // 딕셔너리 키값 존재 유무.
        }
        else{
            return data[self.whatdate]!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1",for:indexPath)
        cell.textLabel?.text = data[self.whatdate]![indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.whatdate
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(data[self.whatdate] == nil){
            return "0"
        }
        else{
            return "\(data[self.whatdate]!.count)"
        }
    }
    
}

