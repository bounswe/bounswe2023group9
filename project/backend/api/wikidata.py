import requests
import json

def search_entity(keyword):
    url = "https://www.wikidata.org/w/api.php"
    params = {
        "action" : "wbsearchentities",
        "language" : "en",
        "format" : "json",
        "search" : keyword 
    }

    response = requests.get(url,params=params)
    my_json = response.content.decode('utf8').replace("'", '"')
    dic = json.loads(my_json)

    results = []
    res = dic.get("search")
    if res is not None:
        for item in res:
            iid = item.get("id")
            display = item.get("display")
            if display is not None:
                label = display.get("label")
                if label is not None:
                    label_value = label.get("value")

                description = display.get("description")
                if description is not None:
                    description_value = description.get("value")
            
            if iid is not None and label_value is not None and description_value is not None:
            
                block = {
                    "id": iid,
                    "label": label_value,
                    "description": description_value
                }

                results.append(block)

    return results

def get_parent_ids(entity_id):
    url = "https://query.wikidata.org/sparql"

    query = """
        SELECT DISTINCT ?itemId
        WHERE {
            {
                wd:""" + entity_id + """ wdt:P31 ?instanceOfEntity.
            } UNION {
                wd:""" + entity_id + """ wdt:P279 ?instanceOfEntity.
            }
            BIND(wikibase:decodeUri(REPLACE(STR(?instanceOfEntity), ".*Q", "Q")) AS ?itemId)
            SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
        }
        """

    params = {
        "format" : "json",
        "query" : query 
        }
    
    response = requests.get(url, params=params)
    my_json = response.content.decode('utf8').replace("'", '"')
    dic = json.loads(my_json)

    idlist = []

    res = dic.get("results")
    if res is not None:
        bindings = res.get("bindings")
        if bindings is not None:
            for item in bindings:
                iid = item.get("itemId")
                if iid is not None:
                    val = iid.get("value")
                    if val is not None:
                        idlist.append(iid.get("value"))

    return idlist

def get_children_ids(entity_id_list):
    url = "https://query.wikidata.org/sparql"

    head = """
        SELECT DISTINCT ?itemId
        WHERE {
    """

    body = """
        {
            ?item wdt:P31 wd:""" + entity_id_list[0] + """
        }
        UNION
        {
            ?item wdt:P279 wd:""" + entity_id_list[0] + """
        }
    """

    for id in entity_id_list[1 : -1]:
        block = """
            UNION
            {
                ?item wdt:P31 wd:""" + id + """
            }
            UNION
            {
                ?item wdt:P279 wd:""" + id + """
            }
        """
        body += block

    tail = """
            BIND(wikibase:decodeUri(REPLACE(STR(?item), ".*Q", "Q")) AS ?itemId)
            SERVICE wikibase:label { bd:serviceParam wikibase:language "[AUTO_LANGUAGE],en". }
        }
    """

    query = head + body + tail

    params = {
        "format" : "json",
        "query" : query 
        }
    
    response = requests.get(url, params=params)
    my_json = response.content.decode('utf8').replace("'", '"')
    dic = json.loads(my_json)

    idlist = []

    res = dic.get("results")
    if res is not None:
        bindings = res.get("bindings")
        if bindings is not None:
            for item in bindings:
                iid = item.get("itemId")
                if iid is not None:
                    val = iid.get("value")
                    if val is not None:
                        idlist.append(iid.get("value"))

    return idlist
