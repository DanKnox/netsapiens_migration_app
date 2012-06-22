== Netsapiens Migration App

Provides web based one click customer domain migrations for the
[Netsapiens](http://www.netsapiens.com/) call platform. This app will move all information for a hosted VoIP customer from one
datacenter to another.

=== The Flow:

1. Export all database information including CDR records to a file.
2. SCP the database dumps to the new server and perform the import.
3. SCP all related filesystem data to the new server, Voicemail, Auto
   Attendants, etc.
4. Send a reboot to all of the phones when finished, effectively cutting
   them over to the new server when they come back online.

=== Setup

You should be able to edit the `migration_configuration.rb` initializer,
adding the credentials for each city and server you wish to migrate
to, then setting the primary server you are migrating from.

As the Netsapiens database structure changes frequently, this app may
take a small bit of fenagling. Please [contact
me](mailto://dknox@threedotloft.com) for help with setting it up if you
decide to use it and need assistance.

=== Development

This application was developed by Dan Knox and Kyle Whalen at Three Dot
Loft and released under the MIT license.
