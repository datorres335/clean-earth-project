// import 'package:flutter/material.dart';
//
// class DraggableSheet extends StatefulWidget {
//   final Widget child;
//   const DraggableSheet({super.key, required this.child});
//
//   @override
//   State<DraggableSheet> createState() => _DraggableSheetState();
// }
//
// class _DraggableSheetState extends State<DraggableSheet> {
//   final sheet = GlobalKey();
//   final controller = DraggableScrollableController();
//
//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(onChanged);
//   }
//
//   void onChanged() {
//     final currentSize = controller.size;
//     if (currentSize <= 0.05) collapse();
//   }
//
//   void collapse() => animateSheet(getSheet.snapSizes!.first);
//   void anchor() => animateSheet(getSheet.snapSizes!.last);
//   void expand() => animateSheet(getSheet.maxChildSize);
//   void hide() => animateSheet(getSheet.minChildSize);
//
//   void animateSheet(double size) {
//     controller.animateTo(size, duration: const Duration(microseconds: 50), curve: Curves.easeInOut);
//   }
//
//   DraggableScrollableSheet get getSheet => (sheet.currentWidget as DraggableScrollableSheet);
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (builder, constraints){
//       return DraggableScrollableSheet(
//           key: sheet,
//           initialChildSize: 0.5,
//           maxChildSize: 1, // make this 1 to cover the whole screen
//           minChildSize: 0.05,
//           expand: true,
//           snap: true,
//           snapSizes: [
//             60 / constraints.maxHeight,
//             0.5
//           ],
//           builder: (BuildContext context, ScrollController scrollController) {
//             return DecoratedBox(
//               decoration: const BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey,
//                       blurRadius: 10,
//                       spreadRadius: 1,
//                       offset: Offset(0, 1),
//                     )
//                   ],
//                   borderRadius: BorderRadius.only(topLeft: Radius.circular(22), topRight: Radius.circular(22))
//               ),
//               child: CustomScrollView(
//                 controller: scrollController,
//                 slivers: [
//                   topButtonIndicator(),
//                   SliverToBoxAdapter(
//                     child: widget.child,
//                   )
//                 ],
//               ),
//             );
//           }
//       );
//     });
//   }
//
//   SliverToBoxAdapter topButtonIndicator() {
//     return SliverToBoxAdapter(
//       child: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               child: Center(
//                 child: Wrap(children: [
//                   Container(
//                     width: 100,
//                     margin: EdgeInsets.only(top: 15, bottom: 15),
//                     height: 5,
//                     decoration: const BoxDecoration(
//                       color: Colors.black54,
//                       shape: BoxShape.rectangle,
//                       borderRadius: BorderRadius.all(Radius.circular(8.0))
//                     ),
//                   )
//                 ],),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


/*
* UPDATED DRAGGABLE SHEET SO THAT IT USES APP'S COLOR SCHEME
* */
import 'package:flutter/material.dart';

class DraggableSheet extends StatefulWidget {
  final Widget child;
  const DraggableSheet({super.key, required this.child});

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  final sheet = GlobalKey();
  final controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    controller.addListener(onChanged);
  }

  void onChanged() {
    final currentSize = controller.size;
    if (currentSize <= 0.05) collapse();
  }

  void collapse() => animateSheet(getSheet.snapSizes!.first);
  void anchor() => animateSheet(getSheet.snapSizes!.last);
  void expand() => animateSheet(getSheet.maxChildSize);
  void hide() => animateSheet(getSheet.minChildSize);

  void animateSheet(double size) {
    controller.animateTo(size, duration: const Duration(microseconds: 50), curve: Curves.easeInOut);
  }

  DraggableScrollableSheet get getSheet => (sheet.currentWidget as DraggableScrollableSheet);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme; // Access color scheme

    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          key: sheet,
          initialChildSize: 0.5,
          maxChildSize: 1, // Covers the whole screen
          minChildSize: 0.05,
          expand: true,
          snap: true,
          snapSizes: [
            60 / constraints.maxHeight,
            0.5,
          ],
          builder: (BuildContext context, ScrollController scrollController) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: theme.surface, // Use the surface color from the theme
                boxShadow: [
                  BoxShadow(
                    color: theme.shadow, // Use the shadow color from the theme
                    blurRadius: 10,
                    spreadRadius: 1,
                    offset: const Offset(0, 1),
                  )
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  topButtonIndicator(theme), // Pass theme for consistency
                  SliverToBoxAdapter(
                    child: widget.child,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  SliverToBoxAdapter topButtonIndicator(ColorScheme theme) {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
                child: Wrap(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.onSurface.withOpacity(0.6), // Slightly transparent onSurface color
                        shape: BoxShape.rectangle,
                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
