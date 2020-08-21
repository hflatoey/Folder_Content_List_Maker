####################################################################
# FOLDER CONTENT LIST MAKER
#                             
# Creator: X672 and Google Search                   
# Creation Date: 03.03.2016                              
# Last Modified: 13.04.2019                               
# Version: 5.2
#
# Description:
# Create a list of folders and files in up to five root folders with
# size and file count for each folder and check if new content have
# been added since last run of script. Output to .txt files with
# optional [BB] code for easy posting on forums.
#
####################################################################
# DISCLAIMER
#
# This script is provided "as is" and "with all faults".
# You are solely responsible for determining whether this script is
# compatible with your equipment and other software installed on your
# equipment. You are also solely responsible for the protection of
# your equipment and backup of your data, I will not be liable for
# any damages you may suffer in connection with using, modifying, or
# distributing this script.
#
####################################################################
# VERSIONS
#
# Version 5.2 -    FIX: Can sort on file extension again.
#
# Version 5.1 -    FIX: Can list folders and filenames with [ & ].
#
# Version 5.0 - CHANGE: Batch script removed, everything moved to
#                       one powershell script file (This file).
#
# Version 4.6 -    FIX: RootFolder and listname can now have spaces
#                       in path and name.
#               CHANGE: \ is no longer needed at end of rootfolder
#                       paths.
#               CHANGE: Powershell.exe removed from script folder.
#
# Version 4.5 -    NEW: Added filter for file extension.
#                  FIX: Filenames script will not scan each sub folder
#                       over and over again and over again...
#
# Version 4.4 -    FIX: Filenames script will now scan sub folders.
#               CHANGE: Filenames temp .txt files have fixed names so
#                       they can be deleted even if list name changes.
#
# Version 4.3 - CHANGE: Temp .txt files have fixed names so they
#                       can be deleted even if list name changes.
#               CHANGE: "Total space used:" text moved outside of
#                       [SPOILER] [BB] code. 
#
# Version 4.2 -    NEW: Can select up to five folders to scan.
#
# Version 4.1 -    NEW: Added all this text.
#                  FIX: Right align of "# File(s)" in output file.
#
# Version 4.0 -    NEW: Variable for folder width in output file.
#               CHANGE: Scanning folders and files is now done
#                       by powershell.exe, huge speed improvement.
#                  FIX: Folder names can now have ! in them.
#                  FIX: No left over [BB] code in what's new list.
#
# Version 3.2 -    NEW: Added script to list file names.
#               CHANGE: Checking for new content is now done by
#                       powershell.exe.
#                  FIX: Script can now be run from path with
#                       spaces in folder name.
#                  FIX: List names can now have spaces in name.
#
# Version 3.1 -    FIX: Forgotten to add a variable to the
#                       "Total space used:" in foldersize.ps1
#                       scripts, it will now use the listname
#                       variable in this file.
#
# Version 3.0 -    NEW: Added size calculations so size will be
#                       reported in KB, MB, GB or TB.
#               CHANGE: Only file that should be edited with new
#                       variables is now this file.
#                  FIX: Cleaned up folder size code removing
#                       unnecessary parts.
####################################################################
# KNOWN PROBLEMS AND BUGS!
# 
# -First time the script is run it will show error of missing temp
#  .txt files.
# -Error "Count cannot be less than -1" will come up each time because
#  it is replacing spaces with dots.
#
####################################################################
# HOW TO USE
# 
#      listname = The Name of your list, e.g. "Movies" or "TV Series".
#
#    RootFolder = Full path to the folder you want to make a list of.
#                 e.g. "C:\Movies" or "C:\TV Series"
#
#   FolderWidth = If you have long or short folder names this can be
#                 used to change how many dots is used in output file.
#
#    ListFolder = List folder set to TRUE, else FALSE.
#
# ListSubFolder = List sub folders set to TRUE, else FALSE.
#
# ListFilenames = List filenames set to TRUE, else FALSE.
#
#        BBcode = Add [BB] code for easier posting on forum set
#                 to TRUE else FALSE.
#
#  FileTypeSort = List only selected file types set to TRUE else FALSE.
#
#      FileType = e.g. $FileType1 = @(".mkv",".jpg",".pdf")
#
#                 DELETE OLD LISTS AND TEMP FILES WHEN UPDATING
#                 TO A NEW VERSION OF THIS SCRIPT!           
# 
####################################################################
# EDITABLE VARIABLES
#
### FOLDER 1
	$Listname1 = "Movies"
	$RootFolder1 = "\\SERVER\Storage\Movies"
	$FolderWidth1 = 125
	$ListFolder1=$TRUE
	$ListSubFolders1=$FALSE
	$ListFilenames1=$FALSE
	$BBcode1=$TRUE
	$FileTypeSort1=$FALSE
	$FileType1 = @(".mkv",".jpg",".pdf")
#	
### FOLDER 2
	$Listname2 = "TV-Series"
	$RootFolder2 = "\\SERVER\Storage\TV-Series"
	$FolderWidth2 = 60
	$ListFolder2=$TRUE
	$ListSubFolders2=$FALSE
	$ListFilenames2=$FALSE
	$BBcode2=$TRUE
	$FileTypeSort2=$FALSE
	$FileType2 = @(".mkv",".jpg",".pdf")
#	
### FOLDER 3
	$Listname3 = "Appz"
	$RootFolder3 = "\\SERVER\Storage\Programs"
	$FolderWidth3 = 100
	$ListFolder3=$TRUE
	$ListSubFolders3=$FALSE
	$ListFilenames3=$FALSE
	$BBcode3=$TRUE
	$FileTypeSort3=$FALSE
	$FileType3 = @(".mkv",".jpg",".pdf")
#	
### FOLDER 4
	$Listname4 = "Games"
	$RootFolder4 = "\\SERVER\Storage\Games"
	$FolderWidth4 = 100
	$ListFolder4=$TRUE
	$ListSubFolders4=$FALSE
	$ListFilenames4=$FALSE
	$BBcode4=$TRUE
	$FileTypeSort4=$FALSE
	$FileType4 = @(".mkv",".jpg",".pdf")
#	
### FOLDER 5
	$Listname5 = "Porn"
	$RootFolder5 = "\\SERVER\Storage\Porn"
	$FolderWidth5 = 100
	$ListFolder5=$TRUE
	$ListSubFolders5=$FALSE
	$ListFilenames5=$FALSE
	$BBcode5=$TRUE
	$FileTypeSort5=$FALSE
	$FileType5 = @(".mkv",".jpg",".pdf")
#
####################################################################
#
# ONLY EDIT BELOW THIS IF YOU REALLY FEEL LIKE IT!

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
[string]$ReportPath = $dir + "\ContentList\Temp\"
[string]$OpenPath = $dir + "\ContentList\"

$Listfile1 = $ReportPath + "\Folder1"
$Listfile2 = $ReportPath + "\Folder2"
$Listfile3 = $ReportPath + "\Folder3"
$Listfile4 = $ReportPath + "\Folder4"
$Listfile5 = $ReportPath + "\Folder5"

$FolderWidthTotal1 = $FolderWidth1 + 30
$FolderWidthTotal2 = $FolderWidth2 + 30
$FolderWidthTotal3 = $FolderWidth3 + 30
$FolderWidthTotal4 = $FolderWidth4 + 30
$FolderWidthTotal5 = $FolderWidth5 + 30

function Get-FormattedSize{
    param(
        [parameter( Mandatory = $TRUE )]
        [int64]$Size
        )

    switch( $Size ){
		{ $Size -gt 1TB }{ '{0:N2} TB' -f ( $Size  / 1TB ); break }
        { $Size -gt 1GB }{ '{0:N2} GB' -f ( $Size  / 1GB ); break }
        { $Size -gt 1MB }{ '{0:N2} MB' -f ( $Size  / 1MB ); break }
        { $Size -gt 1KB }{ '{0:N2} KB' -f ( $Size  / 1KB ); break }
        default { "$Size B"; break }
        }
    }
	
#Delete temp files
if(Test-Path $ReportPath\Folderlists\"Folder1.txt")
{Remove-Item $ReportPath\Folderlists\"Folder1.txt" -recurse -force}
if(Test-Path $ReportPath\Folderlists\"Folder2.txt")
{Remove-Item $ReportPath\Folderlists\"Folder2.txt" -recurse -force}
if(Test-Path $ReportPath\Folderlists\"Folder3.txt")
{Remove-Item $ReportPath\Folderlists\"Folder3.txt" -recurse -force}
if(Test-Path $ReportPath\Folderlists\"Folder4.txt")
{Remove-Item $ReportPath\Folderlists\"Folder4.txt" -recurse -force}
if(Test-Path $ReportPath\Folderlists\"Folder5.txt")
{Remove-Item $ReportPath\Folderlists\"Folder5.txt" -recurse -force}

if(Test-Path $ReportPath\Foldernew\"Folder1_new.txt")
{Remove-Item $ReportPath\Foldernew\"Folder1_new.txt" -recurse -force}
if(Test-Path $ReportPath\Foldernew\"Folder2_new.txt")
{Remove-Item $ReportPath\Foldernew\"Folder2_new.txt" -recurse -force}
if(Test-Path $ReportPath\Foldernew\"Folder3_new.txt")
{Remove-Item $ReportPath\Foldernew\"Folder3_new.txt" -recurse -force}
if(Test-Path $ReportPath\Foldernew\"Folder4_new.txt")
{Remove-Item $ReportPath\Foldernew\"Folder4_new.txt" -recurse -force}
if(Test-Path $ReportPath\Foldernew\"Folder5_new.txt")
{Remove-Item $ReportPath\Foldernew\"Folder5_new.txt" -recurse -force}
	
###################  START OF FOLDER 1 CODE  ###################
if ($ListFolder1)
{

write-host Starting to scan $RootFolder1

#Copy files where they need to be
Copy-Item $ReportPath\Folderoriginal\"Folder1_original.txt" $ReportPath\Folderdiff\"Folder1_diff.txt" -recurse -force

$Results = New-Object -TypeName System.Collections.ArrayList

$RootSize = Get-ChildItem -LiteralPath $RootFolder1 -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
$TotalSize = Get-FormattedSize -Size $RootSize

$null = $Results.Add(( New-Object -TypeName psobject -Property @{
    Path = $RootFolder1
    Size = Get-FormattedSize -Size $RootSize
    } ))

#Add BB code if TRUE
if ($BBcode1)
{
$Results.Add("[SPOILER=" + $Listname1 + "]" + "[b]" + $Listname1 + "[/b][CODE]  ")
}

	if ($ListFilenames1)
	{
		if ($FileTypeSort1) {$Files = Get-ChildItem -LiteralPath $RootFolder1 | where {$_.extension -in $FileType1} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $RootFolder1 | Where-Object { -not $_.PSIsContainer }}
		
    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}

#Scan sub folders if TRUE
	if ($ListSubFolders1)
	{
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder1 -Recurse |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
		
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = $Folder
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))
	
	if ($ListFilenames1)
	{
	    if ($FileTypeSort1) {$Files = Get-ChildItem -LiteralPath $Folder | where {$_.extension -in $FileType1} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $Folder | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}	
	write-host $Folder
	}
	}
	else
	{
	
	#Copy files where they need to be
	Copy-Item $ReportPath\Folderoriginal\"Folder1_original.txt" $ReportPath\Folderdiff\"Folder1_diff.txt" -recurse -force	
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder1 |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
	
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = Split-Path $Folder -Leaf
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))		
	write-host $Folder
	}	
	}

$Results | Format-Table @{n="Path";Width=$FolderWidth1;e={"{0:N0}" -f $_.Path};a="Left"},
				@{n="Files";e={"{0:N0}" -f $_.Files};a="Right"},
				@{n="Size";e={"{0:N0}" -f $_.Size};a="Right"} ` | Out-String -Width $FolderWidthTotal1 | Out-File $Listfile1".temp.txt" -Encoding ascii

Get-Content -Path $Listfile1".temp.txt" | Select-Object -Skip 4 | Out-File $Listfile1".temp2.txt" -Encoding ascii
Get-Content -Path $Listfile1".temp2.txt" | Select-Object -Skiplast 2 | Out-File $Listfile1".temp3.txt" -Encoding ascii

#Add calculated size and [BB] code to listname1.txt
if ($BBcode1)
{
Write-output "[/SPOILER][/CODE]  " | Out-File $Listfile1".temp3.txt" -Append -Encoding ascii
}
"Total " + $Listname1 + " space used: " + $TotalSize | Out-File $Listfile1".temp3.txt" -Append -Encoding ascii
Write-output "  " | Out-File $Listfile1".temp3.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
$Filedot = [regex]".File"
Get-Content $Listfile1".temp3.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Foreach-Object {$_ -replace '.File',' File'} | Out-File $Listfile1".temp4.txt" -Encoding ascii

# Copy files where they need to be
Copy-Item $Listfile1".temp4.txt" $ReportPath\Folderoriginal\"Folder1_original.txt" -recurse -force
Copy-Item $Listfile1".temp4.txt" $ReportPath\Folderlists\"Folder1.txt" -recurse -force

# Compare old with new file
Write-output "  " | Out-File $ReportPath\"Folder1_new_temp.txt" -Encoding ascii
(Get-Date).tostring("dd.MM.yyyy") + " - " + $Listname1 | Out-File $ReportPath\"Folder1_new_temp.txt" -Append -Encoding ascii

if ($BBcode1)
{
Write-output "[CODE]  " | Out-File $ReportPath\"Folder1_new_temp.txt" -Append -Encoding ascii
}
$apples = Get-Content $ReportPath\Folderdiff\"Folder1_diff.txt"
$oranges = Get-Content $ReportPath\Folderoriginal\"Folder1_original.txt"

Compare-Object -ReferenceObject $apples -PassThru -DifferenceObject $oranges | where {$_.SideIndicator -eq "=>"} | Out-File $ReportPath\"Folder1_new_temp.txt" -Append -Encoding ascii

if ($BBcode1)
{
Write-output "[/CODE]  " | Out-File $ReportPath\"Folder1_new_temp.txt" -Append -Encoding ascii
}
Write-output "  " | Out-File $ReportPath\"Folder1_new_temp.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
Get-Content $ReportPath\"Folder1_new_temp.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Out-File $ReportPath\"Folder1_new_temp2.txt" -Encoding ascii

Get-Content $ReportPath\"Folder1_new_temp2.txt" |  
	Foreach-Object {$_ -replace '.File',' File'} | Out-File $ReportPath\Foldernew\"Folder1_new.txt" -Encoding ascii

}         
else
{
write-host "ScanFolder1 set to FALSE, Skipping" $Listname1
}			
###################  END OF FOLDER 1 CODE  ###################

###################  START OF FOLDER 2 CODE  ###################
if ($ListFolder2)
{

write-host Starting to scan $RootFolder2

#Copy files where they need to be
Copy-Item $ReportPath\Folderoriginal\"Folder2_original.txt" $ReportPath\Folderdiff\"Folder2_diff.txt" -recurse -force

$Results = New-Object -TypeName System.Collections.ArrayList

$RootSize = Get-ChildItem -LiteralPath $RootFolder2 -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
$TotalSize = Get-FormattedSize -Size $RootSize

$null = $Results.Add(( New-Object -TypeName psobject -Property @{
    Path = $RootFolder2
    Size = Get-FormattedSize -Size $RootSize
    } ))

#Add BB code if TRUE
if ($BBcode2)
{
$Results.Add("[SPOILER=" + $Listname2 + "]" + "[b]" + $Listname2 + "[/b][CODE]  ")
}

	if ($ListFilenames2)
	{
	    if ($FileTypeSort2) {$Files = Get-ChildItem -LiteralPath $RootFolder2 | where {$_.extension -in $FileType2} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $RootFolder2 | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}

#Scan sub folders if TRUE
	if ($ListSubFolders2)
	{
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder2 -Recurse |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
		
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = $Folder
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))
	
	if ($ListFilenames2)
	{
		if ($FileTypeSort2) {$Files = Get-ChildItem -LiteralPath $Folder | where {$_.extension -in $FileType2} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $Folder | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}	
	write-host $Folder
	}
	}
	else
	{
	
	#Copy files where they need to be
	Copy-Item $ReportPath\Folderoriginal\"Folder2_original.txt" $ReportPath\Folderdiff\"Folder2_diff.txt" -recurse -force	
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder2 |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
	
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = Split-Path $Folder -Leaf
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))		
	write-host $Folder
	}	
	}

$Results | Format-Table @{n="Path";Width=$FolderWidth2;e={"{0:N0}" -f $_.Path};a="Left"},
				@{n="Files";e={"{0:N0}" -f $_.Files};a="Right"},
				@{n="Size";e={"{0:N0}" -f $_.Size};a="Right"} ` | Out-String -Width $FolderWidthTotal2 | Out-File $Listfile2".temp.txt" -Encoding ascii

Get-Content -Path $Listfile2".temp.txt" | Select-Object -Skip 4 | Out-File $Listfile2".temp2.txt" -Encoding ascii
Get-Content -Path $Listfile2".temp2.txt" | Select-Object -Skiplast 2 | Out-File $Listfile2".temp3.txt" -Encoding ascii

#Add calculated size and [BB] code to listname1.txt
if ($BBcode2)
{
Write-output "[/SPOILER][/CODE]  " | Out-File $Listfile2".temp3.txt" -Append -Encoding ascii
}
"Total " + $Listname2 + " space used: " + $TotalSize | Out-File $Listfile2".temp3.txt" -Append -Encoding ascii
Write-output "  " | Out-File $Listfile2".temp3.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
$Filedot = [regex]".File"
Get-Content $Listfile2".temp3.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Foreach-Object {$_ -replace '.File',' File'} | Out-File $Listfile2".temp4.txt" -Encoding ascii

# Copy files where they need to be
Copy-Item $Listfile2".temp4.txt" $ReportPath\Folderoriginal\"Folder2_original.txt" -recurse -force
Copy-Item $Listfile2".temp4.txt" $ReportPath\Folderlists\"Folder2.txt" -recurse -force

# Compare old with new file
Write-output "  " | Out-File $ReportPath\"Folder2_new_temp.txt" -Encoding ascii
(Get-Date).tostring("dd.MM.yyyy") + " - " + $Listname2 | Out-File $ReportPath\"Folder2_new_temp.txt" -Append -Encoding ascii

if ($BBcode2)
{
Write-output "[CODE]  " | Out-File $ReportPath\"Folder2_new_temp.txt" -Append -Encoding ascii
}
$apples = Get-Content $ReportPath\Folderdiff\"Folder2_diff.txt"
$oranges = Get-Content $ReportPath\Folderoriginal\"Folder2_original.txt"

Compare-Object -ReferenceObject $apples -PassThru -DifferenceObject $oranges | where {$_.SideIndicator -eq "=>"} | Out-File $ReportPath\"Folder2_new_temp.txt" -Append -Encoding ascii

if ($BBcode2)
{
Write-output "[/CODE]  " | Out-File $ReportPath\"Folder2_new_temp.txt" -Append -Encoding ascii
}
Write-output "  " | Out-File $ReportPath\"Folder2_new_temp.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
Get-Content $ReportPath\"Folder2_new_temp.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Out-File $ReportPath\"Folder2_new_temp2.txt" -Encoding ascii

Get-Content $ReportPath\"Folder2_new_temp2.txt" |  
	Foreach-Object {$_ -replace '.File',' File'} | Out-File $ReportPath\Foldernew\"Folder2_new.txt" -Encoding ascii

}         
else
{
write-host "ScanFolder2 set to FALSE, Skipping" $Listname2
}			
###################  END OF FOLDER 2 CODE  ###################

###################  START OF FOLDER 3 CODE  ###################
if ($ListFolder3)
{

write-host Starting to scan $RootFolder3

#Copy files where they need to be
Copy-Item $ReportPath\Folderoriginal\"Folder3_original.txt" $ReportPath\Folderdiff\"Folder3_diff.txt" -recurse -force

$Results = New-Object -TypeName System.Collections.ArrayList

$RootSize = Get-ChildItem -LiteralPath $RootFolder3 -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
$TotalSize = Get-FormattedSize -Size $RootSize

$null = $Results.Add(( New-Object -TypeName psobject -Property @{
    Path = $RootFolder3
    Size = Get-FormattedSize -Size $RootSize
    } ))

#Add BB code if TRUE
if ($BBcode3)
{
$Results.Add("[SPOILER=" + $Listname3 + "]" + "[b]" + $Listname3 + "[/b][CODE]  ")
}

	if ($ListFilenames3)
	{
	    if ($FileTypeSort3) {$Files = Get-ChildItem -LiteralPath $RootFolder3 | where {$_.extension -in $FileType3} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $RootFolder3 | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}

#Scan sub folders if TRUE
	if ($ListSubFolders3)
	{
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder3 -Recurse |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
		
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = $Folder
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))
	
	if ($ListFilenames3)
	{
		if ($FileTypeSort3) {$Files = Get-ChildItem -LiteralPath $Folder | where {$_.extension -in $FileType3} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $Folder | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}	
	write-host $Folder
	}
	}
	else
	{
	
	#Copy files where they need to be
	Copy-Item $ReportPath\Folderoriginal\"Folder3_original.txt" $ReportPath\Folderdiff\"Folder3_diff.txt" -recurse -force	
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder3 |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
	
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = Split-Path $Folder -Leaf
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))		
	write-host $Folder
	}	
	}

$Results | Format-Table @{n="Path";Width=$FolderWidth3;e={"{0:N0}" -f $_.Path};a="Left"},
				@{n="Files";e={"{0:N0}" -f $_.Files};a="Right"},
				@{n="Size";e={"{0:N0}" -f $_.Size};a="Right"} ` | Out-String -Width $FolderWidthTotal3 | Out-File $Listfile3".temp.txt" -Encoding ascii

Get-Content -Path $Listfile3".temp.txt" | Select-Object -Skip 4 | Out-File $Listfile3".temp2.txt" -Encoding ascii
Get-Content -Path $Listfile3".temp2.txt" | Select-Object -Skiplast 2 | Out-File $Listfile3".temp3.txt" -Encoding ascii

#Add calculated size and [BB] code to listname3.txt
if ($BBcode3)
{
Write-output "[/SPOILER][/CODE]  " | Out-File $Listfile3".temp3.txt" -Append -Encoding ascii
}
"Total " + $Listname3 + " space used: " + $TotalSize | Out-File $Listfile3".temp3.txt" -Append -Encoding ascii
Write-output "  " | Out-File $Listfile3".temp3.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
$Filedot = [regex]".File"
Get-Content $Listfile3".temp3.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Foreach-Object {$_ -replace '.File',' File'} | Out-File $Listfile3".temp4.txt" -Encoding ascii

# Copy files where they need to be
Copy-Item $Listfile3".temp4.txt" $ReportPath\Folderoriginal\"Folder3_original.txt" -recurse -force
Copy-Item $Listfile3".temp4.txt" $ReportPath\Folderlists\"Folder3.txt" -recurse -force

# Compare old with new file
Write-output "  " | Out-File $ReportPath\"Folder3_new_temp.txt" -Encoding ascii
(Get-Date).tostring("dd.MM.yyyy") + " - " + $Listname3 | Out-File $ReportPath\"Folder3_new_temp.txt" -Append -Encoding ascii

if ($BBcode3)
{
Write-output "[CODE]  " | Out-File $ReportPath\"Folder3_new_temp.txt" -Append -Encoding ascii
}
$apples = Get-Content $ReportPath\Folderdiff\"Folder3_diff.txt"
$oranges = Get-Content $ReportPath\Folderoriginal\"Folder3_original.txt"

Compare-Object -ReferenceObject $apples -PassThru -DifferenceObject $oranges | where {$_.SideIndicator -eq "=>"} | Out-File $ReportPath\"Folder3_new_temp.txt" -Append -Encoding ascii

if ($BBcode3)
{
Write-output "[/CODE]  " | Out-File $ReportPath\"Folder3_new_temp.txt" -Append -Encoding ascii
}
Write-output "  " | Out-File $ReportPath\"Folder3_new_temp.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
Get-Content $ReportPath\"Folder3_new_temp.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Out-File $ReportPath\"Folder3_new_temp2.txt" -Encoding ascii

Get-Content $ReportPath\"Folder3_new_temp2.txt" |  
	Foreach-Object {$_ -replace '.File',' File'} | Out-File $ReportPath\Foldernew\"Folder3_new.txt" -Encoding ascii

}         
else
{
write-host "ScanFolder3 set to FALSE, Skipping" $Listname3
}			
###################  END OF FOLDER 3 CODE  ###################

###################  START OF FOLDER 4 CODE  ###################
if ($ListFolder4)
{

write-host Starting to scan $RootFolder4

#Copy files where they need to be
Copy-Item $ReportPath\Folderoriginal\"Folder4_original.txt" $ReportPath\Folderdiff\"Folder4_diff.txt" -recurse -force

$Results = New-Object -TypeName System.Collections.ArrayList

$RootSize = Get-ChildItem -LiteralPath $RootFolder4 -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
$TotalSize = Get-FormattedSize -Size $RootSize

$null = $Results.Add(( New-Object -TypeName psobject -Property @{
    Path = $RootFolder4
    Size = Get-FormattedSize -Size $RootSize
    } ))

#Add BB code if TRUE
if ($BBcode4)
{
$Results.Add("[SPOILER=" + $Listname4 + "]" + "[b]" + $Listname4 + "[/b][CODE]  ")
}

	if ($ListFilenames4)
	{
		if ($FileTypeSort4) {$Files = Get-ChildItem -LiteralPath $RootFolder4 | where {$_.extension -in $FileType4} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $RootFolder4 | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}

#Scan sub folders if TRUE
	if ($ListSubFolders4)
	{
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder4 -Recurse |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
		
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = $Folder
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))
	
	if ($ListFilenames4)
	{
		if ($FileTypeSort4) {$Files = Get-ChildItem -LiteralPath $Folder | where {$_.extension -in $FileType4} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $Folder | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}	
	write-host $Folder
	}
	}
	else
	{
	
	#Copy files where they need to be
	Copy-Item $ReportPath\Folderoriginal\"Folder4_original.txt" $ReportPath\Folderdiff\"Folder4_diff.txt" -recurse -force	
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder4 |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
	
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = Split-Path $Folder -Leaf
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))		
	write-host $Folder
	}	
	}

$Results | Format-Table @{n="Path";Width=$FolderWidth4;e={"{0:N0}" -f $_.Path};a="Left"},
				@{n="Files";e={"{0:N0}" -f $_.Files};a="Right"},
				@{n="Size";e={"{0:N0}" -f $_.Size};a="Right"} ` | Out-String -Width $FolderWidthTotal4 | Out-File $Listfile4".temp.txt" -Encoding ascii

Get-Content -Path $Listfile4".temp.txt" | Select-Object -Skip 4 | Out-File $Listfile4".temp2.txt" -Encoding ascii
Get-Content -Path $Listfile4".temp2.txt" | Select-Object -Skiplast 2 | Out-File $Listfile4".temp3.txt" -Encoding ascii

#Add calculated size and [BB] code to listname4.txt
if ($BBcode4)
{
Write-output "[/SPOILER][/CODE]  " | Out-File $Listfile4".temp3.txt" -Append -Encoding ascii
}
"Total " + $Listname4 + " space used: " + $TotalSize | Out-File $Listfile4".temp3.txt" -Append -Encoding ascii
Write-output "  " | Out-File $Listfile4".temp3.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
$Filedot = [regex]".File"
Get-Content $Listfile4".temp3.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Foreach-Object {$_ -replace '.File',' File'} | Out-File $Listfile4".temp4.txt" -Encoding ascii

# Copy files where they need to be
Copy-Item $Listfile4".temp4.txt" $ReportPath\Folderoriginal\"Folder4_original.txt" -recurse -force
Copy-Item $Listfile4".temp4.txt" $ReportPath\Folderlists\"Folder4.txt" -recurse -force

# Compare old with new file
Write-output "  " | Out-File $ReportPath\"Folder4_new_temp.txt" -Encoding ascii
(Get-Date).tostring("dd.MM.yyyy") + " - " + $Listname4 | Out-File $ReportPath\"Folder4_new_temp.txt" -Append -Encoding ascii

if ($BBcode4)
{
Write-output "[CODE]  " | Out-File $ReportPath\"Folder4_new_temp.txt" -Append -Encoding ascii
}
$apples = Get-Content $ReportPath\Folderdiff\"Folder4_diff.txt"
$oranges = Get-Content $ReportPath\Folderoriginal\"Folder4_original.txt"

Compare-Object -ReferenceObject $apples -PassThru -DifferenceObject $oranges | where {$_.SideIndicator -eq "=>"} | Out-File $ReportPath\"Folder4_new_temp.txt" -Append -Encoding ascii

if ($BBcode4)
{
Write-output "[/CODE]  " | Out-File $ReportPath\"Folder4_new_temp.txt" -Append -Encoding ascii
}
Write-output "  " | Out-File $ReportPath\"Folder4_new_temp.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
Get-Content $ReportPath\"Folder4_new_temp.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Out-File $ReportPath\"Folder4_new_temp2.txt" -Encoding ascii

Get-Content $ReportPath\"Folder4_new_temp2.txt" |  
	Foreach-Object {$_ -replace '.File',' File'} | Out-File $ReportPath\Foldernew\"Folder4_new.txt" -Encoding ascii

}         
else
{
write-host "ScanFolder4 set to FALSE, Skipping" $Listname4
}			
###################  END OF FOLDER 4 CODE  ###################

###################  START OF FOLDER 5 CODE  ###################
if ($ListFolder5)
{

write-host Starting to scan $RootFolder5

#Copy files where they need to be
Copy-Item $ReportPath\Folderoriginal\"Folder5_original.txt" $ReportPath\Folderdiff\"Folder5_diff.txt" -recurse -force

$Results = New-Object -TypeName System.Collections.ArrayList

$RootSize = Get-ChildItem -LiteralPath $RootFolder5 -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
$TotalSize = Get-FormattedSize -Size $RootSize

$null = $Results.Add(( New-Object -TypeName psobject -Property @{
    Path = $RootFolder5
    Size = Get-FormattedSize -Size $RootSize
    } ))

#Add BB code if TRUE
if ($BBcode5)
{
$Results.Add("[SPOILER=" + $Listname5 + "]" + "[b]" + $Listname5 + "[/b][CODE]  ")
}

	if ($ListFilenames5)
	{
	    if ($FileTypeSort5) {$Files = Get-ChildItem -LiteralPath $RootFolder5 | where {$_.extension -in $FileType5} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $RootFolder5 | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}

#Scan sub folders if TRUE
	if ($ListSubFolders5)
	{
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder5 -Recurse |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
		
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = $Folder
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))
	
	if ($ListFilenames5)
	{
		if ($FileTypeSort5) {$Files = Get-ChildItem -LiteralPath $Folder | where {$_.extension -in $FileType5} | Where-Object { -not $_.PSIsContainer }}
		else {$Files = Get-ChildItem -LiteralPath $Folder | Where-Object { -not $_.PSIsContainer }}

    foreach( $File in $Files ){
        $Results.Add(( New-Object -TypeName psobject -Property @{
            Path = $File.Name
            Size = Get-FormattedSize -Size $File.Length
            } ))
		}
	$Results.Add( '  ' )
	}	
	write-host $Folder
	}
	}
	else
	{
	
	#Copy files where they need to be
	Copy-Item $ReportPath\Folderoriginal\"Folder5_original.txt" $ReportPath\Folderdiff\"Folder5_diff.txt" -recurse -force	
	
	$Folders = Get-ChildItem -LiteralPath $RootFolder5 |
    Where-Object { $_.PSIsContainer } | Sort-Object FullName |
    Select-Object -ExpandProperty FullName
	
	$null = foreach( $Folder in $Folders ){
    $FolderSize = Get-ChildItem -LiteralPath $Folder -Recurse |
        Where-Object { -not $_.PSIsContainer } |
        Measure-Object -Property Length -Sum |
        Select-Object -ExpandProperty Sum
		
	$Filecount = @( Get-ChildItem -Recurse -File -LiteralPath $Folder ).Count;

	$Results.Add(( New-Object -TypeName psobject -Property @{
	
    Path = Split-Path $Folder -Leaf
	Files = ("" + $Filecount + " File(s)") 
	Size = Get-FormattedSize -Size $FolderSize
	} ))		
	write-host $Folder
	}	
	}

$Results | Format-Table @{n="Path";Width=$FolderWidth5;e={"{0:N0}" -f $_.Path};a="Left"},
				@{n="Files";e={"{0:N0}" -f $_.Files};a="Right"},
				@{n="Size";e={"{0:N0}" -f $_.Size};a="Right"} ` | Out-String -Width $FolderWidthTotal5 | Out-File $Listfile5".temp.txt" -Encoding ascii

Get-Content -Path $Listfile5".temp.txt" | Select-Object -Skip 4 | Out-File $Listfile5".temp2.txt" -Encoding ascii
Get-Content -Path $Listfile5".temp2.txt" | Select-Object -Skiplast 2 | Out-File $Listfile5".temp3.txt" -Encoding ascii

#Add calculated size and [BB] code to listname5.txt
if ($BBcode5)
{
Write-output "[/SPOILER][/CODE]  " | Out-File $Listfile5".temp3.txt" -Append -Encoding ascii
}
"Total " + $Listname5 + " space used: " + $TotalSize | Out-File $Listfile5".temp3.txt" -Append -Encoding ascii
Write-output "  " | Out-File $Listfile5".temp3.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
$Filedot = [regex]".File"
Get-Content $Listfile5".temp3.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Foreach-Object {$_ -replace '.File',' File'} | Out-File $Listfile5".temp4.txt" -Encoding ascii

# Copy files where they need to be
Copy-Item $Listfile5".temp4.txt" $ReportPath\Folderoriginal\"Folder5_original.txt" -recurse -force
Copy-Item $Listfile5".temp4.txt" $ReportPath\Folderlists\"Folder5.txt" -recurse -force

# Compare old with new file
Write-output "  " | Out-File $ReportPath\"Folder5_new_temp.txt" -Encoding ascii
(Get-Date).tostring("dd.MM.yyyy") + " - " + $Listname5 | Out-File $ReportPath\"Folder5_new_temp.txt" -Append -Encoding ascii

if ($BBcode5)
{
Write-output "[CODE]  " | Out-File $ReportPath\"Folder5_new_temp.txt" -Append -Encoding ascii
}
$apples = Get-Content $ReportPath\Folderdiff\"Folder5_diff.txt"
$oranges = Get-Content $ReportPath\Folderoriginal\"Folder5_original.txt"

Compare-Object -ReferenceObject $apples -PassThru -DifferenceObject $oranges | where {$_.SideIndicator -eq "=>"} | Out-File $ReportPath\"Folder5_new_temp.txt" -Append -Encoding ascii

if ($BBcode5)
{
Write-output "[/CODE]  " | Out-File $ReportPath\"Folder5_new_temp.txt" -Append -Encoding ascii
}
Write-output "  " | Out-File $ReportPath\"Folder5_new_temp.txt" -Append -Encoding ascii

# Replace space with dots.
$space = [regex]" "
Get-Content $ReportPath\"Folder5_new_temp.txt" | ForEach { 
    $numOfspaceToReplace = $space.Matches($_).Count -2
    $space.Replace($_, '.', $numOfspaceToReplace)
} | Out-File $ReportPath\"Folder5_new_temp2.txt" -Encoding ascii

Get-Content $ReportPath\"Folder5_new_temp2.txt" |  
	Foreach-Object {$_ -replace '.File',' File'} | Out-File $ReportPath\Foldernew\"Folder5_new.txt" -Encoding ascii

}         
else
{
write-host "ScanFolder5 set to FALSE, Skipping" $Listname5
}			
###################  END OF FOLDER 5 CODE  ###################

###################  END OF ALL FOLDER CODE  ###################
if ($ListFolder1 -or $ListFolder2 -or $ListFolder3 -or $ListFolder4 -or $ListFolder5)
{
# Append list files together
Get-Content $ReportPath\Folderlists\*.txt | Set-Content $OpenPath\Folder_Content_List.txt
Get-Content $ReportPath\Foldernew\*.txt | Set-Content $OpenPath\Folder_Content_List_NEW.txt

# Open Nnotepad
Start-Process notepad $OpenPath\Folder_Content_List_NEW.txt
Start-Process notepad $OpenPath\Folder_Content_List.txt
}

