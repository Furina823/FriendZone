import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;
import '../model/post.dart';
import 'package:file_picker/file_picker.dart';
import '../event/google_location.dart';

class CreateSocial extends StatefulWidget {
  final String user_id;

  const CreateSocial({super.key, required this.user_id});

  @override
  _CreateSocialState createState() => _CreateSocialState();
}

class _CreateSocialState extends State<CreateSocial> {
  final _formKey = GlobalKey<FormState>();
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;
  bool isVideo = false;
  final TextEditingController textController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  void pickFile() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4'],
      );

      if (result != null) {
        PlatformFile file = result!.files.first;
        _fileName = path.basename(file.path!); // Get only the file name
        pickedfile = file;
        fileToDisplay = File(file.path!);

        // Determine if the picked file is a video
        isVideo = file.extension == 'mp4';
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void clearFile() {
    setState(() {
      _fileName = null;
      pickedfile = null;
      fileToDisplay = null;
      isVideo = false;
    });
  }

  void _navigateToLocationPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GoogleLocation()),
    );

    if (result != null) {
      setState(() {
        locationController.text = result; // Update the TextField with selected location
      });
    }
  }

  Future<void> submit() async {
    String? postMedia = pickedfile != null ? pickedfile!.path?.split('/').last : 'null';
    String postText = textController.text.isNotEmpty ? textController.text : 'null';
    String location = locationController.text.isNotEmpty ? locationController.text : 'null';

    if (postMedia == 'null' && postText == 'null') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add a media file or type something.')),
      );
      return;
    }

    DateTime now = DateTime.now();

    try {
      await createPost(
        widget.user_id,
        postMedia,
        postText,
        location,
        now,
      );

      Map<String, dynamic> postData = {
        'post_media': postMedia,
        'post_text': postText,
        'location': location,
      };

      print('Post submitted with data: $postData');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post submitted successfully.')),
      );
    } catch (e) {
      print('$e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post submitted successfully.')),
      );
    }

    textController.clear();
    locationController.clear();
    clearFile();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: 3,
                blurRadius: 10,
              ),
            ],
          ),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_left_sharp,
                size: 50,
              ),
              color: Color(0xff4C315C),
            ),
            backgroundColor: Colors.white,
            title: Text(
              "Create",
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: 400,
            height: 800,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xffD9D9D9),
                        ),
                        child: _fileName != null
                            ? isVideo
                                ? VideoPlayerScreen(file: fileToDisplay!)
                                : Image.file(
                                    fileToDisplay!,
                                    fit: BoxFit.fill,
                                  )
                            : IconButton(
                                icon: Icon(
                                  Icons.add_rounded,
                                  size: 50,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  pickFile();
                                },
                              ),
                      ),
                      if (_fileName != null)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              clearFile();
                            },
                          ),
                        ),
                    ],
                  ),
                  if (isLoading) Center(child: CircularProgressIndicator()),
                  SizedBox(
                    height: 40,
                  ),
                  TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Type Something...',
                      hintStyle: TextStyle(fontSize: 15),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(width: 0),
                      ),
                      filled: true,
                      fillColor: Color(0xffD9D9D9),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: _navigateToLocationPage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xffD9D9D9),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: Color(0xff4C315C),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                locationController.text.isEmpty
                                    ? 'Location'
                                    : locationController.text,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4C315C), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Rounded corners
                          ),
                        ),
                        onPressed: () {
                          submit();
                        },
                        child: Text(
                          "Post",
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final File file;
  VideoPlayerScreen({required this.file});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after the video is initialized
        _controller.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator());
  }
}
