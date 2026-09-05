#!/usr/bin/env python3
import argparse
import json
import shutil
from pathlib import Path


def load(root: Path, name: str):
    return json.loads((root / "install" / name).read_text(encoding="utf-8"))


def skill_names(root: Path, bundle: str, extra: list[str]) -> list[str]:
    item = next((b for b in load(root, "bundles.json")["bundles"] if b["id"] == bundle), None)
    if item is None:
        raise SystemExit(f"Unknown bundle: {bundle}")
    names: list[str] = []
    for name in list(item.get("skills") or []) + extra + ["command-rights"]:
        if name and name not in names:
            names.append(name)
    missing = [n for n in names if not (root / "skills" / n / "SKILL.md").is_file()]
    if missing:
        raise SystemExit(f"Unknown skill: {', '.join(missing)}")
    if not names:
        raise SystemExit("No skills selected. Use --bundle basic or --skill <name>.")
    return names


def grants_for(root: Path, policy_ids: list[str]) -> list[str]:
    spec = load(root, "policies.json")["policies"]
    unknown = [p for p in policy_ids if not any(item["id"] == p for item in spec)]
    if unknown:
        raise SystemExit(f"Unknown policy: {', '.join(unknown)}")
    grants: list[str] = []
    for policy_id in policy_ids:
        item = next(p for p in spec if p["id"] == policy_id)
        for grant in item["grants"]:
            if grant not in grants:
                grants.append(grant)
    return grants


def link_dir(src: Path, dest: Path) -> str:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if dest.exists() or dest.is_symlink():
        if dest.is_dir() and not dest.is_symlink():
            shutil.rmtree(dest)
        else:
            dest.unlink()
    try:
        dest.symlink_to(src, target_is_directory=True)
        return "link"
    except OSError:
        shutil.copytree(src, dest)
        return "copy"


def apply(root: Path, bundle: str, policies: list[str], extra: list[str]) -> None:
    home = Path.home()
    names = skill_names(root, bundle, extra)
    for target in load(root, "targets.json")["targets"]:
        detect = target.get("detect") or []
        active = bool(target.get("always")) or any((home / rel).exists() for rel in detect if rel)
        if not active:
            print(f"skip {target['id']} (tool not on this machine)")
            continue
        for name in names:
            src = root / "skills" / name
            dest = home / target["skillsDir"] / name
            print(f"ok {target['id']} {name} ({link_dir(src, dest)})")
            rule_src = src / "RULE.template.mdc"
            rules_dir = target.get("rulesDir")
            if rules_dir and rule_src.is_file():
                rule_dir = home / rules_dir
                rule_dir.mkdir(parents=True, exist_ok=True)
                shutil.copy2(rule_src, rule_dir / f"{name}.mdc")
                print(f"ok {target['id']} rule {name}")

    grants = grants_for(root, policies)
    config_dir = home / ".skill-sets-god"
    config_dir.mkdir(parents=True, exist_ok=True)
    (config_dir / "config.json").write_text(
        json.dumps({"bundle": bundle, "policies": policies, "grants": grants}, indent=2),
        encoding="utf-8",
    )
    lines = [
        "---",
        "description: Installed command-rights grants for this machine.",
        "alwaysApply: true",
        "---",
        "",
        f"Active policies: {', '.join(policies)}",
        f"Active grants: {', '.join(grants)}",
        "",
        "Follow the command-rights skill.",
        "",
    ]
    labels = {
        "safe-commands": "classify, then run safe in-project commands. Do not ask.",
        "safe-tests": "read test files; run them if they look safe. Do not ask.",
        "auto-review": "read the diff before commit or push. Fix problems, then continue.",
        "auto-commit": "commit when the task is done. No secret files.",
        "auto-push": "push the current branch after a successful commit. No force push.",
    }
    for grant, text in labels.items():
        if grant in grants:
            lines.append(f"- {grant}: {text}")
    lines.extend(["", "Unsafe commands still need one ask. No force-push to main/master.", ""])
    rule_path = home / ".cursor" / "rules" / "command-rights.mdc"
    rule_path.parent.mkdir(parents=True, exist_ok=True)
    rule_path.write_text("\n".join(lines), encoding="utf-8")
    print(f"ok policy {','.join(policies)} grants {', '.join(grants)}")
    warn_path = root / "install" / "warnings.json"
    if warn_path.is_file():
        warnings = json.loads(warn_path.read_text(encoding="utf-8"))
        for grant in grants:
            lines = warnings.get(grant) or []
            if lines:
                print()
                for line in lines:
                    print(line)
                print()


def split_csv(values: list[str]) -> list[str]:
    out: list[str] = []
    for value in values:
        out.extend(part.strip() for part in value.split(",") if part.strip())
    return out


def main() -> None:
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument("--source", required=True)
    parser.add_argument("--bundle", default="basic")
    parser.add_argument("--policy", action="append", default=[])
    parser.add_argument("--skill", action="append", default=[])
    args = parser.parse_args()
    policies = split_csv(args.policy) or ["safe-run"]
    extra = split_csv(args.skill)
    apply(Path(args.source), args.bundle, policies, extra)


if __name__ == "__main__":
    main()
