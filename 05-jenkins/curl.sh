#!/bin/bash
token=$(curl -i -X POST -H "Content-Type: application/json" -d '{
    "auth": {
        "identity": {
            "methods": [
                "password"
            ],
            "password": {
                "user": {
                    "name": "xxxxx",
                    "password": "xxxxxxxxxxxxx",
                    "domain": {
                        "name": "xxxxxxxxxxxx"
                    }
                }
            }
        }
    }
}'  https://iam.myhuaweicloud.com/v3/auth/tokens   |grep  X-Subject-Token   |sed -n 's/.*X-Subject-Token: //p')


urls=\"https://static.ragnarokrevival.com/jpa-client\"
xx=$urls

curl -X POST -H "Content-Type: application/json" -H "X-Auth-Token: ${token}" -d  '{
  "refresh_task" : {
    "type" : "file",
    "urls" : [ "url1","url2" ]
  }
}'  https://cdn.myhuaweicloud.com/v1.0/cdn/content/refresh-tasks?enterprise_project_id=all
