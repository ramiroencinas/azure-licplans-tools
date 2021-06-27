function Get-LicPlansNamesByGUID {

    param( [string] $GUID )

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wc = New-Object System.Net.WebClient
    $wc.Encoding = [System.Text.Encoding]::UTF8
    $src = $wc.downloadstring('https://docs.microsoft.com/es-es/azure/active-directory/enterprise-users/licensing-service-plan-reference')

    if ( $src -match "<tr>\n<td>(.*?)</td>\n<td>(.*?)</td>\n<td>$GUID</td>") {
        
        return [pscustomobject]@{ 
            NombreProducto = $matches[1]
            Identificador  = $matches[2]
        }  
    }    
}

# Ejemplo

$GUID = '7cfd9a2b-e110-4c39-bf20-c6a3f36a3121'

Write-Host "`n               GUID:"$GUID
Write-Host "Nombre del Producto:"(Get-LicPlansNamesByGUID -GUID $GUID).NombreProducto
Write-Host "      Identificador:"(Get-LicPlansNamesByGUID -GUID $GUID).Identificador
Write-Host ''




