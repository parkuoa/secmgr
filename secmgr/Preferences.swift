/*
    Preferences.swift
    secmgr

    Copyright © 2026 parkuoa
    Derived from authchanger 2.1.0 (Copyright © 2017 Joel Rennich).
*/

import Foundation

class Preferences {
    
    // New Hotness -Johan
    // very awesome thanks
    
    let version = "1.0.0"
    static let kDefaultsMech = "defaultMechs"
    static let kDefaultMechs1014And15 = "defaultMechs10-14And10-15"
    static let kDefaultMechs1013 = "defaultMechs10-13"
    let Apply = [
        "impactedEntries": ["system.login.console"],
        "frontMechs": [],
        "endMechs": [],
        "notifyMech": []
    ]
    
    let Reset = [
        "impactedEntries": ["system.login.console"],
        kDefaultsMech : ["builtin:policy-banner", "builtin:prelogin", "loginwindow:login", "builtin:login-begin", "builtin:reset-password,privileged", "loginwindow:FDESupport,privileged", "builtin:forward-login,privileged", "builtin:auto-login,privileged", "builtin:authenticate,privileged", "PKINITMechanism:auth,privileged", "builtin:login-success", "loginwindow:success", "HomeDirMechanism:login,privileged", "HomeDirMechanism:status", "MCXMechanism:login", "CryptoTokenKit:login", "loginwindow:done"],
        kDefaultMechs1014And15 : ["builtin:policy-banner", "loginwindow:login", "builtin:login-begin", "builtin:reset-password,privileged", "loginwindow:FDESupport,privileged", "builtin:forward-login,privileged", "builtin:auto-login,privileged", "builtin:authenticate,privileged", "PKINITMechanism:auth,privileged", "builtin:login-success", "loginwindow:success", "HomeDirMechanism:login,privileged", "HomeDirMechanism:status", "MCXMechanism:login", "CryptoTokenKit:login", "loginwindow:done"],
        kDefaultMechs1013 : ["builtin:policy-banner", "loginwindow:login", "builtin:login-begin", "builtin:reset-password,privileged", "builtin:forward-login,privileged", "builtin:auto-login,privileged", "builtin:authenticate,privileged", "PKINITMechanism:auth,privileged", "builtin:login-success", "loginwindow:success", "loginwindow:FDESupport,privileged", "HomeDirMechanism:login,privileged", "HomeDirMechanism:status", "MCXMechanism:login", "CryptoTokenKit:login", "loginwindow:done"]
    ]
    
    func show_main_help() {
        let help = """
        secmgr v\(self.version)
        based on authchanger v2.1.0

        secmgr is a utility to help you manage the authorization database used by macOS to determine how the login process progresses.
        
        Usage:
            secmgr <command> [options]
            secmgr help <command>
            secmgr <command> --help

        Commands:
            help                  show this help message
            --version             print version
            --reset               reset authdb to default

            --apply                   apply a custom login mechanism
            	--create-privileged   add auxiliary privileged mechanisms
            	--prelogin            set pre-login mechanisms
            	--preauth             set pre-authentication mechanisms
            	--postauth            set post-authentication mechanisms

            --print               print current authorization mechanisms
            --debug               dry run of changes showing what would've happened
            --customrule          manage custom authorization rules
        """
        print(help)
    }
    
    func show_command_help(_ command: String) {
        let cmd = command.lowercased().replacingOccurrences(of: "-", with: "")
        
        switch cmd {
        case "reset":
            print("""
            secmgr --reset
            
            Usage: secmgr --reset [--debug]
            
            Reset authdb to default.
            
            Options:
                --debug    Dry run without making changes
            
            Examples:
                secmgr --reset
                secmgr --reset --debug
            """)
            
        case "apply":
            print("""
            secmgr --apply [mechanism]
            
            Usage: secmgr --apply [<mechanism>] [--debug] [--prelogin <mechs>] [--preauth <mechs>] [--postauth <mechs>] [--create-privileged]
            
            Apply given login mechanism
            
            Options:
                --debug              Dry run without making changes
                --create-privileged  Add auxiliary privileged mechanisms for login
                --prelogin <mechs>   Mechanisms before UI is shown
                --preauth <mechs>    Mechanisms between UI and authentication
                --postauth <mechs>   Mechanisms after authentication
            
            Examples:
                secmgr --apply
                secmgr --apply "customlogin:login"
                secmgr --apply "customlogin:login" --create-privileged
                secmgr --apply "customlogin:login" --prelogin CustomMechanism:Something
            """)
            
        case "print":
            print("""
            secmgr --print
            
            Usage: secmgr --print
            
            Prints the current authorization mechanisms for system.login.console
            
            Example:
                secmgr --print
            """)
            
        case "debug":
            print("""
            secmgr --debug
            
            Usage: secmgr --debug <command>
            
            Performs a dry run of the specified command without making changes.
            
            Examples:
                secmgr --debug --reset
                secmgr --debug --apply --prelogin CustomMechanism:Something
            """)
            
        case "customrule":
            print("""
            secmgr --customrule
            
            Usage:
                secmgr --customrule <rule> print
                secmgr --customrule <rule> mechanisms <mechs...> [--debug]
                secmgr --customrule <rule> rules <rule-name> [--debug]
            
            Manages custom authorization rules.
            """)
            
        case "prelogin":
            print("""
            secmgr --prelogin
            
            Usage: secmgr --prelogin <mechanisms...> [--debug]
            
            Sets mechanisms to be used before the UI is shown.
            
            Examples:
                secmgr --prelogin CustomMechanism:Something
                secmgr --prelogin "CustomAuth:Check" --debug
            """)
            
        case "preauth":
            print("""
            secmgr --preauth
            
            Usage: secmgr --preauth <mechanisms...> [--debug]
            
            Sets mechanisms to be used between login UI and authentication.
            
            Examples:
                secmgr --preauth CustomAuth:Check
                secmgr --preauth "CustomAuth:Check" --debug
            """)
            
        case "postauth":
            print("""
            secmgr --postauth
            
            Usage: secmgr --postauth <mechanisms...> [--debug]
            
            Sets mechanisms to be used after authentication.
            
            Examples:
                secmgr --postauth PostLogin:Setup
                secmgr --postauth "PostLogin:Setup" --debug
            """)
            
        default:
            print("Unknown command: \(command)\n")
            print("Run 'secmgr help' for help")
        }
    }
}