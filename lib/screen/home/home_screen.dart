import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: AuthProvider.instance,
        child: (Scaffold(
            // appBar: AppBar(
            //   // backgroundColor: Color(0xFF1C1C1C),
            //   title: Center(
            //     child: Text(
            //       'HomeScreen.title'.tr(),
            //       style: TextStyle(fontSize: 15),
            //       softWrap: true,
            //       overflow: TextOverflow.visible,
            //     ),
            //   ),
            //   actions: [
            //     IconButton(
            //       icon: Icon(Icons.view_list),
            //       tooltip: 'HomeScreen.important'.tr(),
            //       onPressed: () {
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(builder: (context) => FeedTestScreen()),
            //         );
            //       },
            //     ),
            //   ],
            // ),
            body: GetUsersStream())));
  }
}

class GetUsersStream extends StatefulWidget {
  GetUsersStream({
    super.key,
  });
  String searchText = "";

  @override
  State<GetUsersStream> createState() => _GetUsersStreamState();
}

class _GetUsersStreamState extends State<GetUsersStream> {
  bool star = false;
  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    final _auth = Provider.of<AuthProvider>(context);
    if (_auth.user == null) {
      return CircularProgressIndicator();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: MediaService.instance.getHeight() * 0.06,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey.shade800
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color:
                              isDarkMode ? Colors.white60 : Color(0xff769BC6)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: TextFormField(
                        onChanged: (str) {
                          widget.searchText = str;
                          setState(() {});
                        },
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'home.search_for_courses'.tr(),
                          hintStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.grey.shade600),
                          prefixIcon: Icon(Icons.search,
                              color: isDarkMode
                                  ? Colors.white60
                                  : Colors.grey.shade700),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  children: [
                    Container(
                      height: MediaService.instance.getHeight() * 0.06,
                      width: MediaService.instance.getHeight() * 0.06,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: isDarkMode
                                ? Colors.white60
                                : Color(0xff769BC6)),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.star,
                          color: star
                              ? Color(0xff769BC6)
                              : (isDarkMode
                                  ? Colors.white60
                                  : Colors.grey.shade700),
                        ),
                        onPressed: () {
                          setState(() {
                            star = !star;
                            if (star == false) {
                              SnackBarService.instance
                                  .showsSnackBarSucces(text: "personal feed");
                            } else {
                              SnackBarService.instance
                                  .showsSnackBarSucces(text: "favorites feed");
                            }
                          });
                        },
                        tooltip: star ? 'Unmark Favorite' : 'Mark as Favorite',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: MediaService.instance.getHeight() * 0.75,
            child: StreamBuilder<List<FeedItems>>(
              stream: !star
                  ? DBService()
                      .getUserFeed(_auth.user!.uid, widget.searchText.trim())
                  : DBService.instance.getUserStaredFeed(
                      _auth.user!.uid, widget.searchText.trim()),
              builder: (context, _snapshot) {
                if (_snapshot.connectionState == ConnectionState.waiting ||
                    _snapshot.connectionState == ConnectionState.none) {
                  return Center(child: CircularProgressIndicator());
                }
                if (_snapshot.hasError) {
                  return Center(
                      child: Text(
                          "Error: ${_snapshot.error} \n please update your data and the data field mising"));
                }
                // print(data);
                var items = _snapshot.data;
                var data = items?.reversed.toList();

                return ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      if (data.isEmpty) {
                        return Center(child: Text('home.no_data'.tr()));
                      } else {
                        return data[index].present(context: context);
                      }
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
