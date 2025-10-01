$LangCode = "de-DE"  # Replace with your desired language code (e.g., en-US for English, de-DE for German)
Install-Language -Language $LangCode

Set-WinUILanguageOverride -Language "de-DE"  # Replace with the desired language code

Set-WinUILanguageOverride -Language "de-DE"  # Change "de-DE" to the desired language
Set-WinUserLanguageList "de-DE"
Set-WinSystemLocale "de-DE"
Set-Culture "de-DE"

Restart-Computer

