using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$curlCommand = $Request.Query.CurlCommand
if (-not $curlCommand) {
    $curlCommand = $Request.Body.CurlCommand
}

if ($curlCommand) {
    $status = [HttpStatusCode]::OK
    $body = ConvertTo-IRM -CurlCommand $curlCommand -String
}
else {
    $status = [HttpStatusCode]::BadRequest
    $body = "Please pass a curl command on the query string or in the request body."
}

Wait-Debugger

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
