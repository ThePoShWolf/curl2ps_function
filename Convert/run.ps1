using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.

if ($Request.Query.CurlCommand) {
    $curlCommand = $Request.Query.CurlCommand
    switch($Request.Query.String){
        'true' {$string = $true}
        default {$string = $false}
    }
} elseif ($Request.Body.CurlCommand) {
    $curlCommand = $Request.Body.CurlCommand
    switch($Request.Body.String){
        'true' {$string = $true}
        default {$string = $false}
    }
} else {
    $status = [HttpStatusCode]::BadRequest
    $body = "Missing CurlCommand parameter in body or query."
}

if ($curlCommand) {
    $status = [HttpStatusCode]::OK
    $params = @{
        CurlCommand = $curlCommand
        String = $string
    }
    $body = ConvertTo-IRM @params
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
