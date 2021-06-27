function Get-AllLicPlansNamesByGUID {

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $wc = New-Object System.Net.WebClient
    $wc.Encoding = [System.Text.Encoding]::UTF8
    $src = $wc.downloadstring('https://docs.microsoft.com/es-es/azure/active-directory/enterprise-users/licensing-service-plan-reference')

    $msrc = Select-String -InputObject $src -Pattern '<tr>\n<td>(.*?)</td>\n<td>(.*?)</td>\n<td>(\w{8}-\w{4}-\w{4}-\w{4}-\w{12})</td>' -AllMatches

    $hash = @{}

    $GUID = ''

    foreach ($m in $msrc[0].matches) {
        
        $GUID = $m.groups[3].Value

        $obj = [pscustomobject]@{ 

            Identificador  = $m.groups[2].Value
            NombreProducto = $m.groups[1].Value
        }

        $hash[$GUID] = $obj

    }

    return $hash
}

# Ejemplo

$hash = Get-AllLicPlansNamesByGUID

$GUID_List = ('7cfd9a2b-e110-4c39-bf20-c6a3f36a3121',
              'b214fe43-f5a3-4703-beeb-fa97188220fc')

foreach ($GUID in $GUID_List) {

    Write-Host "`n               GUID: $GUID"
    Write-Host "Nombre del Producto:"$hash[$GUID].NombreProducto
    Write-Host "      Identificador:"$hash[$GUID].Identificador
}

Write-Host ''


