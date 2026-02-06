#!/usr/bin/env python3
"""
Check freshness of all skills in a directory.

Usage:
    python check_freshness.py [skills_directory]
    python check_freshness.py                    # Checks ./
    python check_freshness.py ~/.claude/skills   # Checks specific dir

Reads metadata.last_updated from SKILL.md frontmatter and warns if stale.
"""

import os
import sys
import re
from datetime import datetime, timedelta
from pathlib import Path
from typing import Optional, List


# ANSI colors
RED = "\033[91m"
YELLOW = "\033[93m"
GREEN = "\033[92m"
RESET = "\033[0m"
BOLD = "\033[1m"


def parse_frontmatter(content: str) -> dict:
    """Extract YAML frontmatter from markdown."""
    match = re.match(r"^---\s*\n(.*?)\n---", content, re.DOTALL)
    if not match:
        return {}

    frontmatter = {}
    current_key = None
    indent_level = 0

    for line in match.group(1).split("\n"):
        if not line.strip():
            continue

        # Check for key: value
        kv_match = re.match(r"^(\s*)(\w+):\s*(.*)$", line)
        if kv_match:
            indent = len(kv_match.group(1))
            key = kv_match.group(2)
            value = kv_match.group(3).strip()

            if indent == 0:
                current_key = key
                if value:
                    frontmatter[key] = value
                else:
                    frontmatter[key] = {}
            elif current_key and indent > 0:
                if isinstance(frontmatter.get(current_key), dict):
                    frontmatter[current_key][key] = value

    return frontmatter


def get_skill_info(skill_path: Path) -> Optional[dict]:
    """Extract skill info from SKILL.md."""
    skill_md = skill_path / "SKILL.md"
    if not skill_md.exists():
        return None

    content = skill_md.read_text()
    frontmatter = parse_frontmatter(content)

    name = frontmatter.get("name", skill_path.name)

    # Get last_updated from metadata
    last_updated = None
    if isinstance(frontmatter.get("metadata"), dict):
        last_updated = frontmatter["metadata"].get("last_updated")
    elif "last_updated" in frontmatter:
        last_updated = frontmatter["last_updated"]

    return {
        "name": name,
        "path": str(skill_path),
        "last_updated": last_updated,
    }


def check_freshness(skill_info: dict, max_age_days: int = 180) -> dict:
    """Check if skill is stale."""
    result = {
        **skill_info,
        "status": "unknown",
        "age_days": None,
        "message": "",
    }

    last_updated = skill_info.get("last_updated")

    if not last_updated:
        result["status"] = "no_date"
        result["message"] = "Pas de date last_updated"
        return result

    try:
        # Parse date (supports YYYY-MM-DD)
        update_date = datetime.strptime(str(last_updated), "%Y-%m-%d")
        age = datetime.now() - update_date
        result["age_days"] = age.days

        if age.days > max_age_days:
            result["status"] = "stale"
            result["message"] = f"Obsolète ({age.days} jours)"
        elif age.days > max_age_days // 2:
            result["status"] = "warning"
            result["message"] = f"À surveiller ({age.days} jours)"
        else:
            result["status"] = "fresh"
            result["message"] = f"À jour ({age.days} jours)"

    except ValueError:
        result["status"] = "invalid_date"
        result["message"] = f"Date invalide: {last_updated}"

    return result


def find_skills(directory: Path) -> List[Path]:
    """Find all skill directories (containing SKILL.md)."""
    skills = []

    # Direct children with SKILL.md
    for item in directory.iterdir():
        if item.is_dir() and (item / "SKILL.md").exists():
            skills.append(item)

    return skills


def main():
    # Get directory to check
    if len(sys.argv) > 1:
        base_dir = Path(sys.argv[1]).expanduser()
    else:
        base_dir = Path(".")

    if not base_dir.exists():
        print(f"❌ Répertoire introuvable: {base_dir}", file=sys.stderr)
        sys.exit(1)

    # Find all skills
    skills = find_skills(base_dir)

    if not skills:
        print(f"❌ Aucun skill trouvé dans {base_dir}", file=sys.stderr)
        print("   (Un skill doit contenir un fichier SKILL.md)")
        sys.exit(1)

    # Check freshness
    results = []
    for skill_path in skills:
        info = get_skill_info(skill_path)
        if info:
            results.append(check_freshness(info))

    # Sort by status (stale first)
    status_order = {"stale": 0, "warning": 1, "no_date": 2, "invalid_date": 3, "fresh": 4}
    results.sort(key=lambda x: (status_order.get(x["status"], 5), x["name"]))

    # Print header
    print()
    print(f"{BOLD}📋 VÉRIFICATION DES SKILLS - {base_dir}{RESET}")
    print("=" * 60)
    print()

    # Print results
    stale_count = 0
    warning_count = 0

    for r in results:
        status = r["status"]
        name = r["name"]
        message = r["message"]

        if status == "stale":
            icon = "🔴"
            color = RED
            stale_count += 1
        elif status == "warning":
            icon = "🟠"
            color = YELLOW
            warning_count += 1
        elif status in ("no_date", "invalid_date"):
            icon = "⚪"
            color = YELLOW
            warning_count += 1
        else:
            icon = "🟢"
            color = GREEN

        print(f"  {icon} {color}{name:<30}{RESET} {message}")

    # Print summary
    print()
    print("-" * 60)
    total = len(results)
    fresh = total - stale_count - warning_count

    print(f"  Total: {total} skill(s)")
    print(f"  🟢 À jour: {fresh}")
    if warning_count:
        print(f"  {YELLOW}🟠 À surveiller: {warning_count}{RESET}")
    if stale_count:
        print(f"  {RED}🔴 Obsolètes: {stale_count}{RESET}")
    print()

    # Recommendations for stale skills
    stale_skills = [r for r in results if r["status"] == "stale"]
    if stale_skills:
        print(f"{BOLD}⚠️  ACTIONS REQUISES:{RESET}")
        print()
        print("  Les skills suivants n'ont pas été mis à jour depuis plus de 6 mois.")
        print("  Les chiffres (seuils TVA, taux IS/IR, etc.) peuvent être obsolètes.")
        print()
        print("  📝 Pour chaque skill obsolète:")
        print("     1. Vérifier les seuils et taux sur impots.gouv.fr")
        print("     2. Mettre à jour les références si nécessaire")
        print("     3. Mettre à jour metadata.last_updated dans SKILL.md")
        print()

    # Exit code based on status
    if stale_count > 0:
        sys.exit(2)  # Stale skills found
    elif warning_count > 0:
        sys.exit(1)  # Warnings found
    else:
        sys.exit(0)  # All fresh


if __name__ == "__main__":
    main()
