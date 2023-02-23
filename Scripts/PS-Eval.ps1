﻿# .Net methods for hiding/showing the console in the background
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0) | Out-Null
} 
Hide-Console

#####################  POPUP  #####################

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Récupération des AutoEvaluations'
$form.Size = New-Object System.Drawing.Size(300,300)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.Topmost = $false

# Create auto-evals button
$createEvalsButton = New-Object System.Windows.Forms.Button
$createEvalsButton.Size = New-Object System.Drawing.Size(($form.Size.Width - 50),30)
$createEvalsButton.Left = ($form.ClientSize.Width - $createEvalsButton.Width) / 2 ;
$createEvalsButton.Top = 15 
$createEvalsButton.Text = 'Créer les auto-évaluations'
$form.Controls.Add($createEvalsButton)

# Get auto-evals button
$getEvalsButton = New-Object System.Windows.Forms.Button
$getEvalsButton.Size = New-Object System.Drawing.Size(($form.Size.Width - 50),30)
$getEvalsButton.Left = ($form.ClientSize.Width - $getEvalsButton.Width) / 2 ;
$getEvalsButton.Top = $createEvalsButton.Bottom + 15 
$getEvalsButton.Text = 'Rappatrier les auto-évaluations'
$form.Controls.Add($getEvalsButton)

# Config path

$configPathInput = New-Object System.Windows.Forms.TextBox
$configPathInput.Size = New-Object System.Drawing.Size(($form.Size.Width - 50),30)
$configPathInput.Left = ($form.ClientSize.Width - $configPathInput.Width) / 2 ;
$configPathInput.Top = $getEvalsButton.Bottom + 15 
$configPathInput.Text = "$($PSScriptRoot)\DataFiles\01-configs-auto-eval.xlsx"
$form.Controls.Add($configPathInput)

# Model Path
$modelPathInput = New-Object System.Windows.Forms.TextBox
$modelPathInput.Size = New-Object System.Drawing.Size(($form.Size.Width - 50),30)
$modelPathInput.Left = ($form.ClientSize.Width - $modelPathInput.Width) / 2 ;
$modelPathInput.Top = $configPathInput.Bottom + 15 
$modelPathInput.Text = "$($PSScriptRoot)\DataFiles\02-modele-auto-eval.xlsx"
$form.Controls.Add($modelPathInput)

# Synthesis Path
$synthesisPathInput = New-Object System.Windows.Forms.TextBox
$synthesisPathInput.Size = New-Object System.Drawing.Size(($form.Size.Width - 50),30)
$synthesisPathInput.Left = ($form.ClientSize.Width - $synthesisPathInput.Width) / 2 ;
$synthesisPathInput.Top = $modelPathInput.Bottom + 15 
$synthesisPathInput.Text = "$($PSScriptRoot)\DataFiles\03-synthese-auto-eval.xlsm",
$form.Controls.Add($synthesisPathInput)


# Create auto-evals Button event
$createEvalsButton.Add_Click(
    {    
        # Lock the form and buttons
        $form.Enabled = $false

        try{
            # Start the creation
            .\Create-AutoEvals.ps1 -ConfigsPath $configPathInput.Text -ModelPath $modelPathInput.Text

            [System.Windows.Forms.MessageBox]::Show("Tout bon" , "My Dialog Box")
        }
        catch{
            #Display the error message
            [System.Windows.Forms.MessageBox]::Show($_ , "My Dialog Box")
        }
        
        # Unlock the form and buttons
        $form.Enabled = $true
    }
);

# Get auto-evals Button event
$getEvalsButton.Add_Click(
    {    
        # Lock the form and buttons
        $form.Enabled = $false

        try{
            # Start the creation
            .\Get-AutoEvals.ps1 -ConfigsPath $configPathInput.Text -SynthesisModelPath $synthesisPathInput.Text -FilesPath "$($PSScriptRoot)\Output"

            [System.Windows.Forms.MessageBox]::Show("Tout bon" , "My Dialog Box")
        }
        catch{
            #Display the error message
            [System.Windows.Forms.MessageBox]::Show($_ , "My Dialog Box")
        }
        
        # Unlock the form and buttons
        $form.Enabled = $true
    }
);


$result = $form.ShowDialog()
$result