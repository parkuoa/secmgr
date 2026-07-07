# secmgr
**secmgr** is a command-line utility for tinkering with macOS's system authorization database. It allows you to modify the `system.login.console` right and its mechanisms (plugins, MFA, or directory services) that execute during the login process.

 It is intended to be as customizable as possible, letting you customize login behavior and inject your own logic without being locked into specific third-party frameworks or vendor-specific deployment screens.

## TL;DR
Put simple: your own authentication/login process, from scratch. Feed your own login flow, and your own UI.
You may add your own logic before the UI, during auth, or after the user logs in.

## Building
```bash
% make help

make <target>

targets:
  all/cli: build cli
  authbundle: build auth bundle from external AuthorizationBundle checkout
  clean: clean cli
  help: Show this help message
  ```

To build an authorization bundle:

```bash
AUTHBUNDLE=/path/to/AuthorizationBundle make authbundle
```

If the bundle uses secmgr's app settings, provide that path with `APP_CORE`:

```bash
AUTHBUNDLE=/path/to/AuthorizationBundle APP_CORE=/path/to/app_core make authbundle
```

The bundle must contain:
* `Info.plist`
* `core/LoginUI.swift`
* `core/AuthorizationPlugin.swift`
* `core/Mechanism.swift`

If using `APP_CORE`, that path must mandatorily contain:
* `SettingsManager.swift`

## CLI Guide

Some commands require `sudo` as you're working with system databases here. \
You may always use ```secmgr help``` for help.

### Basics
* `secmgr --print`: show current mechanisms for `system.login.console`.
* `secmgr --reset`: revert the login screen to default.
* `secmgr --apply`: apply the login mechanism configured by your authbundle.
* `secmgr --create-privileged`: use alongside ``--apply`` to give mechanism has elevated privileges.
* `secmgr --version`: print version.

### Customizing the Flow
You can stack mechanisms at specific stages of the authentication chain:
* `--prelogin`: runs before the login UI appears.
* `--preauth`: runs between the UI and the primary authentication check.
* `--postauth`: runs after the system confirms the user's credentials.

**Examples:**
```bash
sudo secmgr --apply "myLoginMech:login"
```
^ ``apply`` login mechanism. The authorization bundle will have to pick up on it (see submod examples/AuthorizationBundle/core/Mechanism.swift)

```bash
sudo secmgr --apply "secmgr:ui" --create-privileged --prelogin CustomMech:Something --postauth PostLogin:Setup
```
translates to:
```
Entry: system.login.console
   tries : 10000
   mechanisms:
      builtin:policy-banner
      CustomMech:Something <-- custom prelogin mechanism
      builtin:prelogin
      secmgr:ui <-- custom login mech (replacing loginwindow:login)
      secmgr:PowerControl,privileged <-- our privileged rights
      secmgr:CreateUser,privileged
      builtin:login-begin
      builtin:reset-password,privileged
      loginwindow:FDESupport,privileged
      builtin:forward-login,privileged
      builtin:auto-login,privileged
      builtin:authenticate,privileged
      PKINITMechanism:auth,privileged
      builtin:login-success
      loginwindow:success
      HomeDirMechanism:login,privileged
      HomeDirMechanism:status
      MCXMechanism:login
      CryptoTokenKit:login
      loginwindow:done
      PostLogin:Setup <-- post-auth mechanism
   comment : Login mechanism based rule.  Not for general use, yet.
   external:secmgr:ui|secmgr:PowerControl,privileged|secmgr:CreateUser,privileged
   version : 11
   shared : 1
   class : evaluate-mechanisms
```

## Acknowledgements
secmgr's functionality is derived from [`authchanger`](https://github.com/jamf/authchanger) v2.1.0 ([MIT License](./LICENSE)), which set the base for this project.
