cp /opt/pulledpork-master/etc/*.conf /etc/snort/
if [ -z $OINKCODE ]; then 
    sed -i "19 s/^/#/" /etc/snort/pulledpork.conf; 
else 
    sed -i "s/<oinkcode>/$OINKCODE/g" /etc/snort/pulledpork.conf; 
fi
sed -i "s/rule_path=\/usr\/local/rule_path=/g" /etc/snort/pulledpork.conf \
    && sed -i "s/local_rules=\/usr\/local/local_rules=/g" /etc/snort/pulledpork.conf \
    && sed -i "s/sid_msg=\/usr\/local/sid_msg=/g" /etc/snort/pulledpork.conf \
    && sed -i "s/sid_msg_version=1/sid_msg_version=2/g" /etc/snort/pulledpork.conf \
    && sed -i "s/config_path=\/usr\/local/config_path=/g" /etc/snort/pulledpork.conf \
    && sed -i "s/distro=FreeBSD-8-1/distro=Ubuntu-12-04/g" /etc/snort/pulledpork.conf \
    && sed -i "s/black_list=\/usr\/local/black_list=/g" /etc/snort/pulledpork.conf \
    && sed -i "s/IPRVersion=\/usr\/local/IPRVersion=/g" /etc/snort/pulledpork.conf \
    && /usr/local/bin/pulledpork.pl -c /etc/snort/pulledpork.conf -l




