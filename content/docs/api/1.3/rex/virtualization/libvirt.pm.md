-   [NAME](#NAME)
-   [DESCRIPTION](#DESCRIPTION)
-   [SYNOPSIS](#SYNOPSIS)

# NAME

Rex::Virtualization::LibVirt - LibVirt Virtualization Module

# DESCRIPTION

With this module you can manage LibVirt.

# SYNOPSIS

     use Rex::Commands::Virtualization;
       
     set virtualization => "LibVirt";
       
     print Dumper vm list => "all";
     print Dumper vm list => "running";
       
     vm destroy => "vm01";
       
     vm delete => "vm01"; 
        
     vm start => "vm01";
       
     vm shutdown => "vm01";
       
     vm reboot => "vm01";
       
     vm option => "vm01",
           max_memory => 1024*1024,
           memory    => 512*1024;
              
     print Dumper vm info => "vm01";
       
     # creating a vm on a kvm host
     vm create => "vm01",
        storage    => [
          {  
            file  => "/mnt/data/libvirt/images/vm01.img",
            dev   => "vda",
          }  
        ];  
         
     print Dumper vm hypervisor => "capabilities";
