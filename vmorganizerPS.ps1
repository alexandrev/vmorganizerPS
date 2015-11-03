 param (
    [string]$source = $(throw "-source is required"),
	[string]$mode = "single"
 )

function processVM ($source)
{
		$target = $source + ".7z"
		if(-not (test-path $target)){
			Write-Host "Creating file: $($target)"
			$output = sz a -mx=9 $target $source
			$testOK = $output -contains "Everything is Ok"
			Write-Host "Compressing file ended. Status: $($testOK)"
			$output = sz t $target
			$testOK = $output -contains "Everything is Ok"
			Write-Host "Testing file ended. Status: $($testOK)"
			Remove-Item $source -recurse 
		}else{
			Write-Host "Skipping file creation because it already exists."
		}
}



if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"}
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"



if($mode -eq "single"){
	processVM -source $source
}
else{

	$folders = Get-ChildItem -Path $source   | ?{ $_.PSIsContainer }

	foreach ($folder in $folders){
		processVM -source $folder.FullName

	}


}
