import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Scedule_creation_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';

class SelectableScheduleItem extends StatelessWidget {
  SelectableScheduleItem({
    Key? key,
    required this.cont,
    required this.scheduleItem,
  });
  final BuildContext cont;
  final ScheduleItemClass scheduleItem;
  final CustomPopupMenuController controller = CustomPopupMenuController();

  bool isSelected = false;
  // Track if item is selected
  @override
  Widget build(BuildContext context) {
    return CustomPopupMenu(
      controller: controller,
      child: updatedSceduleItem(scheduleItem),
      pressType: PressType.singleClick,
      menuBuilder: () => FittedBox(
          child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.blueGrey),
        child: Row(
          children: [
            Column(
              children: [
                IconButton(
                    onPressed: () async {
                      controller.hideMenu();
                      ScheduleItemClass? scl = await SceduleCreationService
                          .instance
                          .createSceduleItem(
                              itemType: scheduleItem.type,
                              cont: cont,
                              chatID: scheduleItem.name.split(" ")[0] == "math"
                                  ? "math 105"
                                  : scheduleItem.name.split(" ")[0]);
                      if (scl != null) {
                        DBService.instance.updateSceduleItem(
                            scl,
                            scheduleItem,
                            scheduleItem.creatorId,
                            scheduleItem.name.split(" ")[0] == "math"
                                ? "math 105"
                                : scheduleItem.name.split(" ")[0]);
                        SnackBarService.instance.buildContext = cont;
                        SnackBarService.instance.showsSnackBarSucces(
                          text: "Successfully created the new item",
                        );
                      } else {
                        SnackBarService.instance.buildContext = cont;
                        SnackBarService.instance
                            .showsSnackBarError(text: "Error updated scedule");
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    )),
                Text("edit item")
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(children: [
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                onPressed: () {
                  controller.hideMenu();
                  scheduleItem.name.split(" ")[0];
                  DBService.instance.removeSceduleItem(
                      scheduleItem,
                      scheduleItem.creatorId,
                      scheduleItem.name.split(" ")[0] == "math"
                          ? "math 105"
                          : scheduleItem.name.split(" ")[0]);
                },
              ),
              Text("delete item")
            ])
          ],
        ),
      )),
    );
  }
}
