[CmdletBinding(DefaultParameterSetName ='source')]
 
param(
  [Parameter(ParameterSetName='source', Mandatory, Position=0)]
  [System.Collections.IEnumerable] $Source = $null,
 
  [Parameter(ParameterSetName='source')]
  [Parameter(ParameterSetName='object')]
  [string] $Type = 'object',
 
  [Parameter(ParameterSetName='object', Mandatory, ValueFromPipeline, Position=0)]
  [psobject] $Object,
 
  [Parameter(ParameterSetName='object')]
  [string] $KeyField
)
 
BEGIN
{
  $hs = New-Object "System.Collections.Generic.HashSet[$Type]";
  if ($Source) { $Source |% { [void] $hs.Add($_); } }
}
 
PROCESS
{
  if ($KeyField)
  {
    [void] $hs.Add($Object.$KeyField);
  }
  else
  {
    [void] $hs.Add($Object);
  }
}
 
END
{
  # Look!  Magic! The ',' in this line prevents PowerShell returns the HashSet
  # (which we want) and not the *elements* (which we already had)... by default,
  # PowerShell expands any IEnumeralbe objects returned.
  return ,$hs;
}