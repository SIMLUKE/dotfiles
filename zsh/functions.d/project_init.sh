# Project initialization system
# Allows you to quickly setup new projects with predefined templates


init_project() {
    local template_dir="$HOME/.config/zsh/project_templates"

    if [ -z "$1" ]; then
        echo "Available templates:"
        for template in "$template_dir"/*.sh; do
            [ -f "$template" ] && echo "  - $(basename "$template" .sh)"
        done
        echo "\nUsage: init_project <template_name> [template_name2 ...]"
        echo "Example: init_project docker node    # Combine docker and node templates"
        return 1
    fi

    local -a templates_to_merge
    local -a template_names
    for template_name in "$@"; do
        local template="$template_dir/$template_name.sh"
        if [ ! -f "$template" ]; then
            echo "Template '$template_name' not found!"
            echo "Available templates:"
            for t in "$template_dir"/*.sh; do
                [ -f "$t" ] && echo "  - $(basename "$t" .sh)"
            done
            return 1
        fi
        templates_to_merge+=("$template")
        template_names+=("$template_name")
    done

    if [ -f "./activate.sh" ]; then
        echo "activate.sh already exists in this directory."
        read "response?Overwrite? (y/N): "
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Aborted."
            return 1
        fi
    fi

    echo "# Combined project template: ${template_names[*]}" > ./activate.sh
    echo "# Generated on $(date)" >> ./activate.sh
    echo "" >> ./activate.sh

    for i in {1..$#templates_to_merge}; do
        local template="${templates_to_merge[$i]}"
        local name="${template_names[$i]}"
        echo "# ============================================" >> ./activate.sh
        echo "# Template: $name" >> ./activate.sh
        echo "# ============================================" >> ./activate.sh
        echo "" >> ./activate.sh

        grep -v "^echo.*environment loaded" "$template" >> ./activate.sh
        echo "" >> ./activate.sh
    done

    echo "echo \"✓ Project environment loaded: ${template_names[*]}\"" >> ./activate.sh
    chmod +x "./activate.sh"

    if [ ${#template_names} -eq 1 ]; then
        echo "✓ Project initialized with template: ${template_names[1]}"
    else
        echo "✓ Project initialized with templates: ${template_names[*]}"
    fi
    
    echo "✓ Created activate.sh in current directory"
    echo "\nRun 'activate' to load project-specific aliases and functions"

    read "response?Activate now? (Y/n): "
    if [[ ! "$response" =~ ^[Nn]$ ]]; then
        source $HOME/.config/zsh/functions.d/project_functions.sh
        activate
        echo "✓ Project environment activated"
    fi
}

create_template() {
    local template_dir="$HOME/.config/zsh/project_templates"

    if [ -z "$1" ]; then
        echo "Usage: create_template <template_name>"
        return 1
    fi

    local template="$template_dir/$1.sh"

    if [ -f "$template" ]; then
        echo "Template '$1' already exists!"
        return 1
    fi

    cat >"$template" <<'EOF'
# Project template - customize this file with your aliases and functions

# Example aliases
# alias build='echo "Add your build command here"'
# alias test='echo "Add your test command here"'

# Example function
# deploy() {
#     echo "Add your deploy logic here"
# }

echo "Project environment loaded: replace_me"
EOF

    sed -i "s/replace_me/$1/g" "$template"

    echo "✓ Created template: $1"
    echo "✓ Edit it at: $template"

    read "response?Edit template now? (Y/n): "
    if [[ ! "$response" =~ ^[Nn]$ ]]; then
        ${EDITOR:-nvim} "$template"
    fi
}

list_templates() {
    local template_dir="$HOME/.config/zsh/project_templates"

    echo "Available project templates:\n"
    for template in "$template_dir"/*.sh; do
        if [ -f "$template" ]; then
            local name=$(basename "$template" .sh)
            echo "📦 $name"
            # Show first comment line if it exists
            local desc=$(grep -m 1 "^#" "$template" | sed 's/^# //')
            [ -n "$desc" ] && echo "   $desc"
            echo ""
        fi
    done
}

_init_project_completion() {
    local template_dir="$HOME/.config/zsh/project_templates"
    local -a templates descriptions

    for template in "$template_dir"/*.sh(N); do
        local name=$(basename "$template" .sh)
        local desc=$(grep -m 1 "^#" "$template" | sed 's/^# //')

        if [ -z "$desc" ]; then
            desc="$name project template"
        fi

        templates+=("$name:$desc")
    done

    # Support multiple template selection
    _describe -t templates 'template' templates && return 0
}

# Completion function for create_template
_create_template_completion() {
    _message "new template name"
}

# Function to edit existing template
edit_template() {
    local template_dir="$HOME/.config/zsh/project_templates"
    
    if [ -z "$1" ]; then
        echo "Available templates to edit:"
        for template in "$template_dir"/*.sh; do
            [ -f "$template" ] && echo "  - $(basename "$template" .sh)"
        done
        echo "\nUsage: edit_template <template_name>"
        return 1
    fi
    
    local template="$template_dir/$1.sh"
    
    if [ ! -f "$template" ]; then
        echo "Template '$1' not found!"
        return 1
    fi
    
    ${EDITOR:-nvim} "$template"
}

# Completion function for edit_template (reuse init_project completion)
_edit_template_completion() {
    _init_project_completion
}

# Register completions
compdef _init_project_completion init_project
compdef _create_template_completion create_template
compdef _edit_template_completion edit_template
