//
//  MainViewController.swift
//  barcampevn
//

import UIKit
import SwiftyJSON
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var schedules           = Array<Array<Schedule>>()
    var firstDaySchedules   = Array<Array<Schedule>>()
    var secondDaySchedules  = Array<Array<Schedule>>()
    
    let celldentifier       = "celldentifier"
    let roomCelldentifier   = "roomCelldentifier"

    var days                = ["27",
                               "28"]
    
    var tims                = ["10:00",
                               "10:30",
                               "11:00",
                               "11:30",
                               "12:00",
                               "12:30",
                               "13:00",
                               "13:30",
                               "14:00",
                               "14:30",
                               "15:00",
                               "15:30",
                               "16:00",
                               "16:30",
                               "17:00",
                               "17:30",
                               "18:00"]
    
    var rooms               = ["Big Hall",
                               "213W",
                               "214W",
                               "208E",
                               "308E"]
    
    var width: CGFloat      = 230
    var headerHeight: CGFloat = 23

    lazy var leftItem: UIBarButtonItem = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 156, height: 32))
        imageView.image = UIImage(named: "ic_menu_logo")
        let item = UIBarButtonItem(customView: imageView)
        
        return item
    }()
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseConfig()
    }
    
    //MARK: - Private Methods -
    private func baseConfig() {
        configureNavigationBar()
        configureLocalNotification()
        configureSegmentedControl()
        registerCellClasses()
        
        getSchedule()
    }
    
    private func configureNavigationBar() {
        navigationItem.setLeftBarButton(leftItem, animated: false)
    }
    
    private func configureLocalNotification() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func configureSegmentedControl() {
        segmentedControl.layer.cornerRadius = 20
        segmentedControl.layer.borderColor = UIColor.red.cgColor
        segmentedControl.layer.borderWidth = 1
        segmentedControl.clipsToBounds = true
        segmentedControl.setTitleTextAttributes([NSFontAttributeName: Font.boldSystem_17], for: .normal)
    }
    
    private func registerCellClasses() {
        tableView.register(RoomTableViewCell.self, forCellReuseIdentifier: roomCelldentifier)
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: celldentifier)
    }
    
    private func prepareScheduleDataForShow(_ array: Array<Schedule>) {
        let date = Date() //"19".testDate(format: "dd")//
        switch date.day {
        case days[1]:
            segmentedControl.selectedSegmentIndex = 1
            let secondDay = array.filter {$0.time_from.date.day == days[1]}
            secondDaySchedules = sortedSchedule(secondDay)
            updateCollectionWith(array: secondDaySchedules)
            let concurrentQueue = DispatchQueue(label: "com.queuename.first", attributes: .concurrent)
            concurrentQueue.async {
                let firstDay = array.filter {$0.time_from.date.day == self.days[0]}
                self.firstDaySchedules = self.sortedSchedule(firstDay)
            }
            break
            
        default:
            segmentedControl.selectedSegmentIndex = 0
            let firstDay = array.filter {$0.time_from.date.day == days[0]}
            firstDaySchedules = sortedSchedule(firstDay)
            updateCollectionWith(array: firstDaySchedules)
            let concurrentQueue = DispatchQueue(label: "com.queuename.second", attributes: .concurrent)
            concurrentQueue.async {
                let secondDay = array.filter {$0.time_from.date.day == self.days[1]}
                self.secondDaySchedules = self.sortedSchedule(secondDay)
            }
            
            break
        }
    }
    
    private func sortedSchedule(_ array: Array<Schedule>) -> Array<Array<Schedule>> {
        var tempSchedules = Array<Array<Schedule>>()
        for time in tims {
            var sortedSchedules = Array<Schedule>()
            var scheduleForHeader = Schedule(data: JSON.null)
            scheduleForHeader.timeForShowInHeader = time
            sortedSchedules.append(scheduleForHeader)
            
            for room in rooms {
                var scheduleForRow = Schedule(data: JSON.null)
                for schedule in array {
                    if schedule.room == room {
                        if let header = time.hourDate,
                            let start = schedule.time_from.date.longHourDate,
                            let end = schedule.time_to.date.longHourDate
                        {
                            if (start == header) || (header > start && header < end) {
                                scheduleForRow = schedule
                            }
                        }
                    }
                }
                sortedSchedules.append(scheduleForRow)
            }
            tempSchedules.append(sortedSchedules)
        }
        return tempSchedules
    }
    
    private func updateCollectionWith(array: Array<Array<Schedule>>) {
        schedules = array
        collectionView.reloadData()
    }
    
    private func findIndexForScroll() -> Int? {
        let date = Date() //"12:45".testDate(format: "HH:mm")//
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let result = (minutes >= 30) ? "\(hour):30" : "\(hour):00"
        let index = tims.index(of: result)
        
        return index
    }
    
    private func scrollToPosition() {
        if let index = findIndexForScroll() {
            collectionView.scrollToItem(at: IndexPath(row: 0, section: index), at: .left, animated: true)
        }
    }
    
    //MARK: - Actions -
    @IBAction func openBrowser(_ sender: UIBarButtonItem) {
        let url = URL(string: "https://www.youtube.com/channel/UCz4Gaw-vexemY-WtB2NJu6w")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func changeDate(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            updateCollectionWith(array: firstDaySchedules)
        } else {
            updateCollectionWith(array: secondDaySchedules)
        }
    }
    
    //MARK: - API -
    func getSchedule() {
        apiManager.getSchedule { (data, error) in
            if let data = data, error == nil {
                var temp = Array<Schedule>()
                for object in data.arrayValue {
                    let schedule = Schedule(data: object)
                    temp.append(schedule)
                }
                self.prepareScheduleDataForShow(temp)
                self.scrollToPosition()
            }
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDataDelegate -
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let room = rooms[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: roomCelldentifier) as! RoomTableViewCell
        cell.configure(room)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (self.view.bounds.size.height - headerHeight)/CGFloat(rooms.count)
        
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = Color.blue
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate -
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return schedules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedules[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: celldentifier, for: indexPath) as! MainCollectionViewCell
        let schedule = schedules[indexPath.section][indexPath.row]
        if indexPath.row == 0 {
            cell.setHeaderValues(schedule: schedule)
        } else {
            cell.setRowValues(schedule: schedule)
        }
        if indexPath.section == 0 {
            cell.insetLineConstraint?.constant = 8
        } else {
            cell.insetLineConstraint?.constant = 0
        }
        cell.lineView.isHidden = (indexPath.row == rooms.count) || (indexPath.row == 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width:width, height: headerHeight)
        }
        
        let height = (self.view.bounds.size.height - (headerHeight + 44 + CGFloat(rooms.count - 2)*5)) / CGFloat(rooms.count)
        return CGSize(width:width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let schedule = schedules[indexPath.section][indexPath.row]
        let interval = schedule.time_from.date.tenMinuteBefor
        if indexPath.row != 0 && schedule.time_from.date.shortHour != nil && interval > 0 {
            let alertController = UIAlertController(title: "Notify me when this talk starts", message: nil, preferredStyle: .actionSheet)
            let favoriteAction = UIAlertAction(title: "Attend", style: .default) { (alert: UIAlertAction!) -> Void in
                print(schedule.time_from.date)
                self.didAddLocalNotification(schedule)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(favoriteAction)
            alertController.addAction(cancelAction)
            
            if let popoverController = alertController.popoverPresentationController {
                let cell = collectionView.cellForItem(at: indexPath)!
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
            present(alertController, animated: true, completion:nil)
        }
    }
}

extension MainViewController: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .sound])
    }
    
    // MARK: - Actions
    func didAddLocalNotification(_ schedule: Schedule) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                switch notificationSettings.authorizationStatus {
                case .notDetermined:
                    self.requestAuthorization(completionHandler: { (success) in
                        guard success else { return }
                        self.scheduleLocalNotification(schedule)
                    })
                case .authorized:
                    self.scheduleLocalNotification(schedule)
                case .denied:
                    print("Application Not Allowed to Display Notifications")
                }
            }
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
            guard let settings = UIApplication.shared.currentUserNotificationSettings else { return }
            if settings.types == .none {
                UIHelper.showHUD("We don't have permission to schedule notifications")
                return
            }
            
            scheduleLocalNotification(schedule)
        }
    }
    
    // MARK: - Private Methods
    private func scheduleLocalNotification(_ schedule: Schedule) {
        if #available(iOS 10.0, *) {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = schedule.en.speaker + " talk at " + schedule.room
            notificationContent.body = schedule.en.topic + " will start in 10 minutes. Hurry!"
            let interval = schedule.time_from.date.tenMinuteBefor
            let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            let notificationRequest = UNNotificationRequest(identifier: "notification", content: notificationContent, trigger: notificationTrigger)
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        } else {
            let notification = UILocalNotification()
            notification.alertTitle = schedule.en.speaker + " talk at " + schedule.room
            notification.alertBody = schedule.en.topic + " will start in 10 minutes. Hurry!"
            let interval = schedule.time_from.date.tenMinuteBefor
            notification.fireDate = Date(timeIntervalSinceNow: interval)
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
                if let error = error {
                    print("Request Authorization Failed (\(error), \(error.localizedDescription))")
                }
                
                completionHandler(success)
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
