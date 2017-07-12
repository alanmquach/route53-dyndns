#!/bin/bash

rm -rf /root/dns.json

echo '{' >> /root/dns.json
echo '    "Changes": [' >> /root/dns.json
echo '        {' >> /root/dns.json
echo '            "Action": "UPSERT",' >> /root/dns.json
echo '            "ResourceRecordSet": {' >> /root/dns.json
echo '                "ResourceRecords": [' >> /root/dns.json
echo '                    {' >> /root/dns.json

echo "                        \"Value\": \"${ROUTE53_IP_ADDR}\"" >> /root/dns.json

echo '                    }' >> /root/dns.json
echo '                ],' >> /root/dns.json

echo "                \"Name\": \"${ROUTE53_HOSTNAME}\"," >> /root/dns.json

echo '                "TTL": 300,' >> /root/dns.json
echo '                "Type": "A"' >> /root/dns.json
echo '            }' >> /root/dns.json
echo '        }' >> /root/dns.json
echo '    ],' >> /root/dns.json
echo '    "Comment": "Updating dynamically"' >> /root/dns.json
echo '}' >> /root/dns.json

cat /root/dns.json

rsync -a /tmp/dotaws/ ~/.aws

/usr/local/bin/aws route53 change-resource-record-sets --hosted-zone-id "${ROUTE53_HOSTED_ZONE_ID}" --change-batch file:///root/dns.json

