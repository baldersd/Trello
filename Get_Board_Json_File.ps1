#JSON savefile locations
$file2 = "C:\Users\AA23578\Documents\Scripts\PowerShell\Trello\AO_Project.json"
$file1 = "C:\Users\AA23578\Documents\Scripts\PowerShell\Trello\AO_CSI.json"
Remove-Item $file1 -Force -ErrorAction SilentlyContinue
Remove-Item $file2 -Force -ErrorAction SilentlyContinue
#AUTH objects
$trellokey ='950ec181034140adafc873b23b92b850'
$secretkey ='36cd1fa2bb100ce4018f3fe41c6d5b10a1524d97d5c1ee932d14e2dfdfc9a77b'
$token = "1b660504af92c1878b0662c15f7d2eb1a5cf26860f4293e1eb3c813507a0d08b"
$auth = "key=$trellokey&token=$token"
#Set target EXPORT Json board files
#https://trello.com/1/boards/<id>?fields=all&actions=all&action_fields=all&actions_limit=1000&cards=all&card_fields=all&card_attachments=true&lists=all&list_fields=all&members=all&member_fields=all&checklists=all&checklist_fields=all&organization=false
$source1 = "https://trello.com/1/boards/58ac1187ed8338ed221dc71d?$auth&fields=all&actions=all&action_fields=all&actions_limit=1000&cards=all&card_fields=all&card_attachments=true&lists=all&list_fields=all&members=all&member_fields=all&checklists=all&checklist_fields=all&organization=false"
$source2 = "https://trello.com/1/boards/58a57a0bf3e09ba23e2b7720?$auth&fields=all&actions=all&action_fields=all&actions_limit=1000&cards=all&card_fields=all&card_attachments=true&lists=all&list_fields=all&members=all&member_fields=all&checklists=all&checklist_fields=all&organization=false"
#$source1 = "https://trello.com/b/AuSOXC9g.json$auth"
#$source2 = "https://trello.com/b/i8AmFgdA.json$auth"
#PULL DOWN the JSON files
$securepassword = ConvertTo-SecureString "F14ATomcat" -AsPlainText -Force
$credentials = New-Object System.Management.Automation.PSCredential("daniel.baldree@centurylink.com", $securepassword)
Invoke-WebRequest -Uri $source1 -OutFile $file1 -Credential $credentials
Invoke-WebRequest -Uri $source2 -OutFile $file2 -Credential $credentials