# Codex Git Diff Guard

A small Windows workaround for repeated background Git rename scans observed in Codex Desktop. Unofficial and unaffiliated with OpenAI.

1. Extract the ZIP to a folder.
2. Double-click **Start Guard.cmd** to run the guard in the background.
3. Double-click **Stop Guard.cmd** before updating or removing the folder.

The guard checks new Git processes approximately every 250 ms and stops those whose command line matches the observed diff signature. Any tool issuing that same signature can be affected. Codex's Git change review can become incomplete while the guard runs. Stop the guard when you need that review.

Requires Windows PowerShell 5.1 and access to inspect processes running under your account. The download does not register itself for startup. If your Windows policy blocks downloaded scripts, review the extracted source and your organization's policy before running them.

This package contains only source files. It makes no network requests. It does not modify Git configuration, stage files, or uninstall Git.
