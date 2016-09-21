* -=====================================================================-
*   Inneractive iOS SDK 
* -=====================================================================-
*   Update Date: Sep 2016
*   Further documentation found here:  
*   https://confluence.inner-active.com/display/DevWiki/iOS+SDK+guidelines
* -=====================================================================-

- Version 6.3.0
-========================================================================-
- Release date: 20/09/2016
- Improved SDK infrastructure - performance and stability.
- iOS 10 support
- Added response data API
- Added aditional video layout API
- Added video progress + duration API

- Version 6.2.7
-========================================================================-
- Release date: 08/08/2016
- Deprecated 'Default Ad loaded' API
- Added new API to configure the video layout
- Removed mute button visibility API, mute button is always visible
- Improved SDK infrastracture - performance and stability

- Version 6.2.6
-========================================================================-
- Release date: 06/06/2016
- Improved SDK infrastracture - performance and stability

- Version 6.2.5
-========================================================================-
- Release date: 17/05/2016
- Added audio session management API
- Improved SDK infrastracture - performance and stability

- Version 6.2.4
-========================================================================-
- Release date: 01/05/2016
- Improved SDK infrastracture - performance and stability

- Version 6.2.3
-========================================================================-
- Release date: 24/04/2016
- Improved SDK infrastracture - performance and stability 

- Version 6.2.2
-========================================================================-
- Release date: 22/03/2016
- Added Secure Mode API (ATS compatibility)
- Improved SDK infrastracture - performance and stability 

- Version 6.2.1
-========================================================================-
- Release date: 08/12/2016
- Improved SDK infrastracture - performance and stability 

- Version 6.2.0
-========================================================================-
- Release date: 28/12/2015
- IPv6 support
- Improved SDK infrastracture - performance and stability
- Auto-redirect blocking - Redirection without use of user interaction is now blocked and reported to Inneractive for inspection
- Added Native Ads API for requesting Image or Video only

- Version 6.1.0
-========================================================================-
- Release date: 29/10/2015
- Added mute button to video ads. Can be enabled by 'muteButtonIsVisible' property of IaAd object.
- Added mute button posititon configuration for non-fullscreen video mode - 'muteButtonPosition' property of IaAdConfig object. Example: "self.nativeAd.adConfig.muteButtonPosition = IaMuteButtonPositionBottomRight;".
- Removed 'nativeVideoShouldBeMuted' API.
- Removed ''muteVideo:' API.
- Added 'isMuted' property to IaNativeAd object. This property defines the default sound state for non-fullscreen mode, meaning the video will start with sound or not according to this property. Each time video pauses, the sound state will be reset according to this state.
- Improved SDK infrastructure - performance and stability.

- Version 6.0.1
-========================================================================-
- Release date: 27/08/2015
- Added support for Portrait Video Mode
- Added API to force interface orientation mode
- Added support for iOS 9

- Version 6.0
-========================================================================-
- Release date: 07/07/2015
- Added support for OpenRTB 2.3 Native 1.0 standard Native Ads
- 'isVideoAd' API added
- 'InneractiveVideoCompleted:' event added

- Version 5.0.5
-========================================================================-
- Release date: 03/05/2015

- Version 5.0.4
-========================================================================-
- Release date: 15/01/2014
- Native video ads
- New Story Ads
- Remote Settings
- Video configuration

- Version 5.0.3
-========================================================================-
- Release date: 29/09/2014
- Native VAST video ads support.
- Open In Safari Button added in internal-browser.

- Version 5.0.2
-========================================================================-
- Release date: 23/09/2014
- New improved internal browser UI.
- Full iOS 8 Support.
- Misc. bug fixes.

- Version 5.0.1 
-========================================================================-
- Release date: 06/07/2014
- Upgraded infrastructure with new API. For detailed information: https://confluence.inner-active.com/display/DevWiki/iOS+SDK+guidelines
- New SDK delegate events were added.
- Millennial Media SDK is supported (support for version 5.2.0).
- Ad Loading and timeout controlling was added.