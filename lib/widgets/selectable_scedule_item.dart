import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:grad_proj/models/schedule.dart';
import 'package:grad_proj/services/DB-service.dart';
import 'package:grad_proj/services/Scedule_creation_service.dart';
import 'package:grad_proj/services/snackbar_service.dart';
import 'package:grad_proj/widgets/updated_scedule_item.dart';

class SelectableScheduleItem extends StatefulWidget {
  SelectableScheduleItem({
    Key? key,
    required this.cont,
    required this.scheduleItem,
  });
  final BuildContext cont;
  final ScheduleItemClass scheduleItem;

  @override
  _SelectableScheduleItemState createState() => _SelectableScheduleItemState();
}

class _SelectableScheduleItemState extends State<SelectableScheduleItem> {
  bool isSelected = false; // Track if item is selected

  @override
  Widget build(BuildContext context) {
    // return Stack(
    //   children: [
    //     // Schedule Item (Main Content)

    //     GestureDetector(
    //       onLongPress: () {
    //         setState(() {
    //           isSelected = true; // Select item when long-pressed
    //         });
    //       },
    //       onTap: () {
    //         setState(() {
    //           isSelected = false; // Deselect on tap
    //         });
    //       },
    //       child: AnimatedContainer(
    //         duration: Duration(milliseconds: 200),
    //         margin: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
    //         padding: EdgeInsets.all(1),
    //         decoration: BoxDecoration(
    //           color: isSelected ? Colors.blue.shade200 : Colors.white,
    //           borderRadius: BorderRadius.circular(1),
    //           boxShadow: isSelected
    //               ? [
    //                   BoxShadow(
    //                     color: Colors.blue.withValues(alpha: 0.5),
    //                     blurRadius: 8,
    //                     spreadRadius: 2,
    //                   )
    //                 ]
    //               : [
    //                   BoxShadow(
    //                     color: Colors.black12,
    //                     blurRadius: 4,
    //                     spreadRadius: 1,
    //                   )
    //                 ],
    //         ),
    //         child: updatedSceduleItem(widget.scheduleItem),
    //       ),
    //     ),

    //     // Floating Buttons (Only Show When Selected)
    //     if (isSelected)
    //       Positioned(
    //         right: 20,
    //         top: 10,
    //         child: Column(
    //           children: [
    //             FloatingActionButton(
    //               mini: true,
    //               backgroundColor: Colors.green,
    //               onPressed: () async {
    //                 ScheduleItemClass? scl =
    //                     await SceduleCreationService.instance.createSceduleItem(
    //                         itemType: widget.scheduleItem.type,
    //                         cont: widget.cont,
    //                         chatID:
    //                             widget.scheduleItem.name.split(" ")[0] == "math"
    //                                 ? "math 105"
    //                                 : widget.scheduleItem.name.split(" ")[0]);
    //                 if (scl != null) {
    //                   DBService.instance.updateSceduleItem(
    //                       scl,
    //                       widget.scheduleItem,
    //                       widget.scheduleItem.creatorId,
    //                       widget.scheduleItem.name.split(" ")[0] == "math"
    //                           ? "math 105"
    //                           : widget.scheduleItem.name.split(" ")[0]);
    //                 } else {
    //                   SnackBarService.instance.buildContext = widget.cont;
    //                   SnackBarService.instance.showsSnackBarError(
    //                       text: "Error creating the new item");
    //                 }
    //               },
    //               child: Icon(Icons.edit),
    //             ),
    //             SizedBox(height: 8),
    //             FloatingActionButton(
    //               mini: true,
    //               backgroundColor: Colors.red,
    //               onPressed: () {
    //                 widget.scheduleItem.name.split(" ")[0];
    //                 DBService.instance.removeSceduleItem(
    //                     widget.scheduleItem,
    //                     widget.scheduleItem.creatorId,
    //                     widget.scheduleItem.name.split(" ")[0] == "math"
    //                         ? "math 105"
    //                         : widget.scheduleItem.name.split(" ")[0]);
    //               },
    //               child: Icon(Icons.delete),
    //             ),
    //           ],
    //         ),
    //       ),
    //   ],
    // );
    return CustomPopupMenu(
      child: updatedSceduleItem(widget.scheduleItem),
      pressType: PressType.singleClick,
      menuBuilder: () => Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Row(
            children: [
              Column(
                children: [
                  IconButton(
                      onPressed: () async {
                        ScheduleItemClass? scl = await SceduleCreationService
                            .instance
                            .createSceduleItem(
                                itemType: widget.scheduleItem.type,
                                cont: widget.cont,
                                chatID: widget.scheduleItem.name
                                            .split(" ")[0] ==
                                        "math"
                                    ? "math 105"
                                    : widget.scheduleItem.name.split(" ")[0]);
                        if (scl != null) {
                          DBService.instance.updateSceduleItem(
                              scl,
                              widget.scheduleItem,
                              widget.scheduleItem.creatorId,
                              widget.scheduleItem.name.split(" ")[0] == "math"
                                  ? "math 105"
                                  : widget.scheduleItem.name.split(" ")[0]);
                          SnackBarService.instance.buildContext = widget.cont;
                          SnackBarService.instance.showsSnackBarSucces(
                            text: "Successfully created the new item",
                          );
                        } else {
                          SnackBarService.instance.buildContext = widget.cont;
                          SnackBarService.instance.showsSnackBarError(
                              text: "Error updated scedule");
                        }
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      )),
                  Text("edit item")
                ],
              ),
              Column(children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    widget.scheduleItem.name.split(" ")[0];
                    DBService.instance.removeSceduleItem(
                        widget.scheduleItem,
                        widget.scheduleItem.creatorId,
                        widget.scheduleItem.name.split(" ")[0] == "math"
                            ? "math 105"
                            : widget.scheduleItem.name.split(" ")[0]);
                  },
                ),
                Text("delete item")
              ])
            ],
          )),
    );
  }
}
