//
//  HDPingTools.swift
//  HDPingTools
//
//  Created by Damon on 2021/1/4.
//

import Foundation
import UIKit
#if canImport(ZXKitCore)
import ZXKitCore
#endif

public typealias PingComplete = ((_ response: HDPingResponse?, _ error: Error?) -> Void)

public enum HDPingError: Error, Equatable {
    case requestError   //发起失败
    case receiveError   //响应失败
    case timeout        //超时
}

public struct HDPingResponse {
    public var pingAddressIP = ""
    public var responseTime: HDPingTimeInterval = .second(0)
    public var responseBytes: Int = 0
}

public enum NetworkActivityIndicatorStatus {
    case auto       //自动显示
    case always     //一直显示
    case none       //不显示
}

public enum HDPingTimeInterval {
    case second(_ interval: TimeInterval)       //秒
    case millisecond(_ interval: TimeInterval)  //毫秒
    case microsecond(_ interval: TimeInterval)  //微秒

    public var second: TimeInterval {
        switch self {
            case .second(let interval):
                return interval
            case .millisecond(let interval):
                return interval / 1000.0
            case .microsecond(let interval):
                return interval / 1000000.0
        }
    }
}

struct HDPingItem {
    var sendTime = Date()
    var sequence: UInt16 = 0
}

open class HDPingTools: NSObject {
    public var timeout: HDPingTimeInterval = .millisecond(1000)  //自定义超时时间，默认1000毫秒，设置为0则一直等待
    public var debugLog = true                                  //是否开启日志输出
    public var stopWhenError = false                            //遇到错误停止ping
    public private(set) var isPing = false
    public var isRunning: Bool = false
    public var showNetworkActivityIndicator: NetworkActivityIndicatorStatus = .auto              //是否在状态栏显示
    
    
    public var hostName: String? {
        get {
            return pinger.hostName
        }
        set {
            let oldPinger = self.pinger
            var host = newValue ?? "www.apple.com"
            if host.isEmpty {
                host = "www.apple.com"
            }
            pinger = SimplePing(hostName: host)
            pinger.delegate = self
            if isPing {
                self.start(pingType: oldPinger.addressStyle, interval: self.pingInterval, complete: self.complete)
            }
        }
    }


    private var pinger: SimplePing
    private var pingInterval: HDPingTimeInterval = .second(0)
    private var complete: PingComplete?
    private var lastSendItem: HDPingItem?
    private var lastReciveItem: HDPingItem?
    private var sendTimer: Timer?
    private var checkTimer: Timer?
    private var pingAddressIP = ""

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public init(hostName: String? = nil) {
        var host = hostName ?? "www.apple.com"
        if host.isEmpty {
            host = "www.apple.com"
        }
        pinger = SimplePing(hostName: host)
        super.init()
        pinger.delegate = self
    }

    public convenience init(url: URL?) {
        self.init(hostName: url?.host)
    }

    /// 开始ping请求
    /// - Parameters:
    ///   - pingType: ping的类型
    ///   - interval: 是否重复定时ping
    ///   - complete: 请求的回调
    public func start(pingType: SimplePingAddressStyle = .any, interval: HDPingTimeInterval = .second(0), complete: PingComplete? = nil) {
        //移除消息订阅
        NotificationCenter.default.removeObserver(self)
        //切到后台
        NotificationCenter.default.addObserver(self, selector: #selector(_didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        //切到前台
        NotificationCenter.default.addObserver(self, selector: #selector(_didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        //开始请求
        self._start(pingType: pingType, interval: interval, complete: complete)
    }

    //结束ping
    public func stop() {
        //移除消息订阅
        NotificationCenter.default.removeObserver(self)
        //移除顶部状态栏显示
        if self.showNetworkActivityIndicator == .auto || self.showNetworkActivityIndicator == .none {
            HDPingNetworkActivityIndicator.shared.isHidden = true
        } else {
            HDPingNetworkActivityIndicator.shared.isHidden = false
        }
        //结束状态
        self._stop()
    }
}

private extension HDPingTools {
    /// 开始ping请求
    func _start(pingType: SimplePingAddressStyle = .any, interval: HDPingTimeInterval = .second(0), complete: PingComplete? = nil) {
        self._stop()
        if self.showNetworkActivityIndicator == .auto || self.showNetworkActivityIndicator == .always {
            HDPingNetworkActivityIndicator.shared.isHidden = false
        } else {
            HDPingNetworkActivityIndicator.shared.isHidden = true
        }

        self.pingInterval = interval
        self.complete = complete
        self.pinger.addressStyle = pingType
        self.pinger.start()
        self.isRunning = true

        if interval.second > 0 {
            sendTimer = Timer(timeInterval: interval.second, repeats: true, block: { [weak self] (_) in
                guard let self = self else { return }
                self._start(pingType: pingType, interval: interval, complete: complete)
            })
            //循环发送
            RunLoop.main.add(sendTimer!, forMode: .common)
        }
    }

    func _stop() {
        self._complete()
        //停止发送ping
        sendTimer?.invalidate()
        sendTimer = nil
        self.isRunning = false
    }

    //ping完成一次之后的清理，ping成功或失败均会调用
    func _complete() {
        self.pinger.stop()
        self.isPing = false
        lastSendItem = nil
        lastReciveItem = nil
        pingAddressIP = ""
        //检测超时的timer停止
        checkTimer?.invalidate()
        checkTimer = nil
    }

    @objc func _didEnterBackground() {
        if debugLog {
            print("didEnterBackground: stop ping")
        }
        self._stop()
    }

    @objc func _didBecomeActive() {
        if debugLog {
            print("didBecomeActive: ping resume")
        }
        self.start(pingType: self.pinger.addressStyle, interval: self.pingInterval, complete: self.complete)
    }

    func sendPingData() {
        guard !self.isPing else { return }
        pinger.send(with: nil)
    }

    func displayAddressForAddress(address: NSData) -> String {
        var hostStr = [Int8](repeating: 0, count: Int(NI_MAXHOST))

        let success = getnameinfo(
            address.bytes.assumingMemoryBound(to: sockaddr.self),
            socklen_t(address.length),
            &hostStr,
            socklen_t(hostStr.count),
            nil,
            0,
            NI_NUMERICHOST
        ) == 0
        let result: String
        if success {
            result = String(cString: hostStr)
        } else {
            result = "?"
        }
        return result
    }

    func shortErrorFromError(error: NSError) -> String {
        if error.domain == kCFErrorDomainCFNetwork as String && error.code == Int(CFNetworkErrors.cfHostErrorUnknown.rawValue) {
            if let failureObj = error.userInfo[kCFGetAddrInfoFailureKey as String] {
                if let failureNum = failureObj as? NSNumber {
                    if failureNum.intValue != 0 {
                        let f = gai_strerror(Int32(failureNum.intValue))
                        if f != nil {
                            return String(cString: f!)
                        }
                    }
                }
            }
        }
        if let result = error.localizedFailureReason {
            return result
        }
        return error.localizedDescription
    }
}

extension HDPingTools: SimplePingDelegate {
    public func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        pingAddressIP = self.displayAddressForAddress(address: NSData(data: address))
        if debugLog {
            print("ping: ", pingAddressIP)
        }
        //发送一次ping
        self.sendPingData()
    }

    public func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        if debugLog {
            print("ping failed: ", self.shortErrorFromError(error: error as NSError))
        }
        HDPingNetworkActivityIndicator.shared.update(time: 460)
        if let complete = self.complete {
            complete(nil, HDPingError.requestError)
        }
        //标记完成
        self._complete()
        //停止ping
        if stopWhenError {
            self._stop()
        }
    }

    public func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        if debugLog {
            print("ping sent \(packet.count) data bytes, icmp_seq=\(sequenceNumber)")
        }
        self.isPing = true
        lastSendItem = HDPingItem(sendTime: Date(), sequence: sequenceNumber)
        //发送数据之后监测是否超时
        if timeout.second > 0 {
            checkTimer?.invalidate()
            checkTimer = nil
            checkTimer = Timer(timeInterval: timeout.second, repeats: false, block: { [weak self] (_) in
                guard let self = self else { return }
                if self.lastSendItem?.sequence != self.lastReciveItem?.sequence {
                    HDPingNetworkActivityIndicator.shared.update(time: 460)
                    //超时
                    if let complete = self.complete {
                        complete(nil, HDPingError.timeout)
                    }
                    //标记完成
                    self._complete()
                    //停止ping
                    if self.stopWhenError {
                        self._stop()
                    }
                }
            })
            RunLoop.main.add(checkTimer!, forMode: .common)
        }

    }

    public func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error) {
        if debugLog {
            print("ping send error: ", sequenceNumber, self.shortErrorFromError(error: error as NSError))
        }
        HDPingNetworkActivityIndicator.shared.update(time: 460)
        if let complete = self.complete {
            complete(nil, HDPingError.receiveError)
        }
        //标记完成
        self._complete()
        //停止ping
        if self.stopWhenError {
            self._stop()
        }
    }

    public func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        if let sendPingItem = lastSendItem {
            let time = Date().timeIntervalSince(sendPingItem.sendTime).truncatingRemainder(dividingBy: 1) * 1000
            if debugLog {
                print("\(packet.count) bytes from \(pingAddressIP): icmp_seq=\(sequenceNumber) time=\(time)ms")
            }
            HDPingNetworkActivityIndicator.shared.update(time: Int(time))
            if let complete = self.complete {
                let response = HDPingResponse(pingAddressIP: pingAddressIP, responseTime: .millisecond(time), responseBytes: packet.count)
                complete(response, nil)
            }
            lastReciveItem = HDPingItem(sendTime: Date(), sequence: sequenceNumber)
            //标记完成
            self._complete()
        }
    }

    public func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        if debugLog {
            print("unexpected receive packet, size=\(packet.count)")
        }
        //标记完成
        self._complete()
        //停止ping
        if self.stopWhenError {
            self._stop()
        }
    }
}
