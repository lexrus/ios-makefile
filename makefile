# iOS Makefile by Lex Tang
# https://github.com/lexrus/ios-makefile

# You can update this file with the following command:
# curl -OL http://git.io/makefile


# The MIT License (MIT)
# Copyright © 2014 Lex Tang, http://LexTang.com

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

include $(CURDIR)/makefile.cfg

IPA_URL      = $(BASE_URL)/$(APP).ipa
BUILD_PATH   = $(shell pwd)/Build
PAYLOAD_PATH = $(BUILD_PATH)/Payload
UPLOAD_PATH  = $(BUILD_PATH)/Upload
PLIST_SRC    = $(shell find . -name '*-Info.plist' -type f | head -n 1 )
PLIST_FILE   = $(UPLOAD_PATH)/$(APP).ipa.plist
IPA_FILE     = $(UPLOAD_PATH)/$(APP).ipa
BUILD_LOG   ?= OFF
ICON_PATH    = $(shell find . -name AppIcon.appiconset -type d )
ICON_FILE    = $(shell find `find . -name AppIcon.appiconset -type d` -name Contents.json -type f | xargs grep -o 'Icon-60@2x.png')
LEXR_US     ?= YES
DOMAIN       = $(subst http://,,$(subst :$(BASE_PORT),,$(subst https://,,$(BASE_URL))))
CERT_URL     = http://$(DOMAIN)

ifdef WORKSPACE
INFO_FILE    = $(BUILD_PATH)/Products/$(CONFIG)-iphoneos/$(APP).app/Info.plist
else
INFO_FILE    = $(BUILD_PATH)/Products/$(APP).app/Info.plist
endif

# Abbreviated Git logs
GIT_LOG      = $(shell git log --no-merges --pretty=format:"\r✓ %s" --abbrev-commit --date=relative -n 10 | /usr/bin/php -r 'echo htmlentities(fread( STDIN, 2048 ), ENT_QUOTES, "UTF-8");')

COMMIT       = $(shell git rev-parse --short HEAD)
BRANCH       = $(shell git rev-parse --abbrev-ref HEAD)
version      = `/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${INFOPLIST_FILE}"`
PLIST_BUDDY  = /usr/libexec/PlistBuddy

INFO_CLR     = \033[01;33m
RESULT_CLR   = \033[01;32m
RESET_CLR    = \033[0m

SECOND_ARG   = "*"
ifneq (,$(filter-out $@,$(MAKECMDGOALS)))
SECOND_ARG = $(filter-out $@,$(MAKECMDGOALS))
endif

define googl
$(shell curl -s -d "{'longUrl':'$(BASE_URL)'}" -H 'Content-Type: application/json' https://www.googleapis.com/urlshortener/v1/url | grep -o 'http://goo.gl/[^\"]*')
endef

define lexr_us
$(shell curl -s -X POST -d "text_mode=1&url=$(BASE_URL)" http://lexr.us/api/url)
endef

ifneq (,$(findstring YES,$(LEXR_US)))
define short_url
$(call lexr_us)
endef
else
define short_url
$(call googl)
endef
endif

ifdef WORKSPACE
define IPA_BUILD_FOLDER
$(BUILD_PATH)/Products/$(CONFIG)-iphoneos/$(APP).app
endef
else
define IPA_BUILD_FOLDER
$(BUILD_PATH)/Products/$(APP).app
endef
endif

define qrencode
$(shell type -P qrencode &>/dev/null && qrencode "$(BASE_URL)" -m 0 -s 10 -l H --foreground=0000ee -o - | base64 | sed 's/^\(.*\)/data:image\/png;base64,\1/g')
endef

define app_title
$(app_display_name) $(app_short_version)@$(app_build_version)
endef

define app_display_name
$(shell $(PLIST_BUDDY) -c 'Print :CFBundleDisplayName' '$(INFO_FILE)')
endef

define app_short_version
$(shell $(PLIST_BUDDY) -c 'Print :CFBundleShortVersionString' '$(PLIST_SRC)')
endef

define app_build_version
$(shell $(PLIST_BUDDY) -c 'Print :CFBundleVersion' '$(INFO_FILE)')
endef

define html
'<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">\
<title>$(app_title)</title><style type="text/css">\
body{text-align:center;font-family:"Helvetica","Hei";font-weight:lighter;color:#333;font-size:85%}\
h1{font-weight:lighter;font-size:1.2em;margin:0;padding:0}a{color:#00f;text-decoration:none}\
.container{width:260px;margin:0 auto}\
.install_button{display:block;font-size:1.5em;line-height:44px;margin:.5em auto;background:#eee}\
.icon_container{width:260px;height:260px}\
.icon_container .qrcode_img{width:260px;height:260px}\
.icon_container .icon{position:absolute;border-radius:14px;width:57px;height:57px;margin:101px auto 0 101px;shadow:0 3px 3px #fff}\
.release_notes{font-family:"Helvetica","Hei";font-weight:lighter;font-size:.9em;border:1px solid #eee;padding:30px 10px 15px 10px;border-radius:3px;overflow:hidden;text-align:left;line-height:1.3em}\
.release_notes:before{font-size:.8em;content:"Release Notes";background:#eee;margin:-31px -12px;float:left;padding:3px 8px;border-radius:3px 0 3px 0}.qrcode{width:180px}footer{font-size:.8em}\
@media print{body{font-size:95%;padding:5em}a{color:#000}.qrcode_img{filter:url(filters.svg#grayscale);filter:gray;-webkit-filter:grayscale(1)}.install_button{display:none}}\
</style></head><body><div class="container">\
<h1>$(app_title)</h1>\
<small>Built on '`date "+%Y-%m-%d %H:%M:%S"`'</small>\
<p class="icon_container"><img class="icon" src="$(BASE_URL)/icon.png" onerror="this.style.display=&#39;none&#39;"/><img class="qrcode_img" src="$(qrencode)"/></p>\
<a id="cert_button" class="install_button" href="$(BASE_URL)/app.cer">INSTALL Certificate</a>\
<a id="install_button" class="install_button" href="itms-services://?action=download-manifest&amp;url=$(BASE_URL)/$(APP).ipa.plist">INSTALL $(APP)</a>\
<p><a href="$(short_url)">$(short_url)</a></p>\
<pre class="release_notes">$(GIT_LOG)<br/>    ......</pre>\
<footer>&copy; <a href="https://github.com/lexrus/ios-makefile">iOS-Makefile</a> by <a href="http://lextang.com/">Lex Tang</a></footer></div></body><script>if(!navigator.userAgent.match(/ like Mac OS X/))document.getElementById("install_button").style.display="none";if(!navigator.userAgent.match(/ OS 7_1/g))document.getElementById("cert_button").style.display="none"</script></html>'
endef

define cert_conf
[ req ]
prompt = no
encrypt_key = no
distinguished_name = req_distinguished_name
[ req_distinguished_name ]
countryName = 'CN'
stateOrProvinceName = 'Shanghai'
localityName = 'Shanghai'
postalCode = '200002'
streetAddress = 'East NANJING Rd.'
organizationName = 'LexTang.com'
organizationalUnitName = 'ios-makefile'
commonName = '$(DOMAIN)'
emailAddress = 'ios-makefile@nsnotfound.com'
endef

define icon_version_php
<?php
$$ver_txt = $$_ENV['ver'] ?: "$(app_short_version) $(BRANCH)";
$$cmt_txt = $$_ENV['cmt'] ?: "@$(COMMIT)";
$$icn = $$_ENV['icn'] ?: "$(ICON_PATH)/$(ICON_FILE)";
$$fnt = $$_ENV['fnt'] ?: '/Library/Fonts/Verdana Bold.ttf';
$$fnt_size = $$_ENV['fnt_size'] ?: 12;
$$out = $$_ENV['o'] ?: "$(ICON_PATH)/$(ICON_FILE)";

$$img = imagecreatefrompng($$icn);
if (!$$img) die();
imageantialias($$img, false);
$$img_width = imagesx($$img);
$$img_height = imagesy($$img);
$$txt_padding = $$fnt_size / 3;

$$tag_height = $$fnt_size * 3;
$$tag_bg = imagecolorallocatealpha($$img, 0, 0, 0, 64);
imagefilledrectangle($$img, 0, $$img_height - $$tag_height, $$img_width, $$img_height, $$tag_bg);

$$tag_fg = imagecolorallocate($$img, 255, 255, 255);
$$tag_shadow = imagecolorallocate($$img, 0, 0, 0);

$$ver_txt_bounds = imagettfbbox($$fnt_size, 0, $$fnt, $$ver_txt);
$$ver_txt_width = $$ver_txt_bounds[2];
$$ver_txt_height = $$ver_txt_bounds[3] - $$ver_txt_bounds[5];

$$cmt_txt_bounds = imagettfbbox($$fnt_size, 0, $$fnt, $$cmt_txt);
$$cmt_txt_width = $$cmt_txt_bounds[2];
$$cmt_txt_height = $$cmt_txt_bounds[3] - $$cmt_txt_bounds[5];

$$txt_margin = ($$tag_height - $$ver_txt_height - $$cmt_txt_height) / 2;

$$ver_txt_y = $$img_height - $$tag_height + $$txt_margin + $$ver_txt_height;
$$cmt_txt_y = $$ver_txt_y + $$cmt_txt_height;

imagettftext($$img, $$fnt_size, 0, ($$img_width - $$ver_txt_width) / 2, $$ver_txt_y + 1, $$tag_shadow, $$fnt, $$ver_txt);
imagettftext($$img, $$fnt_size, 0, ($$img_width - $$ver_txt_width) / 2, $$ver_txt_y, $$tag_fg, $$fnt, $$ver_txt);
imagettftext($$img, $$fnt_size, 0, ($$img_width - $$cmt_txt_width) / 2, $$cmt_txt_y + 1, $$tag_shadow, $$fnt, $$cmt_txt);
imagettftext($$img, $$fnt_size, 0, ($$img_width - $$cmt_txt_width) / 2, $$cmt_txt_y, $$tag_fg, $$fnt, $$cmt_txt);

imagepng($$img, $$out);
imagedestroy($$img);
?>
endef

default: clean icon_backup icon_version build_app package icon_restore html

.PHONY: clean
clean:
	@echo "${INFO_CLR}>> Cleaning $(APP)...${RESTORE_CLR}${RESULT_CLR}"
ifdef WORKSPACE
	@xcodebuild -sdk iphoneos -workspace "$(WORKSPACE).xcworkspace" -scheme "$(SCHEME)" -configuration "$(CONFIG)" -jobs 2 clean 2>/dev/null | tail -n 2 | cat && printf "${RESET_CLR}" && rm -rf "$(BUILD_PATH)"
else
	@xcodebuild -sdk iphoneos -project "$(PROJECT).xcodeproj" -scheme "$(SCHEME)" -configuration "$(CONFIG)" -jobs 2 clean 2>/dev/null | tail -n 2 | cat && printf "${RESET_CLR}" && rm -rf "$(BUILD_PATH)"
endif
	
build_app:
	@echo "${INFO_CLR}>> Building $(APP)...${RESTORE_CLR}${RESULT_CLR}"
ifdef WORKSPACE
	@xcodebuild -sdk iphoneos -workspace "$(WORKSPACE).xcworkspace" -scheme "$(SCHEME)" -configuration "$(CONFIG)" SYMROOT="$(BUILD_PATH)/Products" -jobs 6 build 2>/dev/null | tail -n 2 | cat && printf "${RESET_CLR}"
else
	@xcodebuild -sdk iphoneos -project "$(PROJECT).xcodeproj" -scheme "$(SCHEME)" -configuration "$(CONFIG)" CONFIGURATION_BUILD_DIR="$(BUILD_PATH)/Products" -jobs 6 build 2>/dev/null | tail -n 2 | cat && printf "${RESET_CLR}"
endif

show_settings:
ifdef WORKSPACE
	@xcodebuild -sdk iphoneos -workspace "$(WORKSPACE).xcworkspace" -scheme "$(SCHEME)" -configuration "$(CONFIG)" -showBuildSettings 2>/dev/null | grep "$(SECOND_ARG)"
else
	@xcodebuild -sdk iphoneos -project "$(WORKSPACE).xcodeproj" -scheme "$(SCHEME)" -configuration "$(CONFIG)" -showBuildSettings 2>/dev/null | grep "$(SECOND_ARG)"
endif

package:
	@echo "${INFO_CLR}>> PACKAGING $(APP)...${RESTORE_CLR}"
	@rm -rf "$(PAYLOAD_PATH)" "$(UPLOAD_PATH)"
	@mkdir -p "$(PAYLOAD_PATH)" "$(UPLOAD_PATH)"
	-@[ -e "$(ICON_PATH)/$(ICON_FILE)" ] && cp "$(ICON_PATH)/$(ICON_FILE)" "$(UPLOAD_PATH)/icon.png" 2>/dev/null
	@cp -r "$(IPA_BUILD_FOLDER)" "$(PAYLOAD_PATH)"
	@cd "$(BUILD_PATH)"; zip -rq "$(IPA_FILE)" "Payload" && rm -rf "$(PAYLOAD_PATH)"
	@echo "${RESULT_CLR}** PACKAGE SUCCEEDED **${RESET_CLR}\n"
	$(call icon_restore)

icon_backup:
	-@cp "$(ICON_PATH)/$(ICON_FILE)" "$(shell pwd)/_icon_backup.png"

export icon_version_php
icon_version:
	-@if [ "YES" = "$(ICON_TAG)" ]; then echo "$$icon_version_php" > /tmp/icon_version.php && /usr/bin/php /tmp/icon_version.php; fi

icon_restore:
	-@cp "$(shell pwd)/_icon_backup.png" "$(ICON_PATH)/$(ICON_FILE)" && rm -rf "$(shell pwd)/_icon_backup.png"

plist:
	@rm -rf $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items array" $(PLIST_FILE) $2>/dev/null
	@$(PLIST_BUDDY) -c "Add :items:0 dict" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets array" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:0 dict" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:0:url string \"$(IPA_URL)\"" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:0:kind string software-package" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:1 dict" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:1:kind string display-image" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:1:needs-shine bool NO" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:1:url string \"$(BASE_URL)/icon.png\"" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:2 dict" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:2:kind string full-size-image" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:2:needs-shine bool NO" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:assets:2:url string \"$(BASE_URL)/icon.png\"" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:metadata dict" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:metadata:title string \"$(app_title)\"" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:metadata:kind string software" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:metadata:bundle-version string \"$(app_build_version)\"" $(PLIST_FILE)
	@$(PLIST_BUDDY) -c "Add :items:0:metadata:bundle-identifier string \"`$(PLIST_BUDDY) -c 'Print :CFBundleIdentifier' '$(INFO_FILE)'`\"" $(PLIST_FILE)

html: plist
	@echo $(html) > "$(UPLOAD_PATH)/index.html"

upload:
	@echo "${INFO_CLR}>> UPLOADING $(APP)...${RESET_CLR}"
	@rsync --progress -azvhe "ssh -p ${SFTP_PORT}" "$(UPLOAD_PATH)/." "$(SFTP_SERVER):$(SFTP_PATH)"
	@echo "${RESULT_CLR}** UPLOAD SUCCEEDED **\n** $(BASE_URL) **${RESET_CLR}"

send_email:
	@echo "${INFO_CLR}>> SENDING EMAILS...${RESTORE_CLR}"
	@curl -s --user api:$(MAILGUN_API_KEY) \
		https://api.mailgun.net/v2/$(EMAIL_DOMAIN)/messages \
		-F from='$(APP) <postmaster@$(EMAIL_DOMAIN)>' \
		-F to=$(EMAIL_LIST)\
		-F subject="$(app_title) is ready" \
		-F text='$(app_title) $(BASE_URL)' \
		-F "html=<$(UPLOAD_PATH)/index.html"
	@echo "${RESULT_CLR}** EMAILS SENT **${RESET_CLR}"

export cert_conf
gen_cert:
	@echo "$$cert_conf" > /tmp/cert.conf
	-@if [ ! -f "$(BUILD_PATH)/app.pem" ]; then openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/CN=$(DOMAIN)" -config /tmp/cert.conf -keyout "$(BUILD_PATH)/app.key"  -out "$(UPLOAD_PATH)/app.cer" && cat "$(BUILD_PATH)/app.key" "$(UPLOAD_PATH)/app.cer" > "$(BUILD_PATH)/app.pem"; fi

serve: gen_cert
	@echo "${RESULT_CLR}>> $(APP) Server $(BASE_URL) [STARTED]${RESET_CLR}"
	@/usr/bin/twistd -o -l /tmp/twistd.log web --path=$(UPLOAD_PATH) --https=$(BASE_PORT) -c "$(BUILD_PATH)/app.pem" -k "$(BUILD_PATH)/app.key" -m "cer=application/x-x509-ca-cert"

stop_serve:
	@echo "${RESULT_CLR}>> $(APP) Server [STOPPED]${RESET_CLR}"
	@kill $(shell cat twistd.pid)

imessage:
	@for address in $(IMSG_LIST) ; do \
		echo "${INFO_CLR}>> SENDING IMESSAGE >${RESET_CLR} ${RESULT_CLR}$$address...${RESET_CLR}" ; \
		osascript -e "set toAddress to \"$${address}\"" \
		-e "tell application \"Messages\"" \
		-e "set theBuddy to buddy toAddress of (first service whose service type is iMessage)" \
		-e "send \"$(app_title) is ready itms-services://?action=download-manifest&url=$(BASE_URL)/$(APP).ipa.plist\" to theBuddy" \
		-e "end tell" ; \
	done

zip_dsym:
	@echo "${INFO_CLR}>> Compressing ${RESET_CLR}${RESULT_CLR}$(APP).app.dSYM.zip...${RESET_CLR}" ;
ifdef WORKSPACE
	@cd "$(BUILD_PATH)/Products/$(CONFIG)-iphoneos/"; zip -rq "$(BUILD_PATH)/$(APP).app.dSYM.zip" "$(APP).app.dSYM"
else
	@cd "$(BUILD_PATH)/Products/"; zip -rq "$(BUILD_PATH)/$(APP).app.dSYM.zip" "$(APP).app.dSYM"
endif

testflight: zip_dsym
	@echo "${INFO_CLR}>> Uploading ${RESET_CLR}${RESULT_CLR}$(APP).app.dSYM.zip...${RESET_CLR}" ;
	@curl http://testflightapp.com/api/builds.json \
		-F file=@"$(IPA_FILE)" \
		-F dsym=@"$(BUILD_PATH)/$(APP).app.dSYM.zip" \
		-F api_token="$(TESTFLIGHT_API_TOKEN)" \
		-F team_token="$(TESTFLIGHT_TEAM_TOKEN)" \
		-F notes="$(subst '\\r','%A0',$(GIT_LOG))" \
		-F notify=True \
		-o $(BUILD_PATH)/testflight_upload_result.log 2>&1
	@echo "${RESULT_CLR}** UPLOAD SUCCEEDED **\n>> INSTALL URL: "
	@cat $(BUILD_PATH)/testflight_upload_result.log \
		| grep -o 'https*://[^\"]*testflightapp.com/install/[^\"]*' \
		| cat && printf "${RESET_CLR}"

hockey: zip_dsym
	@echo "${INFO_CLR}>> Uploading ${RESET_CLR}${RESULT_CLR}$(APP).app.dSYM.zip...${RESET_CLR}" ;
	@curl https://rink.hockeyapp.net/api/2/apps/upload \
		-F "status=2" \
		-F notify=1 \
		-F notes="$(subst '\\r','%A0',$(GIT_LOG))" \
		-F notes_type=0 \
		-F ipa=@"$(IPA_FILE)" \
		-F dsym=@"$(BUILD_PATH)/$(APP).app.dSYM.zip" \
		-H X-HockeyAppToken: "$(HOCKEY_APP_API_TOKEN)" \
		-o $(BUILD_PATH)/hockey_upload_result.log 2>&1
	@echo "${RESULT_CLR}** UPLOAD SUCCEEDED **\n>> INSTALL URL: "
	@cat $(BUILD_PATH)/hockey_upload_result.log \
		| grep -o 'https*://[^\"]*.hockeyapp.net/apps/[^\"]*' \
		| cat && printf "${RESET_CLR}"

sort:
	@ls .sort-Xcode-project-file 2>/dev/null >/dev/null||curl -L https://raw.github.com/WebKit/webkit/master/Tools/Scripts/sort-Xcode-project-file -o .sort-Xcode-project-file
	@perl .sort-Xcode-project-file "$(APP).xcodeproj/project.pbxproj" && echo "${RESULT_CLR}** $(APP).xcodeproj/project.pbxproj was sorted **${RESET_CLR}"

%:
	@echo 1>/dev/null

@:
	@echo 1>/dev/null
