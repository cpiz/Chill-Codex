# Security Policy

## Supported Versions

Chill Codex is a small script project. Security fixes are made on the `main` branch.

## Reporting a Vulnerability

Please do not open a public issue for a security-sensitive report.

Use GitHub private vulnerability reporting if it is enabled for this repository. If it is not enabled, contact the maintainer through the GitHub account that owns this repository.

Helpful reports include:

- A clear description of the issue.
- Steps to reproduce.
- The affected file or command.
- Why the issue could cause unsafe file writes, unsafe deletion, command injection, privilege escalation, or misleading installation behavior.

## Security Boundaries

Chill Codex is designed to:

- Avoid `sudo`.
- Avoid modifying `/Applications/Codex.app`.
- Avoid patching, replacing, or re-signing Codex binaries.
- Refuse to uninstall an app bundle that does not contain the `chill-codex.generated` marker.

Changes that weaken these boundaries should be treated as security-sensitive.
