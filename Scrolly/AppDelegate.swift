import Cocoa

let LINES_TO_SCROLL: Int64 = 3
func setScrollSpeed(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    let classicalMousewheel = event.getIntegerValueField(.scrollWheelEventIsContinuous) == 0
    if (classicalMousewheel){
        var lines = LINES_TO_SCROLL
        if (event.getIntegerValueField(.scrollWheelEventDeltaAxis1) < 0){
            lines *= -1
        }
        event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: lines)
    }
    return Unmanaged.passRetained(event)
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    
    let statusItem: NSStatusItem
    let popover: NSPopover
    var popoverMonitor: AnyObject?
    
    override init() {
        popover = NSPopover()
        statusItem = NSStatusBar.system.statusItem(withLength: 24)
    
        let eventMask = (1 << CGEventType.scrollWheel.rawValue)
        guard let eventTap = CGEvent.tapCreate(tap: .cgSessionEventTap,
                                              place: .headInsertEventTap,
                                              options: .defaultTap,
                                              eventsOfInterest: CGEventMask(eventMask),
                                              callback: setScrollSpeed,
                                              userInfo: nil) else {
                                                print("Failed to create event tap")
                                                exit(1)
        }

        let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, .commonModes)
        CGEvent.tapEnable(tap: eventTap, enable: true)
        DispatchQueue.global(qos: .background).async {
            CFRunLoopRun()
        }
        
        
        super.init()
        setupStatusButton()
    }
    
    func setupStatusButton() {
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(named: "Status")
        }
    }
    

}
