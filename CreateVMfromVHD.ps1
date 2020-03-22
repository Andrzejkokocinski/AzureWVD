$resourceGroupName = "WVD-Master"

$destinationVhd = "https://wvdmasterdisks570.blob.core.windows.net/vhds2/WVD-Master20200319155401.vhd"
 

$virtualNetworkName = "WVD-Master-vnet"
$locationName = "westeurope"
$virtualNetwork = Get-AzureRmVirtualNetwork -ResourceGroupName $resourceGroupName `
                                            -Name $virtualNetworkName



$publicIp = New-AzureRmPublicIpAddress -Name "PIP-WVD-Master-ag" -ResourceGroupName $ResourceGroupName `
                                       -Location $locationName -AllocationMethod Dynamic
$networkInterface = New-AzureRmNetworkInterface -ResourceGroupName $resourceGroupName `
     -Name "NIC-WVD-Master-ag" -Location $locationName -SubnetId $virtualNetwork.Subnets[0].Id  -PublicIpAddressId $publicIp.Id
    




     Get-AzureRmVMSize $locationName | Out-GridView


     $vmConfig = New-AzureRmVMConfig -VMName "WVD-Master-pre2" -VMSize "Standard_D2_v3"
$vmConfig = Set-AzureRmVMOSDisk -VM $vmConfig -Name "WVD-Master-pre2" -VhdUri $destinationVhd `
                                -CreateOption Attach -Windows
$vmConfig = Add-AzureRmVMNetworkInterface -VM $vmConfig -Id $networkInterface.Id

$vm = New-AzureRmVM -VM $vmConfig -Location $locationName -ResourceGroupName $resourceGroupName
