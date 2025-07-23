import 'package:flutter/material.dart';
import 'myhistory.dart'; // ✅ import หน้า MyHistory

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComMu',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8),
          child: Image.asset('images/logo.png', width: 32, height: 32),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xFF1BC0E8), Color(0xFF5451EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: Text(
            'ComMu',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.blue),
            iconSize: 35,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('images/B1.png', width: double.infinity, height: 120),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFFFD0F5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'กิจกรรมสานสัมพันธ์',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF4081),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildCourseCard(
              title: 'สาขาวิทยาการคอมพิวเตอร์',
              subtitle: 'จำนวนนักศึกษา',
              year1: '40',
              year2: '35',
              colors: [Colors.orange[400]!, Colors.red[400]!],
              iconPath: 'images/comsci.png',
              isLeftAligned: true,
              isTextRightAligned: true,
            ),
            SizedBox(height: 12),
            _buildCourseCard(
              title: 'สาขาเทคโนโลยีคอมพิวเตอร์และดิจิทัล',
              subtitle: 'จำนวนนักศึกษา',
              year1: '40',
              year2: '35',
              colors: [Colors.lightBlue[300]!, Colors.blue[300]!],
              iconPath: 'images/cdt.png',
              isLeftAligned: false,
            ),
            SizedBox(height: 12),
            _buildCourseCard(
              title: 'สาขาเทคโนโลยีสารสนเทศ',
              subtitle: 'จำนวนนักศึกษา',
              year1: '40',
              year2: '35',
              colors: [Colors.teal[400]!, Colors.green[400]!],
              iconPath: 'images/it.png',
              isLeftAligned: true,
              isTextRightAligned: true,
            ),
            SizedBox(height: 12),
            _buildCourseCard(
              title: 'สาขาคอมพิวเตอร์ศึกษา',
              subtitle: 'จำนวนนักศึกษา',
              year1: '40',
              year2: '35',
              colors: [Colors.purple[400]!, Colors.deepPurple[400]!],
              iconPath: 'images/com.png',
              isLeftAligned: false,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // ✅ ถ้ากดไอคอน person (index = 4) จะไปหน้า MyHistory
          if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHistoryScreen()),
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 24),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                    child: Text(
                      '1',
                      style: TextStyle(color: Colors.white, fontSize: 8),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String subtitle,
    required String year1,
    required String year2,
    required List<Color> colors,
    required String iconPath,
    required bool isLeftAligned,
    bool isTextRightAligned = false,
  }) {
    return Container(
      margin: isLeftAligned
          ? EdgeInsets.only(top: 1, bottom: 1, left: 16)
          : EdgeInsets.only(top: 1, bottom: 1, right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: isLeftAligned
            ? BorderRadius.only(
                topLeft: Radius.circular(100),
                bottomLeft: Radius.circular(100),
              )
            : BorderRadius.only(
                topRight: Radius.circular(100),
                bottomRight: Radius.circular(100),
              ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: isLeftAligned
              ? [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(iconPath, width: 120, height: 120),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isTextRightAligned
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: isTextRightAligned
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'ปี1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  year1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                child: Image.asset(
                                  'images/source.gif',
                                  width: double.infinity,
                                  height: 120,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text(
                                  'ปี2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  year2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]
              : [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  'ปี1',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  year1,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 20),
                            Container(
                              width: 60,
                              height: 60,
                              child: Center(
                                child: Image.asset(
                                  'images/source.gif',
                                  width: double.infinity,
                                  height: 120,
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Column(
                              children: [
                                Text(
                                  'ปี2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  year2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(iconPath, width: 120, height: 120),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
