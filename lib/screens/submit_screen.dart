import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' hide ImageSource;
import 'package:image_picker/image_picker.dart';
import 'package:nasa_apod_app/constants.dart';
import 'package:nasa_apod_app/strings.dart';
import 'package:nasa_apod_app/utils.dart';
import 'package:nasa_apod_app/widgets/app_drawer.dart';
import 'package:nasa_apod_app/widgets/background_gradient.dart';
import 'package:nasa_apod_app/widgets/centered_circular_progress_indicator.dart';
import 'package:nasa_apod_app/widgets/custom_button.dart';

class SubmitScreen extends StatefulWidget {
  static const routeName = '/submit';

  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  File? _selectedImage;
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _desriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _timeFocusNode = FocusNode();
  final FocusNode _locationFocusNode = FocusNode();

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _imageUrlController.clear();
      });
    }
  }

  Future<void> _submitImage() async {
    final String emailBody =
        'Title: ${_titleController.text}<br><br>Description: ${_desriptionController.text}<br><br>${_imageUrlController.text.isEmpty ? 'The image is attached to this email' : 'Image: <a href="${_imageUrlController.text}">${_imageUrlController.text}</a>'}<br><br>Time taken: ${_timeController.text}<br>Location Taken: ${_locationController.text}';
    final Email email = Email(
      recipients: recipients,
      subject: Strings.emailSubject,
      body: emailBody,
      attachmentPaths: [if (_selectedImage != null) _selectedImage!.path],
      isHTML: true,
    );
    await FlutterEmailSender.send(email);
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _titleController.dispose();
    _desriptionController.dispose();
    _timeController.dispose();
    _locationController.dispose();

    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _timeFocusNode.dispose();
    _locationFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(prevScreen: SubmitScreen.routeName),
      appBar: AppBar(
        title: const Text(Strings.submitScreenTitle),
      ),
      body: BackgroundGradient(
        padding: const EdgeInsets.all(16),
        height: Utils.getHeightOfPage(context),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  height: _selectedImage == null ? MediaQuery.of(context).size.height * 0.3 : null,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  child: _imageUrlController.text.isNotEmpty
                      ? NetworkImageForPreview(imageUrlController: _imageUrlController)
                      : _selectedImage != null
                          ? FileImageForPreview(selectedImage: _selectedImage!)
                          : const Center(
                              child: Text(
                                Strings.noImageSelected,
                                style: whiteTextStyle,
                              ),
                            ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PickImageButton(onPressed: _pickImage),
                    const SizedBox(width: 20),
                    const Text(
                      Strings.or,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(width: 20),
                    //* Image URL
                    Expanded(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty && _selectedImage == null) {
                            return Strings.enterValidUrl;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          _selectedImage = null;
                          setState(() {});
                          _titleFocusNode.requestFocus();
                        },
                        style: whiteTextStyle,
                        keyboardType: TextInputType.url,
                        controller: _imageUrlController,
                        decoration: buildInputDecoration(context, Strings.imageUrlLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //* Image Title
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Strings.enterTitle;
                    }
                    return null;
                  },
                  focusNode: _titleFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _descriptionFocusNode.requestFocus();
                  },
                  style: whiteTextStyle,
                  textCapitalization: TextCapitalization.words,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  controller: _titleController,
                  decoration: buildInputDecoration(context, Strings.titleLabel),
                ),

                const SizedBox(height: 20),
                //* Image Description
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Strings.enterDescription;
                    }
                    return null;
                  },
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _timeFocusNode.requestFocus();
                  },
                  style: whiteTextStyle,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  controller: _desriptionController,
                  maxLines: 3,
                  decoration: buildInputDecoration(context, Strings.descriptionLabel),
                ),
                const SizedBox(height: 20),
                //* Image Time
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Strings.enterTime;
                    }
                    return null;
                  },
                  focusNode: _timeFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    _locationFocusNode.requestFocus();
                  },
                  style: whiteTextStyle,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  controller: _timeController,
                  decoration: buildInputDecoration(context, Strings.timeLabel),
                ),
                const SizedBox(height: 20),
                //* Image Location
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Strings.enterLocation;
                    }
                    return null;
                  },
                  focusNode: _locationFocusNode,
                  style: whiteTextStyle,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  controller: _locationController,
                  decoration: buildInputDecoration(context, Strings.locationLabel),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: Strings.submit,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            'Note',
                            style: whiteTextStyle,
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: whiteTextStyle,
                              ),
                            ),
                            TextButton(
                              onPressed: _submitImage,
                              child: const Text(
                                'Continue',
                                style: whiteTextStyle,
                              ),
                            ),
                          ],
                          content: SingleChildScrollView(
                            child: HtmlWidget(
                              Strings.methodsTosubmit,
                              textStyle: whiteTextStyle,
                              customStylesBuilder: (element) {
                                switch (element.localName) {
                                  case 'a':
                                    return {'text-decoration': 'none', 'color': 'blue'};
                                  case 'p':
                                    return {'text-align': 'justify'};
                                }
                                return null;
                              },
                            ),
                          ),
                          backgroundColor: darkBlue,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PickImageButton extends StatelessWidget {
  final void Function()? onPressed;

  const PickImageButton({super.key, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      icon: const Icon(Icons.photo_library),
      text: Strings.pickImage,
      onPressed: onPressed,
    );
  }
}

class FileImageForPreview extends StatelessWidget {
  const FileImageForPreview({
    super.key,
    required File selectedImage,
  }) : _selectedImage = selectedImage;

  final File _selectedImage;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.file(
      _selectedImage,
      fit: BoxFit.contain,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const SizedBox(
              height: 300,
              width: double.infinity,
              child: CenteredCircularProgressIndicator(),
            );
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
            );
          case LoadState.failed:
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: Column(
                children: const <Widget>[
                  Text(
                    Strings.imagePreviewFailed,
                    style: whiteTextStyle,
                  ),
                  Center(
                    child: Icon(Icons.replay),
                  ),
                ],
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}

class NetworkImageForPreview extends StatelessWidget {
  const NetworkImageForPreview({
    super.key,
    required TextEditingController imageUrlController,
  }) : _imageUrlController = imageUrlController;

  final TextEditingController _imageUrlController;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      _imageUrlController.text,
      fit: BoxFit.contain,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return const SizedBox(
              height: 300,
              width: double.infinity,
              child: CenteredCircularProgressIndicator(),
            );
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
            );
          case LoadState.failed:
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: SizedBox(
                height: 300,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      Strings.imagePreviewFailed,
                      style: whiteTextStyle,
                    ),
                    SizedBox(height: 8),
                    Icon(Icons.replay),
                  ],
                ),
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}

InputDecoration buildInputDecoration(BuildContext context, String labelText) {
  return InputDecoration(
    alignLabelWithHint: true,
    labelText: labelText,
    labelStyle: whiteTextStyle,
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
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
