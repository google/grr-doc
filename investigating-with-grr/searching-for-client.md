# Searching For A Client

In order to start interfacing with a client, we first need to search for
it in the GUI. The GRR search bar is located at the top of the GUI and
allows you to search clients based on:

  - **Hostname:** "host:myhost-name"

  - **Fully Qualified Domain Name (FQDN):**
    "fqdn:myhost-name.organization.com", also prefixes of components,
    e.g. "fqdn:myhost-name.organization"

  - **MAC address:** "mac:eeffaabbccdd".

  - **IP address:** "ip:10.10.10.10", also prefixes of bytes "ip:10.10".
    Note that IP address is only collected during interrogate, which by
    default is run once per week.

  - **User:** "user:john"

  - **Label:** "label:testmachines". Finds hosts with a particular GRR
    label.

  - **Time of Last Data Update:** Time ranges can be given using
    "start\_date:" and "end\_date:" prefixes. The data is interpreted as
    a human readable timestamp. Examples: start\_date:2015,
    end\_date:2018-01-01.

All of these keywords also work without the type specifier, though with
less precision. For example "johnsmith" is both a user name and a
hostname name, it will match both.

Furthermore there are additional keywords such as OS and OS version. So
"Windows" will find all windows machines and "6.1.7601SP1" will match
Windows 7 machines with SP1 installed, "6.1.7601" will match those
without a service pack.

**By default, the search index only considers clients that have checked
in during the last six months.** To override this behavior, use an
explicit "start\_date:" directive as specified above.

## Interpreting Client Search Results

Searching returns a list of clients with the following information about
each one:

  - **Online**: An icon indicating whether the host is online or not.
    Green means online; yellow, offline for some time; red, offline for
    a long time.

  - **Subject**: The client IDentifier. This is how GRR refers
    internally to the system.

  - **Host**: The name of the host as the operating system sees it.

  - **Version**: The operating system version.

  - **MAC**: A list of MAC addresses of the system.

  - **Usernames**: A list of user accounts the operating system knows
    about (usually users local to the system or that have logged in).

  - **First Seen**: The time when the client first talked to the server.

  - **OS install time**: The timestamp for the operating system install.

  - **Labels**: Any labels applied to this client.

  - **Last Checkin**: The last time the client communicated with the
    server.

Once you’ve found the client you were looking for, click on it and both
the left panel and main panel will change to reflect you’re now working
with a client.
