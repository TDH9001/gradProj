import 'package:flutter/material.dart';
import 'package:grad_proj/models/feed_Items.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/media_service.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context);
    if (_auth.user == null) {
      return CircularProgressIndicator();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
              width: double.infinity,
              height: MediaService.instance.getHeight() * 0.06,
              child: TextFormField(
                onChanged: (str) {
                  widget.searchText = str;
                  // dev.log(ChatsScreenSearchBar.chatSearch = str);
                  setState(() {});
                },
                //   controller: widget.txt,
                keyboardType: TextInputType.text,
                autocorrect: false,
                decoration: InputDecoration(
                  //label: Text("Search"),
                  icon: Icon(Icons.search),
                  labelText: "Search for courses",
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              )),
          Container(
            height: MediaService.instance.getHeight() * 0.75,
            child: StreamBuilder<List<FeedItems>>(
              stream: DBService()
                  .getUserFeed(_auth.user!.uid, widget.searchText.trim()),
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
                        return Center(child: Text("No data"));
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
