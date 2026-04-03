#!/usr/bin/env bash
# lib/uuid.sh — Génère et persiste l'UUID de l'eBook dans config.yaml.
# Sourcé par build.sh. Requiert que info/warn/success soient définis.
# Usage : ensure_uuid "$CONFIG"  → exporte $UUID

_uuid_read_config() {
  local config="$1"
  python3 - "$config" <<'PYEOF'
import sys, re
path = sys.argv[1]
with open(path) as f:
    for line in f:
        m = re.match(r'^uuid:\s*"?([^"#\n]*)"?\s*$', line)
        if m:
            val = m.group(1).strip()
            print(val)
            break
PYEOF
}

_uuid_write_config() {
  local config="$1"
  local new_uuid="$2"
  python3 - "$config" "$new_uuid" <<'PYEOF'
import sys, re
config_path, new_uuid = sys.argv[1], sys.argv[2]
with open(config_path) as f:
    content = f.read()
content = re.sub(r'^uuid:.*$', f'uuid: "{new_uuid}"', content, flags=re.MULTILINE)
with open(config_path, 'w') as f:
    f.write(content)
PYEOF
}

ensure_uuid() {
  local config="$1"
  UUID=$(_uuid_read_config "$config")
  if [[ -z "$UUID" ]]; then
    UUID=$(python3 -c "import uuid; print(uuid.uuid4())")
    _uuid_write_config "$config" "$UUID"
    info "UUID généré et persisté dans config.yaml : $UUID"
  else
    info "UUID existant : $UUID"
  fi
  export UUID
}
