#!/usr/bin/env python3
"""
Fetch open data for the notaire skill.

Usage:
    # Geocode an address (returns coordinates, code INSEE)
    python scripts/fetch_notaire_data.py geocode "12 rue de Rivoli, Paris"

    # Search DVF transactions in a commune
    python scripts/fetch_notaire_data.py dvf --code-insee 75101 --nature Vente --limit 20

    # Get cadastral parcel info
    python scripts/fetch_notaire_data.py cadastre --code-insee 75101 --section AB --numero 0012

    # Check risks for a location (georisques)
    python scripts/fetch_notaire_data.py risques --lat 48.8566 --lon 2.3522

    # Check urban planning zone (GPU)
    python scripts/fetch_notaire_data.py urbanisme --lat 48.8566 --lon 2.3522

    # Search for a deceased person (matchid)
    python scripts/fetch_notaire_data.py deces --nom "Dupont" --prenom "Jean" --date-naissance "1930-01-01"

    # Search company info (annuaire-entreprises)
    python scripts/fetch_notaire_data.py entreprise "SCI Les Oliviers"

    # Full property report (chains all APIs)
    python scripts/fetch_notaire_data.py rapport "12 rue de Rivoli, Paris"
"""

import argparse
import json
import sys
import urllib.request
import urllib.parse
import urllib.error


BASE_URLS = {
    "ban": "https://api-adresse.data.gouv.fr/search/",
    "dvf": "https://apidf-preprod.cerema.fr/dvf_opendata/mutations/",
    "cadastre": "https://apicarto.ign.fr/api/cadastre/parcelle",
    "georisques": "https://www.georisques.gouv.fr/api/v1/resultats_rapport_risque",
    "gpu": "https://apicarto.ign.fr/api/gpu/zone-urba",
    "entreprise": "https://recherche-entreprises.api.gouv.fr/search",
    "matchid": "https://deces.matchid.io/deces/api/v1/search",
}


def fetch_json(url, method="GET", data=None, content_type=None):
    """Fetch JSON from a URL."""
    headers = {"Accept": "application/json"}
    if content_type:
        headers["Content-Type"] = content_type

    if data and isinstance(data, dict):
        data = json.dumps(data).encode("utf-8")

    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")
        print(f"HTTP {e.code}: {body[:500]}", file=sys.stderr)
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"Connection error: {e.reason}", file=sys.stderr)
        sys.exit(1)


def geocode(address):
    """Geocode an address using BAN API. Returns coordinates and code INSEE."""
    params = urllib.parse.urlencode({"q": address, "limit": 1})
    url = f"{BASE_URLS['ban']}?{params}"
    data = fetch_json(url)

    if not data.get("features"):
        print(f"Adresse non trouvée: {address}", file=sys.stderr)
        sys.exit(1)

    feature = data["features"][0]
    props = feature["properties"]
    coords = feature["geometry"]["coordinates"]  # [lon, lat]

    result = {
        "adresse": props.get("label"),
        "score": props.get("score"),
        "code_insee": props.get("citycode"),
        "code_postal": props.get("postcode"),
        "commune": props.get("city"),
        "latitude": coords[1],
        "longitude": coords[0],
    }
    return result


def search_dvf(code_insee, nature="Vente", limit=20):
    """Search DVF transactions in a commune."""
    params = {
        "code_insee": code_insee,
        "page_size": limit,
        "ordering": "-datemut",
    }
    if nature:
        params["libnatmut"] = nature

    url = f"{BASE_URLS['dvf']}?{urllib.parse.urlencode(params)}"
    data = fetch_json(url)

    results = data.get("results", [])
    transactions = []
    for tx in results:
        transactions.append({
            "date": tx.get("datemut"),
            "nature": tx.get("libnatmut"),
            "valeur_fonciere": tx.get("valeurfonc"),
            "type_bien": tx.get("libtypbien"),
            "surface_bati": tx.get("sbati"),
            "surface_terrain": tx.get("sterr"),
            "parcelles": tx.get("l_idpar", []),
            "vefa": tx.get("vefa"),
            "nb_locaux": tx.get("nblocmut"),
        })

    return {
        "code_insee": code_insee,
        "count": data.get("count", 0),
        "transactions": transactions,
    }


def search_cadastre(code_insee, section=None, numero=None):
    """Search cadastral parcels."""
    params = {"code_insee": code_insee}
    if section:
        params["section"] = section
    if numero:
        params["numero"] = numero

    url = f"{BASE_URLS['cadastre']}?{urllib.parse.urlencode(params)}"
    data = fetch_json(url)

    parcelles = []
    for feature in data.get("features", []):
        props = feature["properties"]
        parcelles.append({
            "commune": props.get("nom_com"),
            "section": props.get("section"),
            "numero": props.get("numero"),
            "contenance": props.get("contenance"),
            "code_arr": props.get("code_arr"),
        })

    return {"code_insee": code_insee, "parcelles": parcelles}


def check_risques(lat, lon):
    """Check risks for a location using Georisques API."""
    url = f"{BASE_URLS['georisques']}?latlon={lon},{lat}"
    data = fetch_json(url)
    return data


def check_urbanisme(lat, lon):
    """Check urban planning zone using GPU API (requires GeoJSON point)."""
    geojson = {
        "type": "Point",
        "coordinates": [lon, lat]
    }
    url = f"{BASE_URLS['gpu']}?geom={json.dumps(geojson)}"
    data = fetch_json(url)

    zones = []
    for feature in data.get("features", []):
        props = feature["properties"]
        zones.append({
            "libelle": props.get("libelle"),
            "libelong": props.get("libelong"),
            "typezone": props.get("typezone"),
            "destdomi": props.get("destdomi"),
            "partition": props.get("partition"),
        })

    return {"latitude": lat, "longitude": lon, "zones": zones}


def search_deces(nom, prenom=None, date_naissance=None):
    """Search deceased persons using MatchID API."""
    params = {"q": nom}
    if prenom:
        params["q"] = f"{prenom} {nom}"
    if date_naissance:
        params["birthDate"] = date_naissance

    url = f"{BASE_URLS['matchid']}?{urllib.parse.urlencode(params)}"
    data = fetch_json(url)

    persons = []
    for hit in data.get("response", {}).get("persons", []):
        persons.append({
            "nom": hit.get("name", {}).get("last", [None])[0],
            "prenoms": hit.get("name", {}).get("first", []),
            "date_naissance": hit.get("birth", {}).get("date"),
            "lieu_naissance": hit.get("birth", {}).get("location", {}).get("city"),
            "date_deces": hit.get("death", {}).get("date"),
            "lieu_deces": hit.get("death", {}).get("location", {}).get("city"),
        })

    return {"count": len(persons), "persons": persons[:10]}


def search_entreprise(query):
    """Search company info using Annuaire Entreprises API."""
    params = {"q": query, "page": 1, "per_page": 5}
    url = f"{BASE_URLS['entreprise']}?{urllib.parse.urlencode(params)}"
    data = fetch_json(url)

    results = []
    for r in data.get("results", []):
        results.append({
            "siren": r.get("siren"),
            "nom": r.get("nom_complet"),
            "nature_juridique": r.get("nature_juridique"),
            "siege": r.get("siege", {}).get("adresse"),
            "date_creation": r.get("date_creation"),
            "dirigeants": r.get("dirigeants", []),
            "nombre_etablissements": r.get("nombre_etablissements"),
        })

    return {"query": query, "count": data.get("total_results", 0), "results": results}


def rapport_complet(address):
    """Full property report: geocode then chain DVF, cadastre, risks, urbanisme."""
    print(f"[1/5] Géocodage: {address}", file=sys.stderr)
    geo = geocode(address)
    print(f"       → {geo['commune']} (INSEE: {geo['code_insee']}), lat={geo['latitude']}, lon={geo['longitude']}", file=sys.stderr)

    print(f"[2/5] DVF: transactions récentes...", file=sys.stderr)
    dvf = search_dvf(geo["code_insee"], limit=10)
    print(f"       → {dvf['count']} transactions trouvées", file=sys.stderr)

    print(f"[3/5] Cadastre...", file=sys.stderr)
    try:
        cadastre = search_cadastre(geo["code_insee"])
        print(f"       → {len(cadastre['parcelles'])} parcelles", file=sys.stderr)
    except SystemExit:
        cadastre = {"error": "Cadastre non disponible pour cette commune"}
        print(f"       → Non disponible", file=sys.stderr)

    print(f"[4/5] Risques (Géorisques)...", file=sys.stderr)
    try:
        risques = check_risques(geo["latitude"], geo["longitude"])
    except SystemExit:
        risques = {"error": "Géorisques non disponible"}
        print(f"       → Non disponible", file=sys.stderr)

    print(f"[5/5] Urbanisme (GPU)...", file=sys.stderr)
    try:
        urbanisme = check_urbanisme(geo["latitude"], geo["longitude"])
        print(f"       → {len(urbanisme['zones'])} zones trouvées", file=sys.stderr)
    except SystemExit:
        urbanisme = {"error": "GPU non disponible"}
        print(f"       → Non disponible", file=sys.stderr)

    return {
        "adresse": geo,
        "dvf": dvf,
        "cadastre": cadastre,
        "risques": risques,
        "urbanisme": urbanisme,
    }


def main():
    parser = argparse.ArgumentParser(description="Fetch open data for the notaire skill")
    subparsers = parser.add_subparsers(dest="command", help="Command to run")

    # geocode
    p_geo = subparsers.add_parser("geocode", help="Geocode an address")
    p_geo.add_argument("address", help="Address to geocode")

    # dvf
    p_dvf = subparsers.add_parser("dvf", help="Search DVF transactions")
    p_dvf.add_argument("--code-insee", required=True, help="Code INSEE of commune")
    p_dvf.add_argument("--nature", default="Vente", help="Nature of transaction")
    p_dvf.add_argument("--limit", type=int, default=20, help="Max results")

    # cadastre
    p_cad = subparsers.add_parser("cadastre", help="Search cadastral parcels")
    p_cad.add_argument("--code-insee", required=True, help="Code INSEE")
    p_cad.add_argument("--section", help="Cadastral section")
    p_cad.add_argument("--numero", help="Parcel number")

    # risques
    p_risk = subparsers.add_parser("risques", help="Check risks at a location")
    p_risk.add_argument("--lat", type=float, required=True, help="Latitude")
    p_risk.add_argument("--lon", type=float, required=True, help="Longitude")

    # urbanisme
    p_urb = subparsers.add_parser("urbanisme", help="Check PLU zone")
    p_urb.add_argument("--lat", type=float, required=True, help="Latitude")
    p_urb.add_argument("--lon", type=float, required=True, help="Longitude")

    # deces
    p_dec = subparsers.add_parser("deces", help="Search deceased persons")
    p_dec.add_argument("--nom", required=True, help="Last name")
    p_dec.add_argument("--prenom", help="First name")
    p_dec.add_argument("--date-naissance", help="Birth date (YYYY-MM-DD)")

    # entreprise
    p_ent = subparsers.add_parser("entreprise", help="Search company info")
    p_ent.add_argument("query", help="Company name to search")

    # rapport
    p_rap = subparsers.add_parser("rapport", help="Full property report")
    p_rap.add_argument("address", help="Property address")

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        sys.exit(1)

    if args.command == "geocode":
        result = geocode(args.address)
    elif args.command == "dvf":
        result = search_dvf(args.code_insee, args.nature, args.limit)
    elif args.command == "cadastre":
        result = search_cadastre(args.code_insee, args.section, args.numero)
    elif args.command == "risques":
        result = check_risques(args.lat, args.lon)
    elif args.command == "urbanisme":
        result = check_urbanisme(args.lat, args.lon)
    elif args.command == "deces":
        result = search_deces(args.nom, args.prenom, args.date_naissance)
    elif args.command == "entreprise":
        result = search_entreprise(args.query)
    elif args.command == "rapport":
        result = rapport_complet(args.address)

    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
