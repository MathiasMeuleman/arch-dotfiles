WORKSPACES=$(swaymsg -t get_workspaces)
NAMES=$(echo $WORKSPACES | jq -r '.[] | "\(.name)"')

while IFS=' ' read -ra ADDR; do
    for i in "${ADDR[@]}"; do
        swaymsg 'move workspace $i to output right'
    done
done <<< "$NAMES"

