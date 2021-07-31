# https://www.shrew.net/download
# https://avm.de/service/vpn/tipps-tricks/vpn-verbindung-zur-fritzbox-mit-shrew-soft-vpn-client-einrichten/

# FRITZ!Box Router > Internet > Freigaben > VPN > VPN-Einstellungen
# FRITZ!Box Router > System > FRITZ!Box-Benutzer > Benutzer

# Shrew: VPN Access Manager > Add (IPSec / IPSec Xauth PSK)
# General > Remote Host > Host Name or IP Address = pi80ewgfi72d2os42.myfritz.net (Serveradresse / Server)
# Authentication > Authentication Method = Mutual PSK +XAuth
# Authentication > Local Identity > Identification Type = Key Identifier
# Authentication > Local Identity > Key ID String = Cyb10101 (IPSec-ID / Group name / Maybe FRITZ!Box Username)
# Authentication > Remote Identity > Identification Type = Any (Should be IP Address?!)
# Authentication > Credentials > Pre Shared Key = Zj7hPCouK65IrPU4 (IPSec-Schlüssel / Shared Secret)

# %LOCALAPPDATA%\Shrew Soft VPN\sites

$pathShrew = "C:\Program Files\ShrewSoft\VPN Client"
function connectIpSec([string]$siteProfile, [string]$username, [string]$password, [switch]$connect) {
  if ($connect) {
    & "$pathShrew\ipsecc.exe" -r $siteProfile -u $username -p $password -a
  } else {
    & "$pathShrew\ipsecc.exe" -r $siteProfile -u $username -p $password
  }
}

# connectIpSec -siteProfile 'VPN Profile Name' -username 'FRITZ!Box-Username' -password 'FRITZ!Box-Password' -connect
# connectIpSec -siteProfile 'VPN Profile Name' -username 'FRITZ!Box-Username' -password 'FRITZ!Box-Password'
