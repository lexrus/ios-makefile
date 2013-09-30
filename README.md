# iOS Makefile
The universal makefile for my iOS projects distributes IPAs in seconds. (a.k.a. OTA makefile)

## Features
* Git log as release notes
* Shorten URL with my open source shortener: http://lexr.us <del>or goo.gl</del>
* QRCode of URL.
* ```make upload``` --- Upload to SFTP via rsync
* ```make send_email``` --- Send emails with Mailgun
* ```make serve``` and ```make stop_serve``` --- Local OTA server with __Bonjour__
* ```make imessage``` --- Send __iMessages__ to tester's iPhone
* ```make show_settings PRODUCT_SETTINGS_PATH``` or ```make show_settings | grep FLAG.*``` --- Show build settings
* ```make sort``` --- Sort Xcode project.pbxproj with [sort-Xcode-project-file](http://danieltull.co.uk/blog/2013/09/05/easier-merging-of-xcode-project-files/)

## Screenshots
![CLI](https://f.cloud.github.com/assets/219689/744065/8faf92da-e3f4-11e2-9b97-889543a27fd4.png)

![iMessage](https://f.cloud.github.com/assets/219689/744074/af12b422-e3f4-11e2-9ffe-2687d2790b3b.png)

![Web](https://f.cloud.github.com/assets/219689/1234889/2e66cd68-2990-11e3-9eff-5fca4a392ddb.png)

## Install

Download the __makefile__ and the config file __makefile.cfg__ into your project home folder:
```
curl -OL http://git.io/makefile
ls makefile.cfg 2>/dev/null >/dev/null||curl -OL http://git.io/makefile.cfg
```

Install [libqrencode](http://fukuchi.org/works/qrencode/) if you need the QRCode badge -- ```brew install qrencode```.

## How to use?

* Modify makefile.cfg to match your workspace settings.
* Make sure your build path is __relative to workspace__.
* ```make``` to build & package your IPA.
* ```make upload``` to upload the package to your SFTP server.
* or ```make serve``` to serve the IPA in your local network.
* ```make send_email``` will notify your QA team via Mailgun maillist.
* But I prefer spamming my buddies with iMessage ```make imessage```.

## Credits
iOS Makefile was created by [Lex Tang](http://lextang.com/)

## Contact
Follow [@lexrus on Twitter](https://twitter.com/lexrus)

## License
This code is distributed under the terms and conditions of the MIT license.
