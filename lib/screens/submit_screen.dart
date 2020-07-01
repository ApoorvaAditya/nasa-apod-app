import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';
import '../widgets/custom_button.dart';

class SubmitScreen extends StatefulWidget {
  static const routeName = '/submit';

  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  File _selectedImage;
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _desriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _descriptionFocusNode = FocusNode();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final PickedFile pickedImage =
        await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(pickedImage.path);
    });
  }

  Future<void> _submitImage() async {
    if (_formKey.currentState.validate()) {
      final Email email = Email(
        recipients: ['apoorvaufo3@gmail.com'],
        subject: 'NASA Submission',
        body: _desriptionController.text,
        attachmentPaths: [_selectedImage.path],
        isHTML: false,
      );
      await FlutterEmailSender.send(email);
    }
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _desriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(prevScreen: SubmitScreen.routeName),
      appBar: AppBar(
        title: const Text('Submit your Picture to NASA APOD'),
        backgroundColor: Colors.black,
      ), //MainAppBar(title: 'Submit your picture to NASA APOD'),
      body: BackgroundGradient(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height -
                kToolbarHeight -
                MediaQuery.of(context).padding.top,
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    height: _selectedImage == null
                        ? MediaQuery.of(context).size.height * 0.3
                        : null,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage,
                            fit: BoxFit.contain,
                          )
                        : const Center(
                            child: Text(
                              'No Image Selected',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CustomButton(
                        icon: Icon(Icons.photo_library),
                        text: 'Pick Image',
                        onPressed: _pickImage,
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        'OR',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          validator: (value) {
                            if (value.isEmpty && _selectedImage == null) {
                              return 'Please enter a valid URL';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            _descriptionFocusNode.requestFocus();
                          },
                          textCapitalization: TextCapitalization.none,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.url,
                          controller: _imageUrlController,
                          maxLines: 1,
                          decoration:
                              buildInputDecoration(context, 'Enter Image URL'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    focusNode: _descriptionFocusNode,
                    style: const TextStyle(color: Colors.white),
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    keyboardType: TextInputType.text,
                    controller: _desriptionController,
                    maxLines: 3,
                    decoration:
                        buildInputDecoration(context, 'Image Description'),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Submit',
                    onPressed: _submitImage,
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

InputDecoration buildInputDecoration(BuildContext context, String labelText) {
  return InputDecoration(
    alignLabelWithHint: true,
    labelText: labelText,
    labelStyle: const TextStyle(color: Colors.white),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.blue,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).errorColor,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).errorColor,
      ),
    ),
  );
}
