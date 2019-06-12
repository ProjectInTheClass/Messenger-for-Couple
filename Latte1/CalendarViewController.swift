//
//  CalendarViewController.swift
//  Latte1
//
//  Created by sw_studio1 on 2019. 5. 31..
//  Copyright © 2019년 남혜빈. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseDatabase

class CalendarViewController: UIViewController {

    // 실시간 데이터베이스 root 참조 변수.
    var rootRef : DatabaseReference!
    
    var dateFormatter = DateFormatter()
    fileprivate weak var calendar : FSCalendar!
    var table : UITableView!
    var whatdate : String!
    var data : [String:[String]] = ["2019년05월15일":["영화"],"2019년05월19일":["카페","영화"],"2019년05월24일":["2박3일부산"],"2019년05월31일":["공연","영화"]]
    var scheddata = [String]()
    
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
        
        // 데이터 베이스 참조 연결
        rootRef = Database.database().reference()
        // 여기 위치가 맞을까???
    
        // 예상 위치1
        /*
        rootRef.child("scheduler").child(whatdate).observe(.childAdded) { (snapshot) in
            // 서브트리 스케줄러의 자식인 whatdate의 자식으로 데이터가 추가될때 실행됨
            // snapshot 변수로부터 해당 위치에 있는 데이터들을 가져오고 그것을 문자 배열 scheddata에 추가
            let sched = snapshot.value as? String
            
            if let actualsched = sched{
                self.scheddata.append(actualsched)
                
                self.table.reloadData()
            }
        }
         */
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
        // 예상 위치2
        /*
         rootRef.child("scheduler").child(whatdate).observe(.childAdded) { (snapshot) in
         // 서브트리 스케줄러의 자식인 whatdate의 자식으로 데이터가 추가될때 실행됨
         // snapshot 변수로부터 해당 위치에 있는 데이터들을 가져오고 그것을 문자 배열 scheddata에 추가
         let sched = snapshot.value as? String
         
         if let actualsched = sched{
         self.scheddata.append(actualsched)
         
         self.table.reloadData()
         }
         }
         */
        if(data[self.whatdate] == nil){
            return 0 // 딕셔너리 키값 존재 유무.
        }
        else{
            return data[self.whatdate]!.count
        }
        // 데이터 베이스에서 가져와 그 데이터를 집어넣은 배열의 개수 만큼 section 설정
        //return scheddata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1",for:indexPath)
        cell.textLabel?.text = data[self.whatdate]![indexPath.row]
        
        // firebase가 제대로 실행되면 아래의 코드로 변경
        // cell.textLabel?.text = scheddata[indexPath.row]
        
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
        
        //return "\(scheddata.count)"
    }
    
}

