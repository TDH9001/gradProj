import 'package:flutter/material.dart';
import 'package:grad_proj/services/media_service.dart';

class ImageContainerHeroWidget extends StatelessWidget {
  ImageContainerHeroWidget(
      {super.key,
      required this.fileAdress,
      required this.imageToShow,
      this.possibleChild});

  final String fileAdress;
  final ImageProvider imageToShow;
  Widget? possibleChild ;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: fileAdress,
        child: Container(
          height: MediaService.instance.getHeight() * 0.35,
          width: MediaService.instance.getWidth() * 0.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: possibleChild == null
                ? DecorationImage(
                    image: imageToShow,
                    fit: BoxFit.fill,
                  )
                : null,
          ),
          child: possibleChild,
        ));
  }
}
