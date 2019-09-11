# ===========================================================================
#   FormatFileContent.ps1 ---------------------------------------------------
# ===========================================================================

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Format-IniContent  {

     <#
    .DESCRIPTION
        Searches for pattern '%(value)s' in specified content of a config file and replaces this pattern with the value of the referenced field or with the value of the corresponding system environment.

        [section]
        field-reference = value
        field-with-pattern-reference = %(field-reference)s\file-name
        field-with-pattern-environment = %(HOME)s\file-name

        Field 'field-with-pattern-reference' will be assigned the value 'value/file-name' and 'field-with-pattern-environment' gets the value 'C:\Users\User\file-name'.
    
    .PARAMETER Content

    .OUTPUTS
        System.Object. Formatted config content.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.Object])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Content from config file.")]
        [System.Object] $Content,

        [Parameter(Position=2, HelpMessage="Object with values for substitution.")]
        [System.Object] $Substitution
    )
   
    Process {

        # loop over all sections in config object
        $keys = $Content.Keys -split " "
        for($i=0; $i -lt $keys.Count; $i++  ) {
            $Content.($keys[$i]) = Format-FileContent -Content $Content.($keys[$i]) -Substitution $Substitution
        }

        return $Content
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Format-JsonContent  {

    <#
   .DESCRIPTION
       Searches for pattern '%(value)s' in specified content of a json file and replaces this pattern with the value of a referenced field or with the value of the corresponding system environment.

        {
            'field-reference' : 'value'
            'field-with-pattern-reference' = '%(field-reference)s\file-name'
            'field-with-pattern-environment' = '%(HOME)s\file-name'
        }

       Field 'field-with-pattern-reference' will be assigned the value 'value/file-name' and 'field-with-pattern-environment' gets the value 'C:\Users\User\file-name'.
   
   .PARAMETER Content

   .OUTPUTS
       System.Object. Formatted json content.
   #>

   [CmdletBinding(PositionalBinding)]
   
   [OutputType([System.Object])]

   Param(
       [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Content from json file.")]
       [System.Object[]] $Content,

        [Parameter(Position=2, HelpMessage="Object with values for substitution.")]
        [System.Object] $Substitution
   )
  
   Process {

        # loop over all elements in json object
        for($i=0; $i -lt $Content.Length; $i++) {
            $hashtable = ConvertTo-HashtableFromObject $Content[$i]
            $result = Format-FileContent -Content $hashtable -Substitution $Substitution
            $Content[$i] = ConvertTo-ObjectFromHashtable $result
        }

        return $Content
    }
}

#   function ----------------------------------------------------------------
# ---------------------------------------------------------------------------
function Format-FileContent  {
    <#

    .DESCRIPTION

    .PARAMETER Content

    .OUTPUTS
        System.Object. Formatted config content.
    #>

    [CmdletBinding(PositionalBinding)]
    
    [OutputType([System.Object])]

    Param(
        [Parameter(Position=1, Mandatory, ValueFromPipeline, HelpMessage="Content of a arbitrary file.")]
        [System.Object] $Content,

        [Parameter(Position=2, HelpMessage="Object with values for substitution.")]
        [System.Object] $Substitution
    )
   
    Process {

        # define regex string for the search of pattern '%(x)s'
        $pattern = "\%\(([a-z-_]+)\)s"
        $matches = @()

        # loop over all fields in a specific config section
        $keys_subst = ($Substitution  | Get-Member | Where-Object {$_.MemberType -eq "NoteProperty" -or $_.MemberType -eq "Property"} | Select-Object -ExpandProperty Name) -split " "
        $keys_sec = $Content.Keys -split " "
        for($j=0; $j -lt $keys_sec.Count; $j++ ) {
            $field = $keys_sec[$j]
            $field_content = $Content.($field)
            
            # get multiple matches of defined pattern in a field
            $match = [Regex]::Matches($field_content, $pattern, "IgnoreCase").Groups | Where-Object { $_.Name -eq 1} | Select-Object -ExpandProperty Value

            if ($match){
                # if there are matches each result will be stored and replaced with referenced field or corresponding environment variable
                $match | ForEach-Object{
                    $value = $Null
                    
                    # search for reference field and corresponding environment variable
                    if ($keys_sec -contains $_){
                        $value = $Content.($_)
                    }
                    elseif ($keys_subst -contains $_){
                        $value = $Substitution.($_)
                    } else {
                        $value = [System.Environment]::GetEnvironmentVariable($_)
                    }

                    # # store section, field and value of reference field
                    # $matches += [PSCustomObject] @{Section = $sec; Field = $_; Value = $value }

                    # replace the pattern in given field and store it in input content object
                    if ($value){
                        $Content.($field) = [Regex]::Replace($field_content, $pattern, $value, "IgnoreCase")
                    }
                }
            }
        }
        return $Content
    }
}