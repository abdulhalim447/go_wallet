import 'package:flutter/material.dart';
import 'package:go_wallet/models/notice.dart';
import 'package:go_wallet/services/notice_service.dart';
import 'package:go_wallet/screens/notice/notice_detail_screen.dart';

class MyBkashWidget extends StatefulWidget {
  const MyBkashWidget({Key? key}) : super(key: key);

  @override
  State<MyBkashWidget> createState() => _MyBkashWidgetState();
}

class _MyBkashWidgetState extends State<MyBkashWidget> {
  List<Notice> _notices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNotices();
  }

  Future<void> _loadNotices() async {
    try {
      final notices = await NoticeService.getNotices();
      setState(() {
        _notices = notices;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showNoticeDetail(Notice notice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoticeDetailScreen(notice: notice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Notice',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                if (_notices.isNotEmpty)
                  Text(
                    '${_notices.length} Updates',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(width: 0.2, color: Colors.grey),
            ),
            height: 85,
            width: MediaQuery.of(context).size.width,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(child: Text(_error!))
                    : _notices.isEmpty
                        ? Center(child: Text('No notices available'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _notices.length,
                            itemBuilder: (context, index) {
                              final notice = _notices[index];
                              return GestureDetector(
                                onTap: () => _showNoticeDetail(notice),
                                child: Container(
                                  width: 200,
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notice.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        notice.notice,
                                        style: TextStyle(fontSize: 10),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
