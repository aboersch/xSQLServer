Describe 'CommonResourceHelper Unit Tests' {
    BeforeAll {
        # Import the CommonResourceHelper module to test
        $dscResourcesFolderFilePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) `
                                                -ChildPath 'DscResources'

        Import-Module -Name (Join-Path -Path $dscResourcesFolderFilePath `
                                       -ChildPath 'CommonResourceHelper.psm1') -Force
    }

    InModuleScope 'CommonResourceHelper' {
        Describe 'Get-LocalizedData' {
            $mockTestPath = {
                return $mockTestPathReturnValue
            }

            $mockImportLocalizedData = {
                $BaseDirectory | Should Be $mockExpectedLanguagePath
            }

            BeforeEach {
                Mock -CommandName Test-Path -MockWith $mockTestPath -Verifiable
                Mock -CommandName Import-LocalizedData -MockWith $mockImportLocalizedData -Verifiable
            }

            Context 'When loading localized data for Swedish' {
                $mockExpectedLanguagePath = 'sv-SE'
                $mockTestPathReturnValue = $true

                It 'Should call Import-LocalizedData with sv-SE language' {
                    Mock -CommandName Join-Path -MockWith {
                        return 'sv-SE'
                    } -Verifiable

                    { Get-LocalizedData -ResourceName 'DummyResource' } | Should Not Throw

                    Assert-MockCalled -CommandName Join-Path -Exactly -Times 2 -Scope It
                    Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
                }

                $mockExpectedLanguagePath = 'en-US'
                $mockTestPathReturnValue = $false

                It 'Should call Import-LocalizedData and fallback to en-US if sv-SE language does not exist' {
                    Mock -CommandName Join-Path -MockWith {
                        return $ChildPath
                    } -Verifiable

                    { Get-LocalizedData -ResourceName 'DummyResource' } | Should Not Throw

                    Assert-MockCalled -CommandName Join-Path -Exactly -Times 3 -Scope It
                    Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                    Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
                }

                Context 'When $ScriptRoot is set to a path' {
                    $mockExpectedLanguagePath = 'sv-SE'
                    $mockTestPathReturnValue = $true

                    It 'Should call Import-LocalizedData with sv-SE language' {
                        Mock -CommandName Join-Path -MockWith {
                            return 'sv-SE'
                        } -Verifiable

                        { Get-LocalizedData -ResourceName 'DummyResource' -ScriptRoot '.' } | Should Not Throw

                        Assert-MockCalled -CommandName Join-Path -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
                    }

                    $mockExpectedLanguagePath = 'en-US'
                    $mockTestPathReturnValue = $false

                    It 'Should call Import-LocalizedData and fallback to en-US if sv-SE language does not exist' {
                        Mock -CommandName Join-Path -MockWith {
                            return $ChildPath
                        } -Verifiable

                        { Get-LocalizedData -ResourceName 'DummyResource' -ScriptRoot '.' } | Should Not Throw

                        Assert-MockCalled -CommandName Join-Path -Exactly -Times 2 -Scope It
                        Assert-MockCalled -CommandName Test-Path -Exactly -Times 1 -Scope It
                        Assert-MockCalled -CommandName Import-LocalizedData -Exactly -Times 1 -Scope It
                    }
                }
            }

            Context 'When loading localized data for English' {
                Mock -CommandName Join-Path -MockWith {
                    return 'en-US'
                } -Verifiable

                $mockExpectedLanguagePath = 'en-US'
                $mockTestPathReturnValue = $true

                It 'Should call Import-LocalizedData with en-US language' {
                    { Get-LocalizedData -ResourceName 'DummyResource' } | Should Not Throw
                }
            }

            Assert-VerifiableMocks
        }

        Describe 'New-InvalidResultException' {
            Context 'When calling with Message parameter only' {
                It 'Should throw the correct error' {
                    $mockErrorMessage = 'Mocked error'

                    { New-InvalidResultException -Message $mockErrorMessage } | Should Throw $mockErrorMessage
                }
            }

            Context 'When calling with both the Message and ErrorRecord parameter' {
                It 'Should throw the correct error' {
                    $mockErrorMessage = 'Mocked error'
                    $mockExceptionErrorMessage = 'Mocked exception error message'

                    $mockException = New-Object System.Exception $mockExceptionErrorMessage
                    $mockErrorRecord = New-Object System.Management.Automation.ErrorRecord $mockException, $null, 'InvalidResult', $null

                    { New-InvalidResultException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } | Should Throw ('System.Exception: {0} ---> System.Exception: {1}' -f $mockErrorMessage, $mockExceptionErrorMessage)
                }
            }

            Assert-VerifiableMocks
        }

        Describe 'New-ObjectNotFoundException' {
            Context 'When calling with Message parameter only' {
                It 'Should throw the correct error' {
                    $mockErrorMessage = 'Mocked error'

                    { New-ObjectNotFoundException -Message $mockErrorMessage } | Should Throw $mockErrorMessage
                }
            }

            Context 'When calling with both the Message and ErrorRecord parameter' {
                It 'Should throw the correct error' {
                    $mockErrorMessage = 'Mocked error'
                    $mockExceptionErrorMessage = 'Mocked exception error message'

                    $mockException = New-Object System.Exception $mockExceptionErrorMessage
                    $mockErrorRecord = New-Object System.Management.Automation.ErrorRecord $mockException, $null, 'InvalidResult', $null

                    { New-ObjectNotFoundException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } | Should Throw ('System.Exception: {0} ---> System.Exception: {1}' -f $mockErrorMessage, $mockExceptionErrorMessage)
                }
            }

            Assert-VerifiableMocks
        }

        Describe 'New-InvalidOperationException' {
            Context 'When calling with Message parameter only' {
                It 'Should throw the correct error' {
                    $mockErrorMessage = 'Mocked error'

                    { New-InvalidOperationException -Message $mockErrorMessage } | Should Throw $mockErrorMessage
                }
            }

            Context 'When calling with both the Message and ErrorRecord parameter' {
                It 'Should throw the correct error' {
                    $mockErrorMessage = 'Mocked error'
                    $mockExceptionErrorMessage = 'Mocked exception error message'

                    $mockException = New-Object System.Exception $mockExceptionErrorMessage
                    $mockErrorRecord = New-Object System.Management.Automation.ErrorRecord $mockException, $null, 'InvalidResult', $null

                    { New-InvalidOperationException -Message $mockErrorMessage -ErrorRecord $mockErrorRecord } | Should Throw ('System.InvalidOperationException: {0} ---> System.Exception: {1}' -f $mockErrorMessage, $mockExceptionErrorMessage)
                }
            }

            Assert-VerifiableMocks
        }

        Describe 'New-InvalidArgumentException' {
            Context 'When calling with both the Message and ArgumentName parameter' {
                It 'Should throw the correct error' {
                    $mockErrorMessage = 'Mocked error'
                    $mockArgumentName = 'MockArgument'

                    { New-InvalidArgumentException -Message $mockErrorMessage -ArgumentName $mockArgumentName } | Should Throw ('Parameter name: {0}' -f $mockArgumentName)
                }
            }

            Assert-VerifiableMocks
        }
    }
}
