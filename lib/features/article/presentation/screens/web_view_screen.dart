import 'package:flutter/material.dart'; // Import standard material package
import 'package:webview_flutter/webview_flutter.dart'; // Import webview plugin

class WebViewScreen extends StatefulWidget{ // Widget that displays a web page
  //the url to load
  final String url; // URL string passed from the previous screen

  const WebViewScreen({ // Constructor for the screen
    super.key, // Key for the widget
    required this.url // Require URL argument
  }); // End of constructor

  @override // Override createState method
  State<WebViewScreen> createState() => _WebViewScreenState(); // Create state for this widget
} // End of WebViewScreen class

class _WebViewScreenState extends State<WebViewScreen> { // State class for the web view
  late final WebViewController _controller; // Controller to manage the web view
  //to show the loading progress
  var _loadingPercentage = 0; // Variable to track page load progress

  @override // Override initState
  void initState(){ // Called when state is created
    super.initState(); // Call parent initState

    //initializing the WebViewController
    _controller = WebViewController() // Instantiate the controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Allow JS to run on pages
      ..setBackgroundColor(const Color(0x00000000)) // Set background to transparent
      ..setNavigationDelegate( // Setup navigation events
        NavigationDelegate( // Delegate to handle page events
          onPageStarted: (String url) { // Triggered when page starts loading
            setState(() { _loadingPercentage = 0; }); // Reset progress to 0
          }, // End onPageStarted
          onProgress: (int progress) { // Triggered as page loads
            setState(() { _loadingPercentage = progress; }); // Update progress value
          }, // End onProgress
          onPageFinished: (String url) { // Triggered when page is done
            setState(() { _loadingPercentage = 100; }); // Set progress to 100%
          }, // End onPageFinished
          onWebResourceError: (WebResourceError error) { // Triggered on load error
            // Handling errors if needed
          }, // End onWebResourceError
        ), // End NavigationDelegate
      ) // End setNavigationDelegate
      //loading the initial url
      ..loadRequest(Uri.parse(widget.url)); // Load the URL provided to the widget
  } // End initState

  @override // Override build method
  Widget build(BuildContext context) { // Build the UI
    return Scaffold( // Basic layout structure
      appBar: AppBar( // Top app bar
        title: const Text('Full Article'), // Title text for the screen
        //showing a loading indicator in the AppBar
        bottom: _loadingPercentage < 100 // Check if page is still loading
            ? PreferredSize( // Widget to set custom height for bottom widget
              //The height of the progress bar
              preferredSize: const Size.fromHeight(4.0), // Set height to 4 pixels
              child: LinearProgressIndicator( // Progress bar widget
                value: _loadingPercentage/100.0, // Normalize value between 0 and 1
                backgroundColor: Colors.white, // Color behind the progress bar
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor), // Color of the progress bar
              ), // End LinearProgressIndicator
            ) // End PreferredSize
        //returning null when the loading is complete
            : null, // Hide progress bar if fully loaded
      ), // End AppBar
      body: WebViewWidget(controller: _controller), // Show the web view content
    ); // End Scaffold
  } // End build method
} // End _WebViewScreenState class