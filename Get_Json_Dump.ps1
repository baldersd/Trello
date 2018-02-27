#LOAD FUNCTIONS
# Import ALL available dot sourced functions from sub-directory containing functions.
$CurrentPath = (split-path -parent $MyInvocation.MyCommand.Definition)
If (test-path "$CurrentPath\Functions" -ErrorAction SilentlyContinue) {
    foreach ($functionscript in Get-ChildItem -Path "$CurrentPath\Functions\*.ps1") {
        # Display Debug Message
        if ($Debug) {write-host "Including function: " ($($functionscript).name) -ForegroundColor Yellow}
    . $functionscript
    } # END: import all available functions.
}
$trellokey ='950ec181034140adafc873b23b92b850'
$r = Show-OAuthWindow "https://api.trello.com/1/authorize?expiration=never&scope=read&response_type=token&name=Server%20Token&key=$trellokey"
$code = "1b660504af92c1878b0662c15f7d2eb1a5cf26860f4293e1eb3c813507a0d08b"
$endpoint = "https://api.trello.com/1/boards/"
$board = "568d1709c01789eb33438746?lists=open&cards=open"
$auth = "&key=$trellokey&token=$global:code"
$request = $endpoint + $board + $auth
$json = Invoke-RESTMethod $request
$lists = @{}
$json.lists | % {$lists.add($_.id, $_.name)}
$json.cards | select "id", @{name="List"; expression={$lists[$_.idList]}}, "Priority", "Status", "% Complete", "Assigned To", "Task Group", name, "Started", Due, "Rating (0-5)", "No of Ratings", "Target Audience", "Predecessors", "Attachment" | Where-Object {$_.List -ne "FYI" -and $_.List -ne "Useful info"} | Export-CSV -path c:\temp\trellocsv.csv -NoClobber -NoTypeInformation -Force
