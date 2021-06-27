function Get-AllLicPlansNamesByGUID {

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wc = New-Object System.Net.WebClient
    $wc.Encoding = [System.Text.Encoding]::UTF8
    $src = $wc.downloadstring('https://docs.microsoft.com/en-us/azure/active-directory/enterprise-users/licensing-service-plan-reference')

    $msrc = Select-String -InputObject $src -Pattern '<tr>\n<td>(.*?)</td>\n<td>(.*?)</td>\n<td>(\w{8}-\w{4}-\w{4}-\w{4}-\w{12})</td>' -AllMatches

    $hash = @{}

    $GUID = ''

    foreach ($m in $msrc[0].matches) {
        
        $GUID = $m.groups[3].Value

        $obj = [pscustomobject]@{ 

            StringID    = $m.groups[2].Value
            ProductName = $m.groups[1].Value
        }

        $hash[$GUID] = $obj

    }

    return $hash
}

# Example

$hash = Get-AllLicPlansNamesByGUID

$GUID_List = ('7cfd9a2b-e110-4c39-bf20-c6a3f36a3121',
              'b214fe43-f5a3-4703-beeb-fa97188220fc')

foreach ($GUID in $GUID_List) {

    Write-Host "`n        GUID: $GUID"
    Write-Host "Product Name:"$hash[$GUID].ProductName
    Write-Host "   String ID:"$hash[$GUID].StringID

}

Write-Host ''




