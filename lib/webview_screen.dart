

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';



class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  InAppWebViewController? webViewController;
  PullToRefreshController? refreshController;

  var initialUrl = "https://potumia.com/login";
  double progress = 0;
  var isLoading = false;

  // bool _isLoading = true;

  final WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {



        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://potumia.com/login')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('https://potumia.com/login'));


  @override
  void initState() {

    super.initState();

    refreshController = PullToRefreshController(
      onRefresh: (){
        webViewController!.reload();
      },
      options: PullToRefreshOptions(

        color: Colors.blue,
        backgroundColor: Colors.black87
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Potumia',
        style: TextStyle(fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(

              child: Stack(
                alignment: Alignment.center,
            children:[ InAppWebView(
              onLoadStop: (controller, url){
                refreshController!.endRefreshing();
                setState(() {
                  isLoading = false;
                });
              },
              onLoadStart: (controller, url){
                setState(() {
                  isLoading = true;
                });
              },
              onProgressChanged: (controller, progress){
                if(progress == 100){
                  refreshController!.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                });
              },
              pullToRefreshController: refreshController,
              onWebViewCreated: (controller)=> webViewController = controller,
              initialUrlRequest: URLRequest(url: Uri.parse(initialUrl)),
            ),
              Visibility(
                visible: isLoading,

                  child: const CircularProgressIndicator(

                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ))

          ]))
        ],
      ),
    );
  }
}
