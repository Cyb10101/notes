# iPhone

## Transfer files via Samba

Simply you create a windows share (Samba).
*Based on [youtube.com/watch?v=4QkmEVkMHKc](https://youtube.com/watch?v=4QkmEVkMHKc).*

Run Command as Administrator:

```shell
# Create a user (just for security)
net user "ios-transfer" "password" /add

# Get your ip address
ipconfig | find "IPv4"

# Optional information
# net user "ios-transfer" "change-password"
# net user "ios-transfer" /delete
```

Create a folder on your PC:

* Create a folder "IOS-Transfer" on Desktop or elsewere
* Right click > Properties > Tab "Sharing"
  * Field "Network file and Folder Sharing" > Button "Share"
    * Select User "ios-transfer"
    * Allow User: Read/Write
    * Click on "Share" and "Done"
  * Field "Advanced Sharing" > Button "Advanced Sharing"
    * Share this folder = yes
    * Permissions
      * Add User "ios-transfer" > Check Name
      * Permissions = Allow "Full Control"

Get your iPhone:

* Open "Files" > Click on three dots > Connect to Server
  * Server: 192.168.178.21 (Alternatively: smb://192.168.178.21)
  * Click on "Connect"
  * Click on "Registered User", enter your username "ios-transfer" and your password
  * Click on "Next"

* Open "Album"
  * Share > Save to files
  * Select Server and folder "IOS-Transfer"
