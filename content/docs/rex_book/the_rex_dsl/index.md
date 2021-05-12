---
title: The Rex DSL
date: 2019-09-11
---

* [Authentication](/docs/rex_book/the_rex_dsl/authentication.html)  
  Rex is capable to use two different SSH implementations under the hood: Net::SSH2 which is default on Windows, and the combination of Net::OpenSSH and Net::SFTP::Foreign on other platforms.

* [Grouping servers](/docs/rex_book/the_rex_dsl/grouping_servers.html)  
  Rex offers you a powerful way to group your servers. In this chapter you will learn the basics and also learn how to use databases to generate groups.

* [Using Environments](/docs/rex_book/the_rex_dsl/using_environments.html)  
  With environments it is easy to group your servers depending on the maturity of your configuration or your code. You can create environments for dev, staging and production machines. There is no limit for environments, so you can create as much as you need.

* [Using templates](/docs/rex_book/the_rex_dsl/using_templates.html)  
  A template is a text file containing special variables or perl code inside it. So with this technique you can generate dynamic configuration files. For example if you want to configure apache only to listen on a special ethernet device (eth0 for example) templates are what you need.
