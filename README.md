# bootstrappers
Scripts to set up a machine.

## Windows
To bootstrap Windows run the following command in an elevated PowerShell prompt:
```PowerShell
PowerShell -ExecutionPolicy Bypass -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/mcsitter/bootstrappers/master/windows/bootstrap.ps1' -UseBasicParsing | Invoke-Expression"
```
