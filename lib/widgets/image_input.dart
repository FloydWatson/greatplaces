import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {

  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;
  // instantiate ImagePicker
  final _picker = ImagePicker();

  Future<void> _takePicture() async {
    // returns a future of PickedFile
    final PickedFile pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      // set size to save space. will stp hi res images as we dont need them
      maxWidth: 600,
    );

    
    // parse picked file
    final File imageFile = File(pickedFile.path);

    if(imageFile == null){
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    // get our app directory where we are allowed to store data
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    // get image path. this is a temp dir. basename gives us file name and extension
    final fileName = path.basename(imageFile.path);
    // add image to our app dir. get final dest path
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    // pass to func in add place
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
