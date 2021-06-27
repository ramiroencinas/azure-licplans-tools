function Get-LicPlansNamesByGUID {

    param( [string] $GUID )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wc = New-Object System.Net.WebClient
    $wc.Encoding = [System.Text.Encoding]::UTF8
    $src = $wc.downloadstring('https://docs.microsoft.com/en-us/azure/active-directory/enterprise-users/licensing-service-plan-reference')

    if ( $src -match "<tr>\n<td>(.*?)</td>\n<td>(.*?)</td>\n<td>$GUID</td>") {

        return [pscustomobject]@{ 
            ProductName = $matches[1]
            StringID    = $matches[2]
        }        
    }    
}

# Example

$GUID = '7cfd9a2b-e110-4c39-bf20-c6a3f36a3121'

Write-Host "`n        GUID:"$GUID
Write-Host "Product Name:"(Get-LicPlansNamesByGUID -GUID $GUID).ProductName
Write-Host "   String ID:"(Get-LicPlansNamesByGUID -GUID $GUID).StringID
Write-Host ''





