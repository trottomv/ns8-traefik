*** Settings ***
Library    SSHLibrary

*** Test Cases ***
Check if traefik service is loaded correctly
    ${output}  ${rc} =    Execute Command    ssh -o StrictHostKeyChecking=no traefik1@localhost systemctl --user show --property=LoadState traefik
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    Should Be Equal As Strings    ${output}    LoadState=loaded
