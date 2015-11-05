###Package manager(am)

$ pm list permis­sio­n-g­roups

Prints all known permission groups

$ pm list features

Prints all features of the system

$ pm list librar­ies

Prints all the libraries supported by current device

$ pm list users

Prints all users on system

$ pm path PACKAGE

Print the path to the APK of given PACKAGE

$ pm clear PACKAGE

Deletes all data associated with a package

$ pm enable PKG | COMPON­ENT

Enable given package or component (written as "­pac­kag­e/c­las­s")

$ pm disable PKG | COMPON­ENT

Disable given package or component (written as "­pac­kag­e/c­las­s")

$ pm grant PERMIS­SION

Grant permis­sions to applic­ations. Only optional permis­sions the applic­ation has declared can be granted.

$ pm revoke PERMIS­SION

Revoke permis­sions to applic­ations. Only optional permis­sions the applic­ation has declared can be revoked.

$ pm set-­per­mis­sio­n-e­nforced PERMISSION [true|­fal­se]

Specifies whether the given permission should be enforced.

$ pm trim­-caches DESIRE­D_F­REE­_SP­ACE

Trim cache files to reach given free space

$ pm crea­te-user USERNAME

Create new user with given USERNAME, printing the new user identifier of the user

$ pm remo­ve-user USER_ID

Remove the user with given USER_ID, deleting all data associated with that user

$ pm get-­max­-us­ers

Prints the maximum number of users supported by the device

###pm command: install

-l

Install package with forward lock

-r

Reinstall an existing app, keeping its data

-t

Allow test APKs to be installed

-i NAME

Specify the installer package name

-s

Install package on the shared mass storage (such as sdcard)

-f

Install package on internal system memory

-d

Allow version code downgrade

Usage: $ pm install [options] <PA­TH>

###pm command: uninstall

-k

Keep the data and cache direct­ories around after removal
Usage: $ pm unin­stall [options] <PA­CKA­GE>

###pm command: set-in­sta­ll-­loc­ation

Location Values

0

Auto - let system decide best location

1

Internal - internal device storage

2

External - install on external media

Usage: $ pm set-­ins­tal­l-l­ocation LOCATION

###pm command: get-in­sta­ll-­loc­ation

Return Values

0

Auto - system decides best location

1

Internal - internal device storage

2

External - install on external media

Usage: $ pm get-­ins­tal­l-l­oca­tion

###pm command: disabl­e-user

--user USER_ID

User to disable

Usage: $ pm disa­ble­-user [options] (PKG | COMPON­ENT)

###pm command : list packages

-f

See their associated file

-d

Only show disabled packages

-e

Only show enabled packages

-s

Only show system packages

-3

Only show third party packages

-i

See the installer for the packages

-u

Include uninst­alled packages

--user <US­ER_­ID>

User space to query

list packages [options] <FI­LTE­R>

###pm command : list permis­sions

-g

Organize by group

-f

Print all inform­ation

-s

Short summary

-d

Only list dangerous permis­sions

-u

Only list permis­sions users will see

Usage: $ pm list permis­sions [options] <GR­OUP­>

###pm command : list instru­men­tation

-f

List the APK file for the test package

Usage: $ pm list instru­men­tation [optio­ns]