import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget{
  //the url to load
  final String url;

  const WebViewScreen({
    super.key,
    required this.url
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  //to show the loading progress
  var _loadingPercentage = 0;

  @override
  void initState(){
    super.initState();

    //initializing the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() { _loadingPercentage = 0; });
          },
          onProgress: (int progress) {
            setState(() { _loadingPercentage = progress; });
          },
          onPageFinished: (String url) {
            setState(() { _loadingPercentage = 100; });
          },
          onWebResourceError: (WebResourceError error) {
            // Handling errors if needed
          },
        ),
      )
      //loading the initial url
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Article'),
        //showing a loading indicator in the AppBar
        bottom: _loadingPercentage < 100
            ? PreferredSize(
              //The height of the progress bar
              preferredSize: const Size.fromHeight(4.0),
              child: LinearProgressIndicator(
                value: _loadingPercentage/100.0,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            )
        //returning null when the loading is complete
            : null,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}