activate() {
    if [ -f "./activate.sh" ]; then
        # Store current state before activation
        export _PROJECT_PREV_ALIASES=$(alias | cut -d'=' -f1 | tr '\n' ' ')
        export _PROJECT_PREV_FUNCTIONS=$(print -l ${(k)functions} | tr '\n' ' ')
        export _PROJECT_PREV_VARS=$(env | cut -d'=' -f1 | tr '\n' ' ')
        
        # Extract and store project templates
        export PROJECT_TEMPLATES=$(head -1 ./activate.sh | sed -n 's/# Combined project template: \(.*\)/\1/p')
        if [ -z "$PROJECT_TEMPLATES" ]; then
            export PROJECT_TEMPLATES=$(grep -m 1 "environment loaded:" ./activate.sh | sed -n 's/.*environment loaded: \(.*\)".*/\1/p')
        fi
        export PROJECT_ROOT="$(pwd)"
        
        # Source the activation script
        source ./activate.sh
        
        # Store what was added
        export _PROJECT_NEW_ALIASES=$(alias | cut -d'=' -f1 | tr '\n' ' ')
        export _PROJECT_NEW_FUNCTIONS=$(print -l ${(k)functions} | tr '\n' ' ')
        export _PROJECT_NEW_VARS=$(env | cut -d'=' -f1 | tr '\n' ' ')
    else
        echo "No activate.sh found in current directory"
        echo "Run 'init_project <template>' to create one"
    fi
}

deactivate() {
    if [ -z "$PROJECT_ROOT" ]; then
        echo "No project environment is currently activated"
        return 1
    fi
    
    # Function to get items that are in new but not in prev
    get_added_items() {
        local prev_items="$1"
        local new_items="$2"
        local -a prev_array new_array added_array
        
        prev_array=(${(z)prev_items})
        new_array=(${(z)new_items})
        
        for item in $new_array; do
            if [[ ! " ${prev_array[@]} " =~ " ${item} " ]]; then
                added_array+=($item)
            fi
        done
        
        echo "${added_array[@]}"
    }
    
    # Remove added aliases
    if [ -n "$_PROJECT_PREV_ALIASES" ] && [ -n "$_PROJECT_NEW_ALIASES" ]; then
        local added_aliases=$(get_added_items "$_PROJECT_PREV_ALIASES" "$_PROJECT_NEW_ALIASES")
        for alias_name in ${(z)added_aliases}; do
            # Skip internal aliases
            [[ "$alias_name" =~ ^_PROJECT_ ]] && continue
            unalias "$alias_name" 2>/dev/null
        done
    fi
    
    # Remove added functions
    if [ -n "$_PROJECT_PREV_FUNCTIONS" ] && [ -n "$_PROJECT_NEW_FUNCTIONS" ]; then
        local added_functions=$(get_added_items "$_PROJECT_PREV_FUNCTIONS" "$_PROJECT_NEW_FUNCTIONS")
        for func_name in ${(z)added_functions}; do
            # Skip internal functions and core project functions
            [[ "$func_name" =~ ^_PROJECT_ ]] && continue
            [[ "$func_name" =~ ^(activate|deactivate|init_project|create_template|list_templates|edit_template)$ ]] && continue
            unfunction "$func_name" 2>/dev/null
        done
    fi
    
    # Remove added environment variables
    if [ -n "$_PROJECT_PREV_VARS" ] && [ -n "$_PROJECT_NEW_VARS" ]; then
        local added_vars=$(get_added_items "$_PROJECT_PREV_VARS" "$_PROJECT_NEW_VARS")
        for var_name in ${(z)added_vars}; do
            # Skip internal tracking variables (we'll handle them separately)
            [[ "$var_name" =~ ^_PROJECT_ ]] && continue
            # Skip core project variables (we'll handle them separately)
            [[ "$var_name" =~ ^(PROJECT_TEMPLATES|PROJECT_ROOT)$ ]] && continue
            unset "$var_name"
        done
    fi
    
    # Clean up project variables
    unset PROJECT_TEMPLATES
    unset PROJECT_ROOT
    
    # Clean up tracking variables
    unset _PROJECT_PREV_ALIASES
    unset _PROJECT_PREV_FUNCTIONS
    unset _PROJECT_PREV_VARS
    unset _PROJECT_NEW_ALIASES
    unset _PROJECT_NEW_FUNCTIONS
    unset _PROJECT_NEW_VARS
    
    echo "✓ Project environment deactivated"
}

show_project() {
    if [ -z "$PROJECT_ROOT" ]; then
        echo "No project environment is currently activated"
        echo "Run 'activate' in a directory with activate.sh to load a project"
        return 1
    fi
    
    if [[ "$1" == "-c" ]]; then
        if [ -f "$PROJECT_ROOT/activate.sh" ]; then
            cat "$PROJECT_ROOT/activate.sh"
        else
            echo "activate.sh not found in $PROJECT_ROOT"
            return 1
        fi
        return 0
    fi
    
    echo "📦 Project Environment"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Root: $PROJECT_ROOT"
    [ -n "$PROJECT_TEMPLATES" ] && echo "Templates: $PROJECT_TEMPLATES"
    echo ""
    
    get_added_items() {
        local prev_items="$1"
        local new_items="$2"
        local -a prev_array new_array added_array
        
        prev_array=(${(z)prev_items})
        new_array=(${(z)new_items})
        
        for item in $new_array; do
            if [[ ! " ${prev_array[@]} " =~ " ${item} " ]]; then
                added_array+=($item)
            fi
        done
        
        echo "${added_array[@]}"
    }
    
    if [ -n "$_PROJECT_PREV_ALIASES" ] && [ -n "$_PROJECT_NEW_ALIASES" ]; then
        local added_aliases=$(get_added_items "$_PROJECT_PREV_ALIASES" "$_PROJECT_NEW_ALIASES")
        local -a alias_list
        for alias_name in ${(z)added_aliases}; do
            [[ "$alias_name" =~ ^_PROJECT_ ]] && continue
            alias_list+=($alias_name)
        done
        
        if [ ${#alias_list} -gt 0 ]; then
            echo "Aliases (${#alias_list}):"
            for alias_name in ${alias_list[@]}; do
                local alias_def=$(alias "$alias_name" 2>/dev/null | sed "s/^$alias_name=//")
                echo "  $alias_name → $alias_def"
            done
            echo ""
        fi
    fi
    
    if [ -n "$_PROJECT_PREV_FUNCTIONS" ] && [ -n "$_PROJECT_NEW_FUNCTIONS" ]; then
        local added_functions=$(get_added_items "$_PROJECT_PREV_FUNCTIONS" "$_PROJECT_NEW_FUNCTIONS")
        local -a func_list
        for func_name in ${(z)added_functions}; do
            [[ "$func_name" =~ ^_PROJECT_ ]] && continue
            [[ "$func_name" =~ ^(activate|deactivate|init_project|create_template|list_templates|edit_template|show_project)$ ]] && continue
            func_list+=($func_name)
        done
        
        if [ ${#func_list} -gt 0 ]; then
            echo "Functions (${#func_list}):"
            for func_name in ${func_list[@]}; do
                echo "  $func_name()"
            done
            echo ""
        fi
    fi
    
    if [ -n "$_PROJECT_PREV_VARS" ] && [ -n "$_PROJECT_NEW_VARS" ]; then
        local added_vars=$(get_added_items "$_PROJECT_PREV_VARS" "$_PROJECT_NEW_VARS")
        local -a var_list
        for var_name in ${(z)added_vars}; do
            [[ "$var_name" =~ ^_PROJECT_ ]] && continue
            [[ "$var_name" =~ ^(PROJECT_TEMPLATES|PROJECT_ROOT)$ ]] && continue
            var_list+=($var_name)
        done
        
        if [ ${#var_list} -gt 0 ]; then
            echo "Environment Variables (${#var_list}):"
            for var_name in ${var_list[@]}; do
                echo "  $var_name=${(P)var_name}"
            done
        fi
    fi
}
