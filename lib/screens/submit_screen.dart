import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:image_picker/image_picker.dart';

import '../constants.dart';
import '../strings.dart';
import '../utils.dart';
import '../widgets/app_drawer.dart';
import '../widgets/background_gradient.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/custom_button.dart';

class SubmitScreen extends StatefulWidget {
  static const routeName = '/submit';

  @override
  _SubmitScreenState createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  File _selectedImage;
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
    final PickedFile pickedImage = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(pickedImage.path);
      _imageUrlController.clear();
    });
  }

  Future<void> _submitImage() async {
    final Email email = Email(
      recipients: recipients,
      subject: Strings.emailSubject,
      body: _desriptionController.text + (_imageUrlController.text.isNotEmpty ? '\n${_imageUrlController.text}' : ''),
      attachmentPaths: [if (_selectedImage != null) _selectedImage.path],
      isHTML: false,
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
                          ? FileImageForPreview(selectedImage: _selectedImage)
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
                          if (value.isEmpty && _selectedImage == null) {
                            return Strings.enterValidUrl;
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          setState(() {});
                          _titleFocusNode.requestFocus();
                        },
                        textCapitalization: TextCapitalization.none,
                        style: whiteTextStyle,
                        keyboardType: TextInputType.url,
                        controller: _imageUrlController,
                        maxLines: 1,
                        decoration: buildInputDecoration(context, Strings.imageUrlLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                //* Image Title
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
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
                  enableSuggestions: true,
                  keyboardType: TextInputType.text,
                  controller: _titleController,
                  maxLines: 1,
                  decoration: buildInputDecoration(context, Strings.titleLabel),
                ),

                const SizedBox(height: 20),
                //* Image Description
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
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
                  autocorrect: true,
                  enableSuggestions: true,
                  keyboardType: TextInputType.text,
                  controller: _desriptionController,
                  maxLines: 3,
                  decoration: buildInputDecoration(context, Strings.descriptionLabel),
                ),
                const SizedBox(height: 20),
                //* Image Time
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
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
                  enableSuggestions: true,
                  keyboardType: TextInputType.text,
                  controller: _timeController,
                  maxLines: 1,
                  decoration: buildInputDecoration(context, Strings.timeLabel),
                ),
                const SizedBox(height: 20),
                //* Image Location
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return Strings.enterLocation;
                    }
                    return null;
                  },
                  focusNode: _locationFocusNode,
                  style: whiteTextStyle,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: false,
                  enableSuggestions: true,
                  keyboardType: TextInputType.text,
                  controller: _locationController,
                  maxLines: 1,
                  decoration: buildInputDecoration(context, Strings.locationLabel),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: Strings.submit,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _submitImage();
                    }
                  },
                ),
                const SizedBox(height: 20),
                HtmlWidget(
                  Strings.methodsTosubmit,
                  hyperlinkColor: Colors.blue,
                  textStyle: whiteTextStyle,
                  customStylesBuilder: (element) {
                    switch (element.localName) {
                      case 'a':
                        return ['text-decoration', 'none'];
                      case 'p':
                        return ['text-align', 'justify'];
                    }
                    return null;
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
  final void Function() onPressed;

  const PickImageButton({Key key, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      icon: Icon(Icons.photo_library),
      text: Strings.pickImage,
      onPressed: onPressed,
    );
  }
}

class FileImageForPreview extends StatelessWidget {
  const FileImageForPreview({
    Key key,
    @required File selectedImage,
  })  : _selectedImage = selectedImage,
        super(key: key);

  final File _selectedImage;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.file(
      _selectedImage,
      fit: BoxFit.contain,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(
              height: 300,
              width: double.infinity,
              child: const CenteredCircularProgressIndicator(),
            );
            break;
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
            );
            break;
          case LoadState.failed:
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: Column(
                children: <Widget>[
                  const Text(
                    Strings.imagePreviewFailed,
                    style: whiteTextStyle,
                  ),
                  Center(
                    child: Icon(Icons.replay),
                  ),
                ],
              ),
            );
            break;
          default:
            return null;
        }
      },
    );
  }
}

class NetworkImageForPreview extends StatelessWidget {
  const NetworkImageForPreview({
    Key key,
    @required TextEditingController imageUrlController,
  })  : _imageUrlController = imageUrlController,
        super(key: key);

  final TextEditingController _imageUrlController;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      _imageUrlController.text,
      fit: BoxFit.contain,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return Container(
              height: 300,
              width: double.infinity,
              child: const CenteredCircularProgressIndicator(),
            );
            break;
          case LoadState.completed:
            return ExtendedRawImage(
              image: state.extendedImageInfo?.image,
            );
            break;
          case LoadState.failed:
            return GestureDetector(
              onTap: () {
                state.reLoadImage();
              },
              child: Container(
                height: 300,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      Strings.imagePreviewFailed,
                      style: whiteTextStyle,
                    ),
                    const SizedBox(height: 8),
                    Icon(Icons.replay),
                  ],
                ),
              ),
            );
            break;
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
