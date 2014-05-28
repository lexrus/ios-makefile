![iOS Makefile - The universal makefile for my iOS projects distributes IPAs in seconds.](https://cloud.githubusercontent.com/assets/219689/3063886/3adcae20-e248-11e3-83b5-437854b66e80.png)

![Screenshots](https://cloud.githubusercontent.com/assets/219689/2875724/fa99b87a-d424-11e3-8ed6-cc6522b7f257.png)

## Features & TODOs
- [x] Git log as release notes
- [x] Overlaying git commit & branch on top of your App icon (ImageMagick is NOT required)
- [ ] Version subfix for IPAs
- [x] Shorten URL with my open source shortener [lexr.us](http://lexr.us) or [goo.gl](https://goo.gl)
- [x] QRCode of URL
- [x] Grayscale printer friendly
- [x] ```make show_settings PRODUCT_SETTINGS_PATH``` or ```make show_settings | grep FLAG.*``` --- Show build settings
- [x] ```make sort``` --- Sort Xcode project.pbxproj with [sort-Xcode-project-file](http://danieltull.co.uk/blog/2013/09/05/easier-merging-of-xcode-project-files/)
- [x] Notify QA team in seconds
  - [x] ```make send_email``` --- Send emails with Mailgun
  - [x] ```make imessage``` --- Send __iMessages__ to tester's iPhone
  - [ ] ```make gmail```
- [x] Send IPA to various SaaS or serve it by yourself
  - [x] ```make serve``` and ```make stop_serve``` --- Local OTA server with __Bonjour__ (Compatible for iOS 7.1 with HTTPS)
  - [x] ```make upload``` --- Upload to SFTP via rsync
  - [x] ```make testflight``` --- Upload IPA (and dSYM) to [TestFlightApp](https://testflightapp.com/)
  - [x] ```make hockeyapp``` --- Upload IPA (and dSYM) to [HockeyApp](https://hockeyapp.net/)
  - [ ] ```make fir``` --- Upload IPA to [fir.im](http://fir.im/)
  - [ ] ```make dropbox```
  - [ ] ```make cloudflare```
  - [ ] ```make heroku```

## Install

Download the __makefile__ and the config file __makefile.cfg__ into your project home folder:
```
curl -OL http://git.io/makefile
ls makefile.cfg 2>/dev/null >/dev/null||curl -OL http://git.io/makefile.cfg
```

Install [libqrencode](http://fukuchi.org/works/qrencode/) if you need the QRCode badge -- ```brew install qrencode```.

## How to use?

* Modify makefile.cfg to match your workspace/project settings.
* ```make``` to build & package your IPA.
* ```make upload``` to upload the package to your SFTP server.
* or ```make serve``` to serve the IPA in your local network.
* ```make send_email``` will notify your QA team via Mailgun maillist.
* But I prefer spamming my buddies with iMessage ```make imessage```.

## Contact
[@lexrus on Twitter](https://twitter.com/lexrus)

## License
This code is distributed under the terms and conditions of the MIT license.
