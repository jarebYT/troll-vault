Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Speech

# === Configuration ===
$msgs = @(
    "Oops… tu as laissé ton PC sans verrou ! 😏",
    "Ton PC est officiellement trollé !",
    "Appuie sur Échap si tu oses… 😎",
    "Sécurité 101 : CTRL+L la prochaine fois !"
)
$ttsLines = @(
    "Tu es victime du troll ultime !",
    "Verrouille ton PC la prochaine fois !",
    "Haha, ton poste est sous contrôle… enfin presque !",
    "Appuie sur Échap pour te libérer !"
)
$loopCount = 30  # nombre de répétitions

$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer

# === Fonctions ===
function Set-FunnyWallpaper($path) {
    Add-Type @"
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
    [Wallpaper]::SystemParametersInfo(20, 0, $path, 3)
}

function Show-BlackScreen($duration) {
    $form = New-Object System.Windows.Forms.Form
    $form.WindowState = "Maximized"
    $form.BackColor = "Black"
    $form.TopMost = $true
    $form.Add_KeyDown({ if ($_.KeyCode -eq "Escape") { $form.Close() } })
    $form.Show()
    Start-Sleep -Seconds $duration
    $form.Close()
}

function Show-FakeResScreen($color, $duration) {
    $form = New-Object System.Windows.Forms.Form
    $form.WindowState = "Maximized"
    $form.BackColor = $color
    $form.TopMost = $true
    $form.Add_KeyDown({ if ($_.KeyCode -eq "Escape") { $form.Close() } })
    $form.Show()
    Start-Sleep -Seconds $duration
    $form.Close()
}

# === Boucle principale ===
for ($i=0; $i -lt $loopCount; $i++) {

    # Afficher un message aléatoire
    $msg = Get-Random -InputObject $msgs
    Start-Job -ScriptBlock { param($m) [System.Windows.Forms.MessageBox]::Show($m,"Troll IT",0) } -ArgumentList $msg

    # TTS aléatoire
    $line = Get-Random -InputObject $ttsLines
    Start-Job -ScriptBlock { param($l) 
        Add-Type -AssemblyName System.Speech
        $s = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $s.Speak($l)
    } -ArgumentList $line

    # Écran noir toutes les 10 sec
    if ($i % 2 -eq 0) { Show-BlackScreen 3 }

    # Simuler résolution (fenêtre colorée) toutes les 5 sec
    $colors = @("DarkBlue","DarkRed","DarkGreen","DarkOrange")
    $color = Get-Random -InputObject $colors
    Show-FakeResScreen $color 2

    Start-Sleep -Seconds 5
}

# Message final
[System.Windows.Forms.MessageBox]::Show("Le troll ultime est terminé 😜 Appuie sur Échap pour fermer toutes les fenêtres restantes","Troll IT",0)
