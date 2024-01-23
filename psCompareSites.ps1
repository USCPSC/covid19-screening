# Author: Cpsc\asalomon
# Description: Updates the CDC Screening site app data by querying the cdc screening Feed and writing
# the children recalls (Recalls-Children-Rss.xml)  & the all recalls (Recalls-RSS.xml) to disk
# 
# 
#Trigger: will be triggered by task scheduler job named : Update CPSC Recalls Widget
#----------------------------------------------------------
function Get-Site-Html($path) {
  write-host $path
  $html = Invoke-WebRequest -Uri $path -Method GET 
  
  return $html
      
}
  
function Save-Html($fileName, $content) {
  write-host './$fileName'
  $fs = [System.IO.FileStream]::new('./$fileName', [System.IO.FileAccess]::ReadWrite)
  $Stream = [System.IO.StreamWriter]::new($fs )
  try {
    $Stream.Write($content.Content)
  }
  finally {
    $Stream.Close()
    
  }

  #$content.RawContent | Out-File -FilePath "./$fileName"  -Encoding utf8 
}

write-host 'starting..'

$allPath = @{
  PathName = 'screening' 
  Path     = 'https://www.cdc.gov/screening'
}
$basePath = $allPath.Path
write-host "base Path is $basePath"
$PrivacyPath = @{
  PathName = 'privacy' 
  Path     = "$basePath/privacy-notice.html" 
}

$paths = @($allPath, $PrivacyPath)
write-host $paths
#check if the paths are saved
#if not saved, save files to disk
#else compare saved files to current sites

foreach ($path in $paths) {
  $data = Get-Site-Html -path $path.Path
  
  if ($path.PathName -eq 'Screening') { 
    $localPath = "cdc-screening.html"
    if (!(Test-Path $localPath) ) {
      write-host "path is not saved, saving path..."
      Save-Html  -content  $data.Content -fileName $localPath
     
      #upload to github
    }
    else {
      write-host "compare saved file with site"
      $savedContent = Get-Content $localPath
      #compare file contents
      if (!($savedContent -eq $data.Content)) {
        
        write-host "File on Disk $localPath Is Different than Current CDC site"
        Send-MailMessage -SmtpServer treet.cpsc.gov -Subject "File on Disk Is Different than Current CDC site" -body $data.Content -From screening@cpsc.gov -to asalomon@cpsc.gov -Encoding utf8
        Save-Html -content $data.Content -fileName $localPath
      }
      else {
        write-host "No Changes detected"
      }
      
    }
  }
  else {  
    if (!(Test-Path "privacy-notice.html") ) {
      Save-Html -content $data -fileName "cdc-privacy.html" 
    }
    else {
      #comapre files
    }
  }
  
}