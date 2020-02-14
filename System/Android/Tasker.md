# Android App: Tasker

## Open Spotify Playlist

*Note: Maybe deprecated.*

Get Playlist id: https://open.spotify.com/

System > Send Intent

* Action: android.media.action.MEDIA_PLAY_FROM_SEARCH
* Data: spotify:user:cyb10101:playlist:3zc5mXX5JMpcFFqOaKvHol
* Target: Activity

## Play Spotify

*Note: Maybe deprecated.*

* Click the “+” icon at the bottom.
* Select the “System” category.
* Select “Send Intent”

Set these fields:

* Action: com.spotify.mobile.android.ui.widget.PLAY
* Cat: None
* Package: com.spotify.music
* Target: Broadcast Reciever
