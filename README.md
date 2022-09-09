# Lancache-Pihole

Straight to the point - I made a script of the following guide ([link](https://oct8l.gitlab.io/posts/2021/297/scripting-lancache-dns-updates-with-pi-hole/)) on how to set up Pihole to forward DNS request to Lancache. This will allow you to continue to use the Pihole web gui with the benefits of Lancache. 

## Commands to use this script: 
    git clone https://github.com/Maddcow/Lancache-Pihole Lancache-Pihole
    cd Lancache-Pihole
    chmod +x lancache-pihole.sh
    sudo ./lancache-pihole.sh

## Lancache-pihole.sh
Performs the following actions:
1. Verifies if root access and if pihole is installed
2. Git clones the cache-domains repo
3. Creates a config.json file with the computers ip address.
4. Copies the lancache-dns-updates.sh to /root
5. Executes lancache-dns-updates.sh
6. Creates a cron job to run lancache-dns-updates.sh daily at 0030

## Lancache-dns-updates.sh
Performs the following actions: 
1. Copies cache-domains folder to a /tmp folder
2. Executes create-dnsmasq.sh from the /tmp folser - this is used to update cache-domains
3. Copies the newly created .conf files to /etc/dnsmasq.d/
4. Restarts the pihole-FTL service
5. Deletes the /tmp folder

## Acknowledgments
The inspiration for this script: [Scripting LanCache DNS updates with Pi-hole](https://oct8l.gitlab.io/posts/2021/297/scripting-lancache-dns-updates-with-pi-hole/).
