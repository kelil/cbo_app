import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';

class Services extends StatefulWidget{
  const Services({Key? key}) : super(key: key);


  @override
  State<StatefulWidget> createState()=> ServicesPage();
}

class ServicesPage extends State<Services>{

final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void initState() {
    super.initState();
    //getJSONData();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
     return  Scaffold(
        body:  Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl:"https://coopbankoromia.com.et/deposit-products/ordinary-demand-deposit-account/",
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
          navigationDelegate: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }
}
JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(message.message)),
        );
      });
}

