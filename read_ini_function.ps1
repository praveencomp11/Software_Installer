Function Read-ini($ini_file_path, $ini_keys_array){
	$INI= Get-Content $ini_file_path
	$IniHash=@{}
	$values_array=@()
	ForEach ($Line in $INI){
		If ($Line.StartsWith('#') -ne $True -and $Line -ne "" -and $Line.StartsWith("[") -ne $True) {
			$ini_key,$ini_value=$Line -split '=', 2
			$IniHash+=@{$ini_key =$ini_value}
		}
	}

	ForEach($ini_key in $ini_keys_array){
		$values_array +=$IniHash.$ini_key		
	}
	return $values_array
}

Function PartitionCreation ($D_drive,$F_drive,$G_drive){
	Write-to-PartitionCreation -message "select volume c"
	Write-to-PartitionCreation -message "shrink desired=$D_drive"
	Write-to-PartitionCreation -message "create partition primary"
	Write-to-PartitionCreation -message "format quick fs=ntfs label'MY'"
	Write-to-PartitionCreation -message "assign letter='D'"
	
}