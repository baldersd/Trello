#csv
Clear-Variable json,lists -ErrorAction SilentlyContinue
$csv = "C:\Documents\Trello\trellocsvproj.csv"
Remove-Item $csv -Force -ErrorAction SilentlyContinue

#AUTH objects
$trellokey ='xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$secretkey ='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

#GET functions for sub objects like members and checklists
Function Trello-Get($t, $tArg){
    if ($tArg) {
    $trequest = $t+$tArg
    $tjson = Invoke-RESTMethod $trequest
    Return $tjson
    } else {
    $trequest = $t
    $tjson = Invoke-RESTMethod $trequest
    Return $tjson
    }
}

#GET NEW TOKEN
#$url="https://trello.com/1/authorize?key=$trellokey&name=CSI&expiration=never&response_type=token"
#$R = Invoke-WebRequest -URI $url
# Call the function and get the token.
#$R.AllElements | where {$_.innerhtml -like "*=*"}
#$token = @($R.ParsedHtml.getElementsByTagName("input")) | Where {$_.name -eq "requestkey"} | Select value
##still needs to work out login bit to work.

$token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$endpoint = "https://api.trello.com/1/boards/"
#only open cards
#$board = "58ac1187ed8338ed221dc71d?lists=open&cards=open"
#all cards
$board = "58a57a0bf3e09ba23e2b7720?lists=open&cards=all"
$auth = "&key=$trellokey&token=$token"
$auth2 = "?key=$trellokey&token=$token"
#$auth = "&key=$trellokey&token=$token.value"
$request = $endpoint + $board + $auth
$json = Invoke-RESTMethod $request
$lists = @{}
$json.lists | % {$lists.add($_.id, $_.name)}
$json.cards | select @{name="List"; expression={$lists[$_.idList]}},`
    #id,checkItemStates,descData,idBoard,idMembersVoted,,anualCoverAttachment,pos,shortLink,idAttachmentCover
    @{name="Card Name"; expression={$_.name}},`
     closed,desc,
      @{name="dateLastActivity"; expression={`
        $_.dateLastActivity -replace "T"," " -replace "Z",""
        }
        },`    
        #@{name="idMembers"; expression={foreach($idMember in $_.idMembers){$idMember}}},`
          #@{name="idLabels"; expression={foreach($idlabel in $_.idlabels){$idlabel}}},`
            @{name="Members"; expression={`            
                foreach ($mbr in (Trello-Get "https://api.trello.com/1/cards/$($_.id)/members/$auth2").fullName){
                     "[$($mbr)]"
                    }
                }
                },`
              @{name="Labels"; expression={`
                foreach ($lbl in $_.labels){
                 "[$($lbl.name)]"
                }
                }
                },`    
                @{name="Badges:Comments"; expression={$_.badges.comments}},`
                @{name="Badges:Attachments"; expression={$_.badges.attachments}},`
                @{name="Badges:checkItems"; expression={$_.badges.checkItems}},`
                @{name="Badges:checkItemsChecked"; expression={$_.badges.checkItemsChecked}},`
                @{name="Badges:subscribed"; expression={$_.badges.subscribed}},`
                  #@{name="idChecklists"; expression={foreach($idCL in $_.idChecklists){$idCL}}},`
                     @{name="Checklists"; expression={`
                      if($_.idChecklists -eq ""){ 
                        "No checklists"
                        } else {
                                foreach ($cl in ((Trello-Get "https://api.trello.com/1/cards/$($_.id)/checklists/$auth2").checkItems)){
                                 "[$($cl.state),$($cl.name)]`n"
                                }                                                   
                        }
                       }
                      },`
                        dueComplete,due,shortUrl,subscribed,url,idShort | Export-CSV -path $csv -NoClobber -NoTypeInformation -Force
                        #Where-Object {$_.closed -ne "TRUE"}

#FUNCTION SEND LOCAL MAPI EMAIL#
# Outlook Connection
$Outlook | Clear-Variable -ErrorAction SilentlyContinue
$Outlook = New-Object -ComObject Outlook.Application
	$Body = "<html><style>html{font-family:verdana;}</style><h1>Active Projects</h1>"
    [datetime]$UK = Get-Date
    $dateUK = $UK.ToShortDateString()
    $Body += "Report date: $dateUK<br/>"
    $Body += "<h2 style='color:navy;'>All Project Activities (attached).</h2>"
    $Body += "Trello Board: https://trello.com/b/AuSOXC9g/my-projects"
    $Body += "<p>&nbsp;</p>"  
	$To = "daniel@acme.com"
	$Subject = "Trello Status Report | Active Projects | $dateUK"
	$Mail = $Outlook.CreateItem(0)
	$Mail.To = $To
	$Mail.Subject = $Subject
	$Mail.HTMLBody = $Body + "</html>"
    $Mail.Importance = 2
    $Mail.Attachments.Add($csv)
	$Mail.Send()
