param ([string] $input_name)

$input_dest = ".\$input_name\"
$remorse_file = ".\remorse.$input_name.txt"
$remorse_dest = ".\ttt2_remorseful_repacks"
$remorse_ignore = ".\remorse_ignore.txt"
$remorse_ignore_data = Get-Content "$remorse_ignore"

function Make-PathThatMayNotExist {
	param (
		[string] $Path
	)

	$dir = Split-Path "$Path" -Parent
	if(-Not (Test-Path -Path "$dir")) {
		New-Item -Path "$dir" -ItemType Directory | Out-Null
	}
}

function Remove-EmptyDirectories {
	param (
		[string] $Path
	)

	do {
		$dirs = gci "$Path" -directory -recurse | Where { (gci $_.fullName -Force).count -eq 0 } | select -expandproperty FullName
		$dirs | Foreach-Object { Remove-Item $_ | Out-Null }
	} while ($dirs.count -gt 0)
}

function Check-IsRemorseIgnored {
	param (
		[string] $Path
	)

	$go = $True
	foreach( $_ in $remorse_ignore_data ) {
		# Write-Host "$line vs $_"
		if ( "$line" -match "$_" ) {
			$go = $False;
			break;
		}
	}
	return $go;
}


if (Test-Path "$remorse_file" -PathType Leaf) {
	# if there is a remorse file, iterate it
	Get-Content "$remorse_file" | % {
		$line = "$_"
		if ( Check-IsRemorseIgnored -Path "$line" ) {
			Write-Host "removing hardlink: $line"
			(Get-Item "$remorse_dest\$line").Delete()
		}
	}

	# eradicate empty folders
	Remove-EmptyDirectories -Path "$remorse_dest"

	# remove the remorse file
	(Get-Item "$remorse_file").Delete()
} else {
	# if there is no remorse file for this name,
	dir ".\$input_name\" -Recurse -Name -File | % {
		$line = "$_"
		if ( Check-IsRemorseIgnored -Path "$line" ) {
			Write-Host "creating hardlink: $line"
			Add-Content -Path "$remorse_file" -Value "$line" | Out-Null
			Make-PathThatMayNotExist -Path "$remorse_dest\$line"
			New-Item -Path "$remorse_dest\$line" -ItemType HardLink -Value ".\$input_name\$line" | Out-Null
		}
	}
}

