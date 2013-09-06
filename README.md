# iOS Makefile
The universal makefile for my iOS projects distributes IPAs in seconds. (a.k.a. OTA makefile)

## Features
* Git log as release notes
* Shorten URL with my open source shortener: http://lexr.us <del>or goo.gl</del>
* QRCode of URL.
* Upload to SFTP via rsync -- ```make upload```
* Send emails with Mailgun -- ```make send_email```
* Local OTA server with __Bonjour__ -- ```make serve``` and ```make stop_serve```
* Send __iMessages__ to tester's iPhone -- ```make imessage```
* Show build settings -- ```make show_settings PRODUCT_SETTINGS_PATH``` or ```make show_settings | grep FLAG.*```
* Sort Xcode project.pbxproj with [sort-Xcode-project-file](http://danieltull.co.uk/blog/2013/09/05/easier-merging-of-xcode-project-files/) ```make sort```

## Screenshots
![screen shot 2013-07-03 at 10 59 13 pm](https://f.cloud.github.com/assets/219689/744065/8faf92da-e3f4-11e2-9b97-889543a27fd4.png)

![photo jul 03 10 56 46 pm](https://f.cloud.github.com/assets/219689/744074/af12b422-e3f4-11e2-9ffe-2687d2790b3b.png)

![screen shot 2013-07-03 at 10 54 24 pm](https://f.cloud.github.com/assets/219689/744070/a4b57866-e3f4-11e2-96f8-624b1c0c71da.png)

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
