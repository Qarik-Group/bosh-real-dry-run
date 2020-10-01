#!/bin/bash

deployment=${1}
new_manifest="$(cat ${2})"
new_configs="$(bosh curl /configs | jq -r 'map(.content)[]' \
                    | spruce merge --multi-doc -)"

current_manifest="$(bosh -d ${deployment} manifest)"
current_configs="$(bosh curl /deployment_configs\?deployment=${deployment} \
                        | jq 'map(.config.id)[]' \
                        | xargs -I '{}' -L1 bosh curl /configs/{} \
                        | jq -r '.content' \
                        | spruce merge --multi-doc -)"

bosh diff-config --json \
     --from-content <(bosh int <(echo -e "${current_configs}\n${current_manifest}")) \
     --to-content <(bosh int <(echo -e "${new_configs}\n${new_manifest}")) \
     | jq -r '.Tables[0].Rows[0].diff'
