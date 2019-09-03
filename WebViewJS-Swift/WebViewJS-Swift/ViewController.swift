//
//  ViewController.swift
//  WebViewJS-Swift
//
//  Created by 嘴爷 on 2019/8/26.
//  Copyright © 2019 嘴爷. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler, WKUIDelegate {
    
    lazy var webView : WKWebView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true //可以禁止弹出全屏  网页video标签要加上 playsinline 这个属性
        let uc = WKUserContentController()
        config.userContentController = uc
        uc.add(self, name: "CallApp")
        uc.add(self, name: "APPVideoPlay")
        //        其中name参数在JS里的写法如下：
        //        window.webkit.messageHandlers.CallApp.postMessage(params);
        //        就是 messageHandlers 后面的参数
        
        let web = WKWebView(frame: .zero, configuration: config)
        //        webView.frame = view.bounds
        web.uiDelegate = self;
        
        return web
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        addConstraintForWebView()
        loadHomePage()
        // Do any additional setup after loading the view.
    }
    
    func addConstraintForWebView(){
        let topConstraint = NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: webView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: webView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0)
        
        //        此属性必须要设置为false，否则约束不生效
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([topConstraint, rightConstraint, bottomConstraint, leftConstraint])
    }
    
    func loadHomePage() {
        
        let filePath = Bundle.main.path(forResource: "WebPage", ofType: ".html")
        
        if let path = filePath {//必须判断，否则可能为空会导致编译不通过
            let url = URL(fileURLWithPath: path)
            webView.loadFileURL(url, allowingReadAccessTo: url)
        }else{
            print("路径不存在")
        }
    }
    
    //    MARK:WKScriptMessageHandler
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("方法名：" + message.name)
        print("参数：\(message.body)")
        if message.name == "APPVideoPlay" {
            print("是让我播放视频吗？")
            let url = "http://muymov.a.yximgs.com/bs2/newWatermark/MTQwMjI4MjU2NDM_zh_4.mp4"
            
            //  必须要有双引号
            let method = "videoPlay(\"\(url)\")"
            webView.evaluateJavaScript(method) { (obj, error) in
                if let myError = error {
                    print(myError)
                }else{
                    print("JS方法调用成功")
                }
            }
            
        }
    }
    
    //    MARK: WKUIDelegate
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(message)
        completionHandler()
    }
    
    
}

