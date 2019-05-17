---
title: Rex Book (work in progress)
---

* [Infrastructure](/docs/rex_book/infrastructure/index.html)  

    * [SSH as an agent](/docs/rex_book/infrastructure/ssh_as_an_agent.html)  
      To setup an environment to work with Rex you don't have to do much. You have to install Rex on your workstation or a central administration server. For most distributions you'll find packages on the package server.

    * [Version Control with Git](/docs/rex_book/infrastructure/version_control_with_git.html)  
      We recommend you to use a version control system for your development. Especially if you're working in a team it will bring you many advantages.

    * [Example of a complete Rex code infrastructure](/docs/rex_book/infrastructure/example_of_a_complete_rex_code_infrastructure.html)  
      For maintainable and reusable code it is important to start with the right infrastructure choices and tools. In this chapter you will learn how to setup and design your project to achieve this.

* [The Rex DSL](/docs/rex_book/the_rex_dsl/index.html)  

    * [Authentication](/docs/rex_book/the_rex_dsl/authentication.html)  
      Rex is capable to use two different SSH implementations under the hood: Net::SSH2 which is default on Windows, and the combination of Net::OpenSSH and Net::SFTP::Foreign on other platforms.

    * [Grouping servers](/docs/rex_book/the_rex_dsl/grouping_servers.html)  
      Rex offers you a powerfull way to group your servers. In this chapter you will learn the basics and also learn how to use databases to generate groups.

    * [Using Environments](/docs/rex_book/the_rex_dsl/using_environments.html)  
      With environments it is easy to group your servers depending on the maturity of your configuration or your code. You can create environments for dev, staging and production machines. There is no limit for environments, so you can create as much as you need.

    * [Using templates](/docs/rex_book/the_rex_dsl/using_templates.html)  
      A template is a text file containing special variables or perl code inside it. So with this technique you can generate dynamic configuration files. For example if you want to configure apache only to listen on a special ethernet device (eth0 for example) templates are what you need.

* [Writing Modules](/docs/rex_book/writing_modules/index.html)  

    * [Getting information of the environment](/docs/rex_book/writing_modules/getting_information_of_the_environment.html)  
      Often you need to know some things of the environment where you are currently connected. For example if you need to install apache on Debian and CentOS you have to provide different packages names.

    * [Writing custom resources](/docs/rex_book/writing_modules/writing_custom_resources.html)  
      Resoures are the units that are responsible to manage your configurations.

* [Working with Files and Packages](/docs/rex_book/working_with_files_and_packages/index.html)  

    * [Working with Files](/docs/rex_book/working_with_files_and_packages/working_with_files.html)  
      One task in configuration management is managing files and keeping them in a consistant state. Rex gives you some easy to use functions to work with files.

    * [Installing Packages](/docs/rex_book/working_with_files_and_packages/installing_packages.html)  
      Installing packages is easy. You can use the pkg function for this.

* [Managing Datacenters and the Cloud](/docs/rex_book/managing_datacenters_and_the_cloud/index.html)  

    * [Deploying OpenLDAP and SSSD](/docs/rex_book/managing_datacenters_and_the_cloud/deploying_openldap_and_sssd.html)  
      OpenLDAP (http://www.openldap.org/) is an open source directory server widely used for account management. It is easy to setup and administrate. There are also some Webfrontends like http://phpldapadmin.sourceforge.net/ and https://www.ldap-account-manager.org/lamcms/. SSSD (https://fedorahosted.org/sssd/) is the acronym for System Security Services Daemon. With its help it is possible to to authenticate your linux users against an OpenLDAP directory server with some nifty additions like offline support.
