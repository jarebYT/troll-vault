Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Speech

# ================= CONFIG =================
$msgs = @(
    "Oops… tu as laissé ton PC sans verrou 😏",
    "Ton PC est officiellement trollé !",
    "Sécurité 101 : Windows + L la prochaine fois 😎",
    "Appuie sur Échap si tu oses…"
)

$ttsLines = @(
    "Tu es victime du troll ultime",
    "Verrouille ton PC la prochaine fois",
    "Haha, ton poste est sous contrôle",
    "Appuie sur Échap pour te libérer"
)

$loopCount = 30
$colors = @(
    [System.Drawing.Color]::DarkRed,
    [System.Drawing.Color]::DarkBlue,
    [System.Drawing.Color]::DarkGreen,
    [System.Drawing.Color]::DarkOrange
)

$speaker = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speaker.Rate = 0

# ================= FENÊTRE PLEIN ÉCRAN =================
$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::Black
$form.KeyPreview = $true

$form.Add_KeyDown({
    if ($_.KeyCode -eq 'Escape') {
        $speaker.SpeakAsyncCancelAll()
        $form.Close()
    }
})

# ================= TIMER =================
$index = 0
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000  # 1 seconde

$timer.Add_Tick({

    if ($index -ge $loopCount) {
        $timer.Stop()
        [System.Windows.Forms.MessageBox]::Show(
            "Le troll ultime est terminé 😜",
            "Troll IT",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        $form.Close()
        return
    }

    # Changement couleur (RGB instantané)
    $form.BackColor = Get-Random $colors

    # Message popup (1 fois sur 3)
    if ($index % 3 -eq 0) {
        $msg = Get-Random $msgs
        [System.Windows.Forms.MessageBox]::Show($msg, "Troll IT")
    }

    # TTS (asynchrone, fluide)
    if ($index % 2 -eq 0) {
        $line = Get-Random $ttsLines
        $speaker.SpeakAsync($line)
    }

    $index++
})

# ================= LANCEMENT =================
$timer.Start()
[System.Windows.Forms.Application]::Run($form)
