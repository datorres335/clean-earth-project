/*

* MIGHT NOT USE THIS CODE AT ALL
* pick_image.dart is much better code
*
* */

// CHATGPT CODE *************************************************************************************
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// class PostPage extends StatefulWidget {
//   const PostPage({super.key});
//
//   @override
//   State<PostPage> createState() => _PostPageState();
// }
//
// class _PostPageState extends State<PostPage> with WidgetsBindingObserver {
//   List<CameraDescription> cameras = [];
//   CameraController? cameraController;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     if (cameraController == null || cameraController?.value.isInitialized == false) {
//       return;
//     }
//
//     if (state == AppLifecycleState.inactive) {
//       cameraController?.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _setupCameraController();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _setupCameraController();
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     cameraController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _buildUI(),
//     );
//   }
//
//   Widget _buildUI() {
//     if (cameraController == null || cameraController?.value.isInitialized == false) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     return SafeArea(
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           CameraPreview(
//             cameraController!,
//           ),
//           Positioned(
//             bottom: 50,
//             left: MediaQuery.of(context).size.width * 0.4,
//             child: IconButton(
//               onPressed: () async {
//                 XFile picture = await cameraController!.takePicture();
//                 print("Picture saved to: ${picture.path}");
//                 /*
//                    * TODO: NEED TO HANDLE WHAT TO DO WITH PICTURE TAKEN.
//                    *  in tutorial https://www.youtube.com/watch?v=TrmoRtn5MZA he saves the picture directly onto phone with:
//                    * Gal.putImage(picture.path);
//                 * */
//               },
//               iconSize: 70,
//               icon: const Icon(
//                 Icons.camera,
//                 color: Colors.red,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _setupCameraController() async {
//     List<CameraDescription> _cameras = await availableCameras();
//     if (_cameras.isNotEmpty) {
//       setState(() {
//         cameras = _cameras;
//         cameraController = CameraController(
//           _cameras.first,
//           ResolutionPreset.max,
//         );
//       });
//       cameraController?.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//       }).catchError(
//             (Object e) {
//           print(e);
//         },
//       );
//     }
//   }
// }



// YOUTUBE TUTORIAL CODE https://www.youtube.com/watch?v=TrmoRtn5MZA *************************************************************************
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage>  with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    if (cameraController == null || cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.30,
              width: MediaQuery.sizeOf(context).width * 0.80,
              child: Transform.rotate(
                angle: -1.5708, // Rotate by 90 degrees (π/2 radians) For _cameras.last 1.5708 -> π/2 radians is ok
                // for _cameras.first need to transform by -1.5708
                child: CameraPreview(
                  cameraController!,
                ),
              ),
            ),
            IconButton(
                onPressed: () async {
                  XFile picture = await cameraController!.takePicture();
                  /*
                  * TODO: NEED TO HANDLE WHAT TO DO WITH PICTURE TAKEN.
                  *  in tutorial https://www.youtube.com/watch?v=TrmoRtn5MZA he saves the picture directly onto phone with:
                  * Gal.putImage(picture.path);
                  * */
                },
                iconSize: 50,
                icon: const Icon(
                  Icons.camera,
                  color: Colors.red,
                ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _setupCameraController() async {
    List<CameraDescription> _cameras = await availableCameras();
    if(_cameras.isNotEmpty) {
      setState(() {
        cameras = _cameras;
        cameraController = CameraController(
            _cameras.first,
            ResolutionPreset.max,
        );
      });
      cameraController?.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      }).catchError(
        (Object e) {
          print(e);
        },
      );
    }
  }
}
