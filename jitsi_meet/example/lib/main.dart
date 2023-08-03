import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Meeting());
  }
}

class Meeting extends StatefulWidget {
  @override
  _MeetingState createState() => _MeetingState();
}

class _MeetingState extends State<Meeting> {
  final serverText = TextEditingController(text: "https://jitsi-dev.semilimes.net/");
  final roomText = TextEditingController(text: "17a41e68-f854-4e53-a2f2-6c49a0f3da35");
  final subjectText = TextEditingController(text: "Subject1");
  final nameText = TextEditingController(text: "User1");
  final emailText = TextEditingController(text: "fake1@email.com");
  final tokenText = TextEditingController(text: "");
  final iosAppBarRGBAColor =
  TextEditingController(text: "#0080FF80"); //transparent blue
  bool? isAudioOnly = true;
  bool? isAudioMuted = true;
  bool? isVideoMuted = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: kIsWeb
              ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.30,
                child: meetConfig(),
              ),
              Container(
                  width: width * 0.60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        color: Colors.white54,
                        child: SizedBox(
                          width: width * 0.60 * 0.70,
                          height: width * 0.60 * 0.70,
                          child: JitsiMeetConferencing(
                            extraJS: [
                              // extraJs setup example
                              '<script src="https://code.jquery.com/jquery-3.6.3.slim.js" integrity="sha256-DKU1CmJ8kBuEwumaLuh9Tl/6ZB6jzGOBV/5YpNE2BWc=" crossorigin="anonymous"></script>'
                            ],
                          ),
                        )),
                  ))
            ],
          )
              : meetConfig(),
        ),
      ),
    );
  }

  Widget meetConfig() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 16.0,
          ),
          TextField(
            controller: serverText,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Server URL",
                hintText: "Hint: Leave empty for meet.jitsi.si"),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: tokenText,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Token"),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: roomText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Room",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: subjectText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Subject",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: nameText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Display Name",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: emailText,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
          ),
          SizedBox(
            height: 14.0,
          ),
          TextField(
            controller: iosAppBarRGBAColor,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "AppBar Color(IOS only)",
                hintText: "Hint: This HAS to be in HEX RGBA format"),
          ),
          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          SizedBox(
            height: 14.0,
          ),
          CheckboxListTile(
            title: Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: ElevatedButton(
              onPressed: () {
                _joinMeeting();
              },
              child: Text(
                "Join Meeting",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue)),
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {

    // Define meetings options here
    final options = JitsiMeetingOptions(
        room: roomText.text.trim(),
        token: tokenText.text.trim(),
        serverURL: serverText.text.trim().isEmpty ? null : serverText.text,
        subject: subjectText.text,
        userDisplayName: nameText.text,
        userEmail: emailText.text,
        iosAppBarRGBAColor: iosAppBarRGBAColor.text,
        audioOnly: isAudioOnly,
        audioMuted: isAudioMuted,
        videoMuted: isVideoMuted,
        featureFlags: _getFeatureFlags(),
        webOptions: _getJitsiMeetWebOption(),
        //configOverrides: _getConfigOverrides()
    );

    await JitsiMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onOpened: () {
            debugPrint("JitsiMeetingListener - onOpened");
          },
          onClosed: () {
            debugPrint("JitsiMeetingListener - onClosed");
          },
          onError: (error) {
            debugPrint("JitsiMeetingListener - onError: error: $error");
          },
          onConferenceWillJoin: (url) {
            debugPrint(
                "JitsiMeetingListener - onConferenceWillJoin: url: $url");
          },
          onConferenceJoined: (url) {
            debugPrint("JitsiMeetingListener - onConferenceJoined: url:$url");
          },
          onConferenceTerminated: (url, error) {
            debugPrint(
                "JitsiMeetingListener - onConferenceTerminated: url: $url, error: $error");
          },
          onParticipantLeft: (participantId) {
            debugPrint(
                "JitsiMeetingListener - onParticipantLeft: $participantId");
          },
          onParticipantJoined: (email, name, role, participantId) {
            debugPrint("JitsiMeetingListener - onParticipantJoined: "
                "email: $email, name: $name, role: $role, "
                "participantId: $participantId");
          },
          onAudioMutedChanged: (muted) {
            debugPrint(
                "JitsiMeetingListener - onAudioMutedChanged: muted: $muted");
          },
          onVideoMutedChanged: (muted) {
            debugPrint(
                "JitsiMeetingListener - onVideoMutedChanged: muted: $muted");
          },
          onScreenShareToggled: (participantId, isSharing) {
            debugPrint("JitsiMeetingListener - onScreenShareToggled: "
                "participantId: $participantId, isSharing: $isSharing");
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("JitsiMeetingListener - readyToClose callback");
                }),
          ]),
    );
  }
  Map<String, dynamic> _getJitsiMeetWebOption(){
    return {
      "roomName": roomText.text.trim(),
      "token": tokenText.text.trim(),
      "width": "100%",
      "height": "100%",
      "enableNoAudioDetection": true,
      "enableNoisyMicDetection": true,
      "enableWelcomePage": false,
      "chromeExtensionBanner": null,
      "enableClosePage": false,
      'prejoinPageEnabled': false,
      'disableReactions': true,
      'hideAddRoomButton': true,
      'hideDisplayName': true,
      'hideParticipantsStats': true,
      'disableInviteFunctions': true,
      "configOverwrite": {
        'doNotFlipLocalVideo': true,
        "prejoinPageEnabled": false,
        "disableDeepLinking": true,
        "enableLobbyChat": false,
        "enableClosePage": false,
        "chromeExtensionBanner": null,
        'hideDisplayName': true,
        'hideConferenceTimer': true,
        'hideParticipantsStats': true,
        'hideLobbyButton': true,
        "toolbarConfig": {"alwaysVisible": true},
        "toolbarButtons": [ "microphone","camera", "hangup", 'tileview', 'fullscreen', 'toggle-camera',
          'participants-pane', 'highlight', 'desktop','filmstrip', 'dock-iframe', 'etherpad', 'recording', 'select-background'],

      },
      "userInfo": {"email": emailText.text, "displayName": nameText.text}
    };
  }
  Map<String, Object> _getConfigOverrides(){
    return {
      "prejoinPageEnabled": false,
      "enableClosePage": true,
      "disableInviteFunctions": true,
      "toolbarConfig": {"alwaysVisible": true},
      "toolbarButtons": [ "microphone","camera", "hangup", 'tileview', 'fullscreen', 'toggle-camera'],
      "disableSelfViewSettings": true,
      "disableProfile": true,
      "hiddenDomain": true,
    };
  }
  Map<FeatureFlagEnum, bool> _getFeatureFlags(){
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
      FeatureFlagEnum.CALENDAR_ENABLED: false,
      FeatureFlagEnum.LIVE_STREAMING_ENABLED: false,
      FeatureFlagEnum.INVITE_ENABLED : false,
      FeatureFlagEnum.ADD_PEOPLE_ENABLED: false,
      FeatureFlagEnum.FULLSCREEN_ENABLED: true,
      FeatureFlagEnum.PREJOIN_PAGE_ENABLED: false,
      FeatureFlagEnum.ANDROID_SCREENSHARING_ENABLED: false,
      FeatureFlagEnum.IOS_SCREENSHARING_ENABLED: false,
      FeatureFlagEnum.CONFERENCE_TIMER_ENABLED: false,
      FeatureFlagEnum.OVERFLOW_MENU_ENABLED: true,
      FeatureFlagEnum.CAR_MODE_ENABLED: false,
      FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE: true,
      FeatureFlagEnum.CHAT_ENABLED: false,
      FeatureFlagEnum.TILE_VIEW_ENABLED: true,
      FeatureFlagEnum.VIDEO_SHARE_BUTTON_ENABLED: false,
      FeatureFlagEnum.SETTINGS_ENABLED: false,
    };
    if (!kIsWeb && Platform.isAndroid) {
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
    }
    return featureFlags;
  }
}
