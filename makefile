# The MIT License (MIT)
# Copyright © 2013 Lex Tang, http://LexTang.com

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
ICON_NAME    = Icon@2x.png
BUILD_PATH   = $(shell pwd)/Build
PAYLOAD_PATH = $(BUILD_PATH)/Payload
UPLOAD_PATH  = $(BUILD_PATH)/Upload
INFO_FILE    = $(BUILD_PATH)/Products/$(CONFIG)-iphoneos/$(APP).app/Info.plist
PLIST_FILE   = $(UPLOAD_PATH)/$(APP).ipa.plist
IPA_FILE     = $(UPLOAD_PATH)/$(APP).ipa

# Abbreviated Git logs
GIT_LOG      = $(shell git log --no-merges --pretty=format:'<li>%s</li>' --abbrev-commit --date=relative -n 7)

PLIST_BUDDY  = /usr/libexec/PlistBuddy

INFO_CLR     = \033[01;33m
RESULT_CLR   = \033[01;32m
RESET_CLR    = \033[0m

SECOND_ARG   = "*"
ifneq (,$(filter-out $@,$(MAKECMDGOALS)))
SECOND_ARG = $(filter-out $@,$(MAKECMDGOALS))
endif


#define googl
#$(shell curl -s -d "{'longUrl':'$(BASE_URL)'}" -H 'Content-Type: application/json' https://www.googleapis.com/urlshortener/v1/url | grep -o 'http://goo.gl/[^\"]*')
#endef

define short_url
$(shell curl -s -X POST -d "text_mode=1&url=$(BASE_URL)" http://lexr.us/api/url)
endef

define qrencode
$(shell type -P qrencode &>/dev/null && qrencode "$(BASE_URL)" -s 6 -o - | base64 | sed 's/^\(.*\)/<p><img src="data:image\/png;base64,\1"><\/p>/g')
endef

define app_title
$(app_display_name) $(app_short_version)@$(app_build_version)
endef

define app_display_name
$(shell $(PLIST_BUDDY) -c 'Print :CFBundleDisplayName' '$(INFO_FILE)')
endef

define app_short_version
$(shell $(PLIST_BUDDY) -c 'Print :CFBundleShortVersionString' '$(INFO_FILE)')
endef

define app_build_version
$(shell $(PLIST_BUDDY) -c 'Print :CFBundleVersion' '$(INFO_FILE)')
endef

define html
'<!DOCTYPE html><html><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">\
<title>$(app_title)</title><style type="text/css">body{text-align:center;font-family:"Helvetica";font-size:13px;}ul{text-align:left;}\
.container{width:280px;margin:0 auto;}h1{margin:0;padding:0;font-size:14px;}.install_button{background-image:-webkit-linear-gradient(top,rgb(126,203,26),rgb(92,149,19));background-origin:padding-box;background-repeat:repeat;-webkit-box-shadow:rgba(0,0,0,0.36) 0px 1px 3px 0px;-webkit-font-smoothing:antialiased;-webkit-user-select:none;background-attachment:scroll;background-clip:border-box;background-color:rgba(0,0,0,0);border-color:#75bc18;border-bottom-left-radius:18px;border-bottom-right-radius:18px;border-bottom-style:none;border-bottom-width:0px;border-left-style:none;border-left-width:0px;border-right-style:none;border-right-width:0px;border-top-left-radius:18px;border-top-right-radius:18px;border-top-style:none;border-top-width:0px;box-shadow:rgba(0,0,0,0.359375) 0px 1px 3px 0px;cursor:pointer;display:inline-block;margin:10px 0;padding:1px;position:relative;-webkit-box-shadow:0 1px 3px rgba(0,0,0,0.36);line-height:50px;margin:.5em auto;}\
.install_button a{-webkit-box-shadow:rgba(255,255,255,0.25) 0px 1px 0px 0px inset;-webkit-font-smoothing:antialiased;-webkit-user-select:none;background-attachment:scroll;background-clip:border-box;background-color:rgba(0,0,0,0);background-image:-webkit-linear-gradient(top,rgb(195,250,123),rgb(134,216,27) 85%%,rgb(180,231,114));background-origin:padding-box;background-repeat:repeat;border-bottom-color:rgb(255,255,255);border-bottom-left-radius:17px;border-bottom-right-radius:17px;border-bottom-style:none;border-bottom-width:0px;border-left-color:rgb(255,255,255);border-left-style:none;border-left-width:0px;border-right-color:rgb(255,255,255);border-right-style:none;border-right-width:0px;border-top-color:rgb(255,255,255);border-top-left-radius:17px;border-top-right-radius:17px;border-top-style:none;border-top-width:0px;box-shadow:rgba(255,255,255,0.246094) 0px 1px 0px 0px inset;color:#fff;cursor:pointer;display:block;font-size:16px;font-weight:bold;height:36px;line-height:36px;margin:0;padding:0;text-decoration:none;text-shadow:rgba(0,0,0,0.527344) 0px 1px 1px;width:278px;}\
.icon{border-radius:10px;box-shadow:1px 2px 3px lightgray;width:57px;height:57px;}\
.release_notes{border:1px solid lightgray;padding:30px 10px 15px 30px;border-radius:8px;overflow:hidden;line-height:1.3em;box-shadow:1px 1px 3px lightgray;}\
.release_notes:before{font-size:10px;content:"Release Notes";background:lightgray;margin:-31px;float:left;padding:3px 8px;border-radius:4px 0 6px 0;color:white;}\
footer{font-size:x-small;font-weight:bolder;}</style></head><body><div class="container">\
<p><img class="icon" src="$(BASE_URL)/icon.png"/></p><h1>$(app_title)</h1>\
<div class="install_button"><a href="itms-services://?action=download-manifest&amp;url=$(BASE_URL)/$(APP).ipa.plist">INSTALL</a></div>\
<ul class="release_notes">$(GIT_LOG)</ul>\
<p><a href="$(short_url)">$(short_url)</a></p>\
$(qrencode)\
<footer>'`date`'</footer>\
<p><a href="https://github.com/lexrus/ios-makefile">https://github.com/lexrus/ios-makefile</a></p></div></body></html>'
endef

default: clean build package html

.PHONY: clean
clean:
	@echo "${INFO_CLR}>> Cleaning $(APP)...${RESTORE_CLR}${RESULT_CLR}"
	@xcodebuild -sdk iphoneos -workspace "$(WORKSPACE).xcworkspace" -scheme "$(SCHEME)" -configuration "$(CONFIG)" -jobs 2 clean | tail -n 2 | cat && printf "${RESET_CLR}" && rm -rf Build

build:
	@echo "${INFO_CLR}>> Building $(APP)...${RESTORE_CLR}${RESULT_CLR}"
	@xcodebuild -sdk iphoneos -workspace "$(WORKSPACE).xcworkspace" -scheme "$(SCHEME)" -configuration "$(CONFIG)" -jobs 6 build | tail -n 2 | cat && printf "${RESET_CLR}"

show_settings:
	@xcodebuild -sdk iphoneos -workspace "$(WORKSPACE).xcworkspace" -scheme "$(SCHEME)" -configuration "$(CONFIG)" -showBuildSettings 2>/dev/null | grep "$(SECOND_ARG)"

package:
	@echo "${INFO_CLR}>> PACKAGING $(APP)...${RESTORE_CLR}"
	@rm -rf "$(PAYLOAD_PATH)" "$(UPLOAD_PATH)"
	@mkdir -p "$(PAYLOAD_PATH)" "$(UPLOAD_PATH)"
	@cp "$(BUILD_PATH)/Products/$(CONFIG)-iphoneos/$(APP).app/$(ICON_NAME)" "$(UPLOAD_PATH)/icon.png"
	@cp -r "$(BUILD_PATH)/Products/$(CONFIG)-iphoneos/$(APP).app" "$(PAYLOAD_PATH)"
	@cd "$(BUILD_PATH)"; zip -rq "$(IPA_FILE)" "Payload" && rm -rf "$(PAYLOAD_PATH)"
	@echo "${RESULT_CLR}** PACKAGE SUCCEEDED **${RESET_CLR}\n"

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

serve:
	@echo "${RESULT_CLR}>> $(APP) Server $(BASE_URL) [STARTED]${RESET_CLR}"
	@twistd -o -l /tmp/twistd.log web --path=$(UPLOAD_PATH) --port=$(BASE_PORT)

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

sort:
	@ls .sort-Xcode-project-file 2>/dev/null >/dev/null||curl -L https://raw.github.com/WebKit/webkit/master/Tools/Scripts/sort-Xcode-project-file -o .sort-Xcode-project-file
	@perl .sort-Xcode-project-file "$(APP).xcodeproj/project.pbxproj" && echo "${RESULT_CLR}** $(APP).xcodeproj/project.pbxproj was sorted **${RESET_CLR}"

%:
	@echo 1>/dev/null

@:
	@echo 1>/dev/null
