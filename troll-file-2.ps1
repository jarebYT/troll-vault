Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Speech

# ================= API ROTATION =================
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Display {
    [StructLayout(LayoutKind.Sequential)]
    public struct DEVMODE {
        private const int CCHDEVICENAME = 32;
        private const int CCHFORMNAME = 32;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHDEVICENAME)]
        public string dmDeviceName;
        public short dmSpecVersion;
        public short dmDriverVersion;
        public short dmSize;
        public short dmDriverExtra;
        public int dmFields;

        public int dmPositionX;
        public int dmPositionY;
        public int dmDisplayOrientation;
        public int dmDisplayFixedOutput;

        public short dmColor;
        public short dmDuplex;
        public short dmYResolution;
        public short dmTTOption;
        public short dmCollate;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = CCHFORMNAME)]
        public string dmFormName;
        public short dmLogPixels;
        public int dmBitsPerPel;
        public int dmPelsWidth;
        public int dmPelsHeight;
        public int dmDisplayFlags;
        public int dmDisplayFrequency;
    }

    [DllImport("user32.dll")]
    public static extern int ChangeDisplaySettings(ref DEVMODE devMode, int flags);

    public const int DM_DISPLAYORIENTATION = 0x80;
    public const int CDS_UPDATEREGISTRY = 0x01;
    public const int CDS_RESET = 0x40000000;
}
"@

function Rotate-Screen($orientation) {
    $devmode = New-Object Display+DEVMODE
    $devmode.dmSize = [System.Runtime.InteropServices.Marshal]::SizeOf($devmode)
    $devmode.dmFields = [Display]::DM_DISPLAYORIENTATION
    $devmode.dmDisplayOrientation = $orientation
    [Display]::ChangeDisplaySettings([ref]$devmode, 0) | Out-Null
}

# ================= CONFIG =================
$msgs = @(
    "La prochaine fois, tu apprendras a verrouiller ton pc :)",
    "Bite Bite Bite Bite Bite Bite Bite Bite",
    "Pense au Windows + L la prochaine fois ;)",
    "Gros neuille va"
)

$ttsLines = @(
    "Gros caca prout qui pue",
    "Verrouille ton PC la prochaine fois",
    "Tu aimes bien le stroboscope ?",
    "Et ça fait bim bam boum"
)

$colors = @(
    [System.Drawing.Color]::DarkRed,
    [System.Drawing.Color]::DarkBlue,
    [System.Drawing.Color]::DarkGreen,
    [System.Drawing.Color]::DarkOrange
)

$rotations = @(0, 1, 2, 3) # 0°, 90°, 180°, 270°
$rotationIndex = 0

$speaker = New-Object System.Speech.Synthesis.SpeechSynthesizer

# ================= FENÊTRE PIÈGE =================
$form = New-Object System.Windows.Forms.Form
$form.FormBorderStyle = 'None'
$form.WindowState = 'Maximized'
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::Black
$form.ControlBox = $false
$form.ShowInTaskbar = $false
$form.KeyPreview = $true

$form.Add_FormClosing({ $_.Cancel = $true })

# ================= TIMER =================
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1200
$step = 0

$timer.Add_Tick({

    # RGB
    $form.BackColor = Get-Random $colors

    # Souris qui se téléporte
    $x = Get-Random -Minimum 0 -Maximum [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
    $y = Get-Random -Minimum 0 -Maximum [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height
    [System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($x, $y)

    # Rotation écran toutes les 3 itérations
    if ($step % 3 -eq 0) {
        Rotate-Screen $rotations[$rotationIndex]
        $rotationIndex = ($rotationIndex + 1) % $rotations.Count
    }

    # Message box
    if ($step % 4 -eq 0) {
        [System.Windows.Forms.MessageBox]::Show(
            (Get-Random $msgs),
            "Troll IT",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }

    # TTS
    if ($step % 2 -eq 0) {
        $speaker.SpeakAsync((Get-Random $ttsLines))
    }

    $step++
})

# ================= LANCEMENT =================
$timer.Start()
[System.Windows.Forms.Application]::Run($form)
