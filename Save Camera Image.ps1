#poweshell save image from camera

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@


[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy



$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Content-Type", "application/json")

$body = "[
`n    { `"cmd`":`"Login`",
`n        `"param`":{
`n            `"User`":{
`n                `"Version`": `"0`",
`n                `"userName`":`"admin`",
`n                `"password`":`"123456`"
`n            }
`n        }
`n    }
`n]"

$response = Invoke-RestMethod 'https://192.168.1.64/api.cgi?cmd=Login' -Method 'POST' -Headers $headers -Body $body

$token = $response.value.token.name

$response = Invoke-RestMethod "https://192.168.1.64/cgi-bin/api.cgi?cmd=Snap&channel=0&rs=flsYJfZgM6RTB_os&token=$token" -Method 'GET' -Headers $headers -OutFile C:\temp\outside.jpg
