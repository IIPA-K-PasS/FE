import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../data/models/term_models.dart';

class TermDetailScreen extends StatefulWidget {
  final Term term;

  const TermDetailScreen({super.key, required this.term});

  @override
  State<TermDetailScreen> createState() => _TermDetailScreenState();
}

class _TermDetailScreenState extends State<TermDetailScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      );

    // URL이 있으면 웹뷰로, 없으면 HTML로 표시
    if (widget.term.contentUrl != null && widget.term.contentUrl!.isNotEmpty) {
      _controller.loadRequest(Uri.parse(widget.term.contentUrl!));
    } else {
      _controller.loadHtmlString(_buildHtmlContent());
    }
  }

  String _buildHtmlContent() {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
            body {
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                line-height: 1.6;
                color: #333;
                margin: 0;
                padding: 20px;
                background-color: #f8f9fa;
            }
            .container {
                background-color: white;
                border-radius: 12px;
                padding: 24px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
                max-width: 800px;
                margin: 0 auto;
            }
            .header {
                border-bottom: 2px solid #e9ecef;
                padding-bottom: 16px;
                margin-bottom: 24px;
            }
            .title {
                font-size: 24px;
                font-weight: bold;
                color: #212529;
                margin: 0 0 8px 0;
            }
            .status {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 14px;
                color: ${widget.term.agreed ? '#28a745' : '#6c757d'};
            }
            .content {
                font-size: 16px;
                line-height: 1.8;
                white-space: pre-wrap;
                word-wrap: break-word;
            }
            .required-badge {
                background-color: #dc3545;
                color: white;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
                margin-left: 8px;
            }
            .optional-badge {
                background-color: #6c757d;
                color: white;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 12px;
                margin-left: 8px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1 class="title">
                    ${widget.term.title}
                    <span class="${widget.term.isRequired ? 'required-badge' : 'optional-badge'}">
                        ${widget.term.isRequired ? '필수' : '선택'}
                    </span>
                </h1>
                <div class="status">
                    <span>${widget.term.agreed ? '✅ 동의함' : '❌ 미동의'}</span>
                </div>
            </div>
            <div class="content">
                ${widget.term.content.replaceAll('\n', '<br>')}
            </div>
        </div>
    </body>
    </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.term.title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (widget.term.contentUrl != null && widget.term.contentUrl!.isNotEmpty) {
                _controller.loadRequest(Uri.parse(widget.term.contentUrl!));
              } else {
                _controller.loadHtmlString(_buildHtmlContent());
              }
            },
            tooltip: '새로고침',
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.teal,
              ),
            ),
        ],
      ),
    );
  }
}

