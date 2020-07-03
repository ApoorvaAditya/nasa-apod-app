class Strings {
  // App Strings
  static const appTitle = 'NASA Astronomy Picture of the Day App';
  // Screen Titles
  static const allPicturesScreenTitle = 'All Pictures';
  static const submitScreenTitle = 'Submit a picture to NASA APOD';
  static const pastPicturesScreenTitle = 'Past Pictures';
  static const savedScreenTitle = 'Saved Pictures';
  static const settingsScreenTitle = 'Settings';
  //Submit Screen Strings
  static const emailSubject = 'Astronomy Picture of the Day Submission';
  static const noImageSelected = 'No Image Selected';
  static const imagePreviewFailed = 'Preview failed to load';
  static const pickImage = 'Pick Image';
  static const or = 'OR';
  static const enterValidUrl = 'Please enter a valid URL';
  static const imageUrlLabel = 'Image URL';
  static const enterDescription = 'Please enter a description';
  static const descriptionLabel = 'Image Description';
  static const submit = 'Submit Picture through E-mail';
  static const String methodsTosubmit = '''
<p>Images can be submitted to Astronomy Picture of the Day by email to the editors Robert Nemiroff and Jerry Bonnell.
 Both editors make an effort to see all images submitted to them by email.
<br><br> Additionally, you are welcome to post your image in the APOD discussion forum <a href="http://asterisk.apod.com/viewforum.php?f=29">
Asterisk</a> or APOD's <a href="https://www.flickr.com/groups/apods/">Flickr group</a>.
<br>
<br>
To judge relative popularity -- which is only one of many decision criteria --
some chosen images may be posted to 
<a href="https://www.facebook.com/APOD.Sky/">Facebook Sky</a> or
<a href="https://www.instagram.com/universe_view_screen/">Instagram "Universe View Screen"</a>. If this is not OK, please make this 
clear in your submission email.
<br>
<br>
Please note that by submitting your image to APOD, you are
consenting for your image to be used on APOD in all of its forms
unless you explicitly state otherwise. 

These include mirror sites,
foreign language mirror sites,
new media mirror sites, 
<a href="https://api.nasa.gov/api.html#apod">NASA's Open API for APOD</a>,
yearly calendars, 
and APOD on social fan pages as listed on the
<a href="../lib/about_apod.html">About APOD</a> page.
Some of these, like Facebook, carry advertising.

We do recommend 
that you include a small copyright notice in a corner of your 
submitted images.
Thanks! <p>

<b> Ethics statement: </b> APOD accepts composited or digitally manipulated images, but requires them to be identified as such and to have the techniques used described in a straightforward, honest and complete way.
</p>
''';
  static const String titleLabel = 'Image Title';
  static const String enterTitle = 'Please enter a title for the image';
  static const String enterTime = 'Please enter the time the image was taken';
  static const String enterLocation = 'Please enter the location the image was taken';
  static const String timeLabel = 'Time';
  static const String locationLabel = 'Location';
  // Past Pictures Screen
  static const date = 'Date';
  static const selectDate = 'Select Date';
  static const getPic = 'Get Picture';
  // Settings Screen
  static const albumNameSettingTitle = 'Album Name';
  static const albumNameSettingSubtitle = 'Name of album where downloaded pictures will be stored.';
  static const albumNameSettingHint = 'Enter album name';

  static const downloadOnSaveSettingTitle = 'Download Images on Save';
  static const downloadOnSaveSettingSubtitle = 'Should images be downloaded when saving pictures?';

  static const downloadHqSettingTitle = 'Download Highest Quality on Save';
  static const downloadHqSettingSubtitle = 'Should download highest available quality image when saving pictures?';
}
