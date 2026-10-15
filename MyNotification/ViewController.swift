//
//  ViewController.swift
//  MyNotification
//
//  Created by User on 14/10/26.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, _) in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied.")
            }
        }
    }

    @IBAction func scheduleNotification(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "Submission Anda Telah Diterima!"
        content.body = "Selamat Anda telah menyelesaikan kelas Belajar Fundamental Aplikasi iOS."
        content.sound = .default
        content.userInfo = ["value": "Data dengan local notification"]

        // Fire 10 seconds from now using a calendar trigger (as you intended)
        let fireDate = Calendar.current.dateComponents(
            [.day, .month, .year, .hour, .minute, .second],
            from: Date().addingTimeInterval(10)
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)

        let request = UNNotificationRequest(identifier: "message", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled.")
            }
        }
    }
}

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        print("UserInfo yang terkait dengan notifikasi == \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}
