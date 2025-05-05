import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/providers/auth_provider.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/widgets/selectable_scedule_item.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';

class CourseTemporarySceduleList extends StatelessWidget {
  const CourseTemporarySceduleList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScheduleItemClass>>(
        stream: DBService.instance
            .getUserTemporaryScedules(AuthProvider.instance.user!.uid),
        builder: (context, _snapshot) {
          if (_snapshot.connectionState == ConnectionState.waiting ||
              _snapshot.connectionState == ConnectionState.none) {
            return SliverToBoxAdapter(
              child: Center(
                  child: Image(image: AssetImage('assets/images/splash.png'))),
            );
          }
          if (_snapshot.hasError) {
            return Center(
                child: Text(
                    "Error: ${_snapshot.error} \n please update your data and the data field mising"));
          }
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return updatedSceduleItem(
              _snapshot.data![index],
            );
          }, childCount: _snapshot.data!.length));
        });
  }
}

class CoursesPermanatSceduleList extends StatelessWidget {
  const CoursesPermanatSceduleList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScheduleItemClass>>(
        stream: DBService.instance
            .getUserPermanatScedules(AuthProvider.instance.user!.uid),
        builder: (context, _snapshot) {
          if (_snapshot.connectionState == ConnectionState.waiting ||
              _snapshot.connectionState == ConnectionState.none) {
            return SliverToBoxAdapter(
              child: Center(
                  child: Image(image: AssetImage('assets/images/splash.png'))),
            );
          }
          if (_snapshot.hasError) {
            return SliverToBoxAdapter(
              child: Center(
                  child: Text(
                      "Error: ${_snapshot.error} \n please update your data and the data field mising")),
            );
          }
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return updatedSceduleItem(
              _snapshot.data![index],
            );
          }, childCount: _snapshot.data!.length));
        });
  }
}

class UserPerosnalSceduleList extends StatelessWidget {
  const UserPerosnalSceduleList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ScheduleItemClass>>(
        stream: DBService.instance
            .getUserPersonalScedule(AuthProvider.instance.user!.uid),
        builder: (context, _snapshot) {
          if (_snapshot.connectionState == ConnectionState.waiting ||
              _snapshot.connectionState == ConnectionState.none) {
            return SliverToBoxAdapter(
              child: Center(
                  child: Image(image: AssetImage('assets/images/splash.png'))),
            );
          }
          if (_snapshot.hasError) {
            return SliverToBoxAdapter(
              child: Center(
                  child: Text(
                      "Error: ${_snapshot.error} \n please update your data and the data field mising")),
            );
          }
          return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return SelectableScheduleItem(
              cont: context,
              scheduleItem: _snapshot.data![index],
            );
//            return updatedSceduleItem(_snapshot.data![index]);
          }, childCount: _snapshot.data!.length));
        });
  }
}
