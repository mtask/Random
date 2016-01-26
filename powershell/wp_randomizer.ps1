# Randomize wallpaper from pictures in given folder
# .\wp_randomizer.ps1 -path "path_to_wallpapers"
# Tested: Windows 10 Pro                                                                                                                   #


param (
    [string]$path = $(echo "-path to folder including wallpapers needed"),
    [string]$help = $(echo "Give path (-path) to folders where you have your wallpapers")
)

if(!(Test-Path -Path $path )){

    echo "path does not exist"
}


$wallpaper_candidates = $(get-childitem $path | foreach-object -process { $_.FullName })

if ( !$wallpaper_candidates) {
    throw "No wallpapers found"
}

$valid_wallpapers =@()

foreach ($wallpaper in $wallpaper_candidates) {
      
      $extension = $( [System.IO.Path]::GetExtension($wallpaper) )   
      echo $extension         
      if ( ( $extension -eq  ".png" ) -or ( $extension -eq  ".jpg" ) -or ( $extension -eq  ".jpeg" ) -or ( $extension -eq  ".bmp" ) ) {
          $valid_wallpapers += $wallpaper
          
      }
 }

 # Arvotaan satunnainen taustakuva
 $pic = $valid_wallpapers | Get-Random

 
Function Set-WallPaper($Value)
 {
    Set-ItemProperty -path 'HKCU:\Control Panel\Desktop\' -name wallpaper -value $Value

    rundll32.exe user32.dll, UpdatePerUserSystemParameters  
    rundll32.exe user32.dll, UpdatePerUserSystemParameters
    rundll32.exe user32.dll, UpdatePerUserSystemParameters 

 }

#Asetetaan arvottu taustakuva
Set-WallPaper -value $pic
