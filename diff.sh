#!/bin/bash

deployment=${1}
new_manifest="$(cat ${2})"
new_configs="$(bosh curl /configs | jq -r 'map(.content)[]' \
                    | spruce merge --multi-doc -)"
new_variables="$(echo "credhub_variables:"; bosh curl "/deployments/${deployment}/variables" \
                    | jq -r 'map(.name)[]' \
                    | xargs -I '{}' -L1 credhub get --output-json -n {} \
                    | jq -r '"- \(.name)@\(.id)"')"

current_manifest="$(bosh -d ${deployment} manifest)"
current_configs="$(bosh curl /deployment_configs\?deployment=${deployment} \
                        | jq 'map(.config.id)[]' \
                        | xargs -I '{}' -L1 bosh curl /configs/{} \
                        | jq -r '.content' \
                        | spruce merge --multi-doc -)"
current_variables="$(bosh int <(bosh curl "/deployments/${deployment}/variables" \
                          | jq 'map("\(.name)@\(.id)") | {credhub_variables: .}'))"

bosh diff-config --json \
     --from-content <(bosh int <(echo -e "${current_configs}\n${current_manifest}\n${current_variables}")) \
     --to-content <(bosh int <(echo -e "${new_configs}\n${new_manifest}\n${new_variables}")) \
     | jq -r '.Tables[0].Rows[0].diff'
