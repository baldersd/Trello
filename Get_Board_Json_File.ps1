#JSON savefile locations
$file1 = "C:\Documents\Trello\MyProjectBoard.json"
Remove-Item $file1 -Force -ErrorAction SilentlyContinue
#AUTH objects
$trellokey ='xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$secretkey ='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$auth = "key=$trellokey&token=$token"
#Set target EXPORT Json board files
$source1 = "https://trello.com/1/boards/58ac1187ed8338ed221dc71d?$auth&fields=all&actions=all&action_fields=all&actions_limit=1000&cards=all&card_fields=all&card_attachments=true&lists=all&list_fields=all&members=all&member_fields=all&checklists=all&checklist_fields=all&organization=false"
#PULL DOWN the JSON files
$securepassword = ConvertTo-SecureString "password1234" -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential("daniel@acme.com", $securepassword)
Invoke-WebRequest -Uri $source1 -OutFile $file1 -Credential $credentials
