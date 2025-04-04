import Flutter
import UIKit
import BackgroundTasks
import WidgetKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    // iOS 13 ve üzeri için background task'ı başlat
    if #available(iOS 13.0, *) {
      BGTaskScheduler.shared.register(
        forTaskWithIdentifier: "com.example.yds-words.refresh",
        using: nil
      ) { task in
        self.handleAppRefresh(task: task as! BGAppRefreshTask)
      }
      scheduleAppRefresh()
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  @available(iOS 13.0, *)
  func handleAppRefresh(task: BGAppRefreshTask) {
    // Widget'ı güncelle
    if #available(iOS 14.0, *) {
      WidgetCenter.shared.reloadTimelines(ofKind: "WordWidget")
    }
    
    // Bir sonraki güncellemeyi planla
    scheduleAppRefresh()
    
    task.setTaskCompleted(success: true)
  }
  
  @available(iOS 13.0, *)
  func scheduleAppRefresh() {
    let request = BGAppRefreshTaskRequest(identifier: "com.example.yds-words.refresh")
    request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // 15 dakika
    
    do {
      try BGTaskScheduler.shared.submit(request)
    } catch {
      print("Could not schedule app refresh: \(error)")
    }
  }
}
