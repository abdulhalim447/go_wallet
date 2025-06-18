import 'package:flutter/material.dart';
import 'package:go_wallet/models/notice.dart';
import 'package:go_wallet/services/notice_service.dart';

class MyBkashWidget extends StatefulWidget {
  const MyBkashWidget({Key? key}) : super(key: key);

  @override
  State<MyBkashWidget> createState() => _MyBkashWidgetState();
}

class _MyBkashWidgetState extends State<MyBkashWidget> {
  Notice? _latestNotice;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLatestNotice();
  }

  Future<void> _loadLatestNotice() async {
    try {
      final notices = await NoticeService.getNotices();
      setState(() {
        _latestNotice = notices.isNotEmpty ? notices.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.blue[100]!,
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Notice Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue[600],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.campaign_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Notice',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Notice Content
          Container(
            padding: EdgeInsets.all(20),
            child: _isLoading
                ? Center(
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : _error != null
                    ? Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[400],
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: TextStyle(
                                color: Colors.red[400],
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    : _latestNotice == null
                        ? Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'No notices available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _latestNotice!.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _latestNotice!.notice,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[800],
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}
