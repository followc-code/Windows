function BKKeys {
Try {
    write-host BKKeys
    $AllDrives =(Get-BitLockerVolume).mountpoint
        foreach ($Drive in $AllDrives) {
    	    if ((Get-Bitlockervolume $drive).LockStatus -eq 'Locked')  {
    			write-host "Error: cannot backup key for $drive drive due to drive being in a locked state" } else {
			    $keyID = Get-BitLockerVolume -MountPoint $Drive | select -ExpandProperty keyprotector | where {$_.KeyProtectorType -eq 'RecoveryPassword'}
			    foreach ($key in $keyID.KeyProtectorId) {
				    #$key
			    	write-host backup key to On-Prem 
		    		Backup-BitLockerKeyProtector -MountPoint $Drive -KeyProtectorId $key
	    			#BackupToAAD-BitLockerKeyProtector -MountPoint $Drive -KeyProtectorId $key
    				#write-host $drive backed up to Azure
				    #pause
			    }
		    }
        }
    }
    
catch {
    #This will catch the rest of any error
    Write-Warning $Error[0]
    }
}

BKKeys