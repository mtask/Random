##Run applications from shell

Via adb just put "$adb shell" in front of the given command.

- Check if phone service is up

$ service check phone

- Make call using activity manager

$ am start -a android.intent.action.CALL -d tel:123456789

- Accept incomming call

$ input keyevent 5

- Disconnect call

$ input keyevent 6 

- Open google.com in default browser

$ am start -a "android.intent.action.VIEW" -d "google.com"

- Open with specific browser(Firefox in example)

$ am start -a android.intent.action.VIEW -n org.mozilla.firefox/.App -d google.com

- Send plaintext message to application

$ am start -a "android.intent.action.SEND" --es "android.intent.extra.TEXT" "This is message" -t "text/plain"

- Open camera/videocamera

$ am start -a android.media.action.IMAGE_CAPTURE

$ am start -a android.media.action.VIDEO_CAPTURE"

- Focus camera

$ input keyevent KEYCODE_FOCUS

- Take pic/start video capturing.

$ input keyevent KEYCODE_CAMERA
