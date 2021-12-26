#!/bin/bash

#function to validate ipv4  address 
is_ipv4()
{
    #ipv4 regex
    if [[ $1 =~ ^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$ ]] ; then
        echo "true"
    else
        echo "false"
    fi

}

#write warning message to current shell 
write_warning()
{
    shell=$( echo $SHELL |  awk -F"/" '{print $NF}')
    if [ "$shell" == "bash" ] ; then
        echo "echo 'something wrong in IP'" >> $HOME/.bashrc
    elif [ "$shell" == "zsh" ] ; then
        echo "echo 'something wrong in IP'" >> $HOME/.zshrc
    elif [ "$shell" == "ksh" ] ; then
        echo "echo 'something wrong in IP'" >> $HOME/.kshrc
    elif [ "$shell" == "csh" ] ; then
        echo "echo 'something wrong in IP'" >> $HOME/.cshrc
    elif [ "$shell" == "tcsh" ] ; then
        echo "echo 'something wrong in IP'" >> $HOME/.tcshrc
    elif [ "$shell" == "fish" ] ; then
        echo "echo 'something wrong in IP'" >> $HOME/.config/fish/config.fish
    fi
}

#get public ipv4 address
get_pub_ip()
{
    pub_ip=$(curl -s https://api.ipify.org)
    if [ "$(is_ipv4 $pub_ip)" == "true" ]  ; then
        echo $pub_ip
    else
        write_warning
        echo "something wrong in IP"
    fi
}

after_ip_changed()
{
    #put everything you'd like to do after the IP is changed like mapping domains, whitelisting your remote DB, etc.
    echo "after ip changed"
}


ip_file=$HOME/.pubip
if [ -f $ip_file ] ; then
    ip=$(cat $ip_file)
    public_ip=$(get_pub_ip)
    if [ "$ip" != "$public_ip" ] ; then
        echo $public_ip > $ip_file
        echo "IP changed"
        after_ip_changed
    else
        echo "IP not changed"
    fi
else
    public_ip=$(get_pub_ip)
    echo $public_ip  > $ip_file
    echo "IP is $public_ip and written to file"
    after_ip_changed
fi
